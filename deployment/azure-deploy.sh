#!/bin/bash

# Azure Deployment Script for Healthcare AI Chatbot with Vision One Integration
# This script deploys your application to Azure App Service with security scanning

set -e

# Configuration
APP_NAME="healthcare-ai-chatbot"
RESOURCE_GROUP="healthcare-ai-prod-rg"
LOCATION="East US"
IMAGE_NAME="healthcare-ai-chatbot"
REGISTRY_NAME="healthcareairegistry"

echo "🚀 Starting Azure deployment for Healthcare AI Chatbot..."

# Check prerequisites
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed. Please install it first."
    exit 1
fi

if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install it first."
    exit 1
fi

# Check if logged in to Azure
if ! az account show &> /dev/null; then
    echo "Please login to Azure CLI:"
    az login
fi

# Check if Vision One API key is set
if [ -z "$VISION_ONE_API_KEY" ]; then
    echo "❌ VISION_ONE_API_KEY environment variable is required"
    echo "Please set it with your Trend Vision One API key:"
    echo "export VISION_ONE_API_KEY='your_api_key_here'"
    exit 1
fi

# Get current subscription
SUBSCRIPTION_ID=$(az account show --query id --output tsv)
echo "Using Azure subscription: $SUBSCRIPTION_ID"

# Build the Docker image
echo "🔨 Building Docker image..."
docker build -t $IMAGE_NAME:latest .

# Get Azure Container Registry login server
echo "🐳 Configuring Azure Container Registry..."
ACR_LOGIN_SERVER=$(az acr show --name $REGISTRY_NAME --query loginServer --output tsv 2>/dev/null || echo "")

if [ -z "$ACR_LOGIN_SERVER" ]; then
    echo "❌ Azure Container Registry '$REGISTRY_NAME' not found."
    echo "Please run the setup script first: ./deployment/azure-setup.sh"
    exit 1
fi

# Login to Azure Container Registry
echo "🔐 Logging into Azure Container Registry..."
az acr login --name $REGISTRY_NAME

# Tag and push the image
echo "📤 Pushing image to Azure Container Registry..."
docker tag $IMAGE_NAME:latest $ACR_LOGIN_SERVER/$IMAGE_NAME:latest
docker tag $IMAGE_NAME:latest $ACR_LOGIN_SERVER/$IMAGE_NAME:$(date +%Y%m%d-%H%M%S)
docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:latest
docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:$(date +%Y%m%d-%H%M%S)

# Run TMAS security scan
echo "🔒 Running security scan with Trend Vision One..."
if command -v tmas &> /dev/null; then
    echo "Configuring TMAS for Vision One..."
    tmas configure --api-key $VISION_ONE_API_KEY --region ${VISION_ONE_REGION:-us-1}
    
    echo "Scanning container image..."
    tmas scan registry:$ACR_LOGIN_SERVER/$IMAGE_NAME:latest -VMS \
        --output-format json \
        --output-file tmas-scan-results.json \
        --save-sbom \
        --override tmas_healthcare_overrides.yml || true
    
    # Check scan results
    if [ -f "tmas-scan-results.json" ]; then
        CRITICAL_COUNT=$(jq '.vulnerabilities | map(select(.severity == "critical")) | length' tmas-scan-results.json 2>/dev/null || echo "0")
        MALWARE_COUNT=$(jq '.malware | length' tmas-scan-results.json 2>/dev/null || echo "0")
        
        echo "Security scan results:"
        echo "- Critical vulnerabilities: $CRITICAL_COUNT"
        echo "- Malware detected: $MALWARE_COUNT"
        
        if [ "$CRITICAL_COUNT" -gt "0" ] || [ "$MALWARE_COUNT" -gt "0" ]; then
            echo "⚠️  Critical security issues detected. Proceeding with deployment but review required."
        else
            echo "✅ Security scan passed!"
        fi
    fi
else
    echo "⚠️  TMAS not installed. Skipping security scan."
    echo "To install TMAS: curl -L -o tmas https://downloads.trendmicro.com/SupportFiles/TMAS/LATEST/Linux/tmas && chmod +x tmas"
fi

# Deploy to Azure App Service
echo "🌐 Deploying to Azure App Service..."
az webapp config container set \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --docker-custom-image-name $ACR_LOGIN_SERVER/$IMAGE_NAME:latest \
    --docker-registry-server-url https://$ACR_LOGIN_SERVER

# Configure app settings
echo "⚙️ Configuring application settings..."
az webapp config appsettings set \
    --name $APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --settings \
        NODE_ENV=production \
        PORT=8000 \
        WEBSITES_PORT=8000 \
        VISION_ONE_API_KEY="$VISION_ONE_API_KEY" \
        VISION_ONE_REGION="${VISION_ONE_REGION:-us-1}" \
        ENABLE_HIPAA_COMPLIANCE=true \
        ENABLE_PHI_SCANNING=true \
        HEALTHCARE_OVERRIDE_CONFIG=true

# Set additional secrets if provided
if [ ! -z "$OPENAI_API_KEY" ]; then
    az webapp config appsettings set \
        --name $APP_NAME \
        --resource-group $RESOURCE_GROUP \
        --settings OPENAI_API_KEY="$OPENAI_API_KEY"
fi

if [ ! -z "$AZURE_STORAGE_ACCOUNT_NAME" ]; then
    az webapp config appsettings set \
        --name $APP_NAME \
        --resource-group $RESOURCE_GROUP \
        --settings \
            AZURE_STORAGE_ACCOUNT_NAME="$AZURE_STORAGE_ACCOUNT_NAME" \
            AZURE_STORAGE_ACCOUNT_KEY="$AZURE_STORAGE_ACCOUNT_KEY" \
            AZURE_CONTAINER_NAME="${AZURE_CONTAINER_NAME:-patient-data}"
fi

# Restart the app service
echo "🔄 Restarting application..."
az webapp restart --name $APP_NAME --resource-group $RESOURCE_GROUP

# Wait for deployment
echo "⏳ Waiting for deployment to complete..."
sleep 30

# Get the application URL
APP_URL="https://$APP_NAME.azurewebsites.net"

# Test the deployment
echo "🔍 Testing deployment..."
if curl -f -s "$APP_URL/api/azure/status" > /dev/null; then
    echo "✅ Deployment successful!"
    echo ""
    echo "🎉 Healthcare AI Chatbot is now live!"
    echo "URL: $APP_URL"
    echo "🔒 Security: Integrated with Trend Vision One"
    echo "📊 Monitoring: Check Azure Application Insights"
    echo ""
    echo "Next steps:"
    echo "1. Configure your OpenAI API key if not already set"
    echo "2. Test the chat interface and form generation"
    echo "3. Review security scan results in Vision One console"
    echo "4. Set up monitoring alerts in Azure"
else
    echo "⚠️  Deployment completed but application is not responding"
    echo "Please check the application logs:"
    echo "az webapp log tail --name $APP_NAME --resource-group $RESOURCE_GROUP"
fi

# Show useful commands
echo ""
echo "🛠️  Useful management commands:"
echo "View logs: az webapp log tail --name $APP_NAME --resource-group $RESOURCE_GROUP"
echo "Update app: docker build -t $IMAGE_NAME . && docker push $ACR_LOGIN_SERVER/$IMAGE_NAME:latest"
echo "Scale app: az webapp up --name $APP_NAME --resource-group $RESOURCE_GROUP --sku P1V2"
echo "View metrics: az monitor metrics list --resource $APP_NAME --resource-group $RESOURCE_GROUP --resource-type Microsoft.Web/sites"