#!/bin/bash

# Automated Azure setup script for Healthcare AI Chatbot
# This script creates all required Azure resources for one-click deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🏥 Healthcare AI Chatbot - Azure Setup${NC}"
echo "=============================================="
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo -e "${RED}❌ Azure CLI is not installed${NC}"
    echo "Please install Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check if user is logged in
if ! az account show &> /dev/null; then
    echo -e "${YELLOW}🔑 Please log in to Azure...${NC}"
    az login
fi

# Get current subscription
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
echo -e "${GREEN}✅ Using subscription: $SUBSCRIPTION_ID${NC}"

# Set default values
RESOURCE_GROUP_NAME="healthcare-ai-rg"
LOCATION="East US"
APP_NAME="healthcare-ai-$(date +%s)"
STORAGE_ACCOUNT_NAME="healthcareai$(date +%s)"

echo ""
echo -e "${BLUE}📝 Configuration:${NC}"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Location: $LOCATION" 
echo "App Name: $APP_NAME"
echo "Storage Account: $STORAGE_ACCOUNT_NAME"
echo ""

read -p "Press Enter to continue or Ctrl+C to cancel..."

echo ""
echo -e "${YELLOW}🏗️ Creating Azure resources...${NC}"

# Create resource group
echo "Creating resource group..."
az group create --name $RESOURCE_GROUP_NAME --location "$LOCATION"

# Create storage account
echo "Creating storage account..."
az storage account create \
    --name $STORAGE_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_NAME \
    --location "$LOCATION" \
    --sku Standard_GRS \
    --kind StorageV2 \
    --min-tls-version TLS1_2 \
    --allow-blob-public-access false \
    --https-only true

# Get storage account key
STORAGE_KEY=$(az storage account keys list \
    --resource-group $RESOURCE_GROUP_NAME \
    --account-name $STORAGE_ACCOUNT_NAME \
    --query '[0].value' -o tsv)

# Create blob container
echo "Creating blob container..."
az storage container create \
    --name patient-data \
    --account-name $STORAGE_ACCOUNT_NAME \
    --account-key $STORAGE_KEY \
    --public-access off

# Create App Service Plan
echo "Creating App Service Plan..."
az appservice plan create \
    --name "${APP_NAME}-plan" \
    --resource-group $RESOURCE_GROUP_NAME \
    --location "$LOCATION" \
    --is-linux \
    --sku B1

# Create Application Insights
echo "Creating Application Insights..."
az monitor app-insights component create \
    --app "${APP_NAME}-insights" \
    --location "$LOCATION" \
    --resource-group $RESOURCE_GROUP_NAME \
    --kind web \
    --application-type web

# Get Application Insights connection string
APPINSIGHTS_CONNECTION_STRING=$(az monitor app-insights component show \
    --app "${APP_NAME}-insights" \
    --resource-group $RESOURCE_GROUP_NAME \
    --query connectionString -o tsv)

# Create Web App
echo "Creating Web App..."
az webapp create \
    --resource-group $RESOURCE_GROUP_NAME \
    --plan "${APP_NAME}-plan" \
    --name $APP_NAME \
    --deployment-container-image-name "nginx:latest"

# Configure Web App settings
echo "Configuring Web App settings..."
az webapp config appsettings set \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $APP_NAME \
    --settings \
        NODE_ENV=production \
        PORT=8000 \
        WEBSITES_PORT=8000 \
        AZURE_STORAGE_ACCOUNT_NAME=$STORAGE_ACCOUNT_NAME \
        AZURE_STORAGE_ACCOUNT_KEY=$STORAGE_KEY \
        AZURE_CONTAINER_NAME=patient-data \
        ENABLE_HIPAA_COMPLIANCE=true \
        ENABLE_PHI_SCANNING=true \
        VISION_ONE_REGION=us-1 \
        APPLICATIONINSIGHTS_CONNECTION_STRING="$APPINSIGHTS_CONNECTION_STRING"

# Configure HTTPS only
az webapp update \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $APP_NAME \
    --https-only true

echo ""
echo -e "${GREEN}✅ Azure resources created successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Deployment Information:${NC}"
echo "=============================================="
echo "App Service URL: https://${APP_NAME}.azurewebsites.net"
echo "Resource Group: $RESOURCE_GROUP_NAME"
echo "Storage Account: $STORAGE_ACCOUNT_NAME"
echo "Storage Key: $STORAGE_KEY"
echo ""
echo -e "${YELLOW}⚠️  Next Steps:${NC}"
echo "1. Add your OpenAI API key to the Web App settings"
echo "2. (Optional) Add Vision One API key for security monitoring"
echo "3. Deploy your application container"
echo ""
echo -e "${BLUE}🔧 To add API keys:${NC}"
echo "az webapp config appsettings set \\"
echo "  --resource-group $RESOURCE_GROUP_NAME \\"
echo "  --name $APP_NAME \\"
echo "  --settings OPENAI_API_KEY=your_openai_key_here"
echo ""
echo -e "${GREEN}🎉 Setup complete! Your Healthcare AI infrastructure is ready.${NC}"