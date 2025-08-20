#!/bin/bash

# Test script for Healthcare AI Chatbot deployment
# This script helps test the one-click Azure deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Healthcare AI Chatbot - Deployment Testing${NC}"
echo "=================================================="
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to test URL response
test_url() {
    local url=$1
    local expected_status=$2
    local description=$3
    
    echo -n "Testing $description... "
    
    if command_exists curl; then
        status=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
        if [ "$status" = "$expected_status" ]; then
            echo -e "${GREEN}✅ PASS${NC} (HTTP $status)"
            return 0
        else
            echo -e "${RED}❌ FAIL${NC} (HTTP $status, expected $expected_status)"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  SKIP${NC} (curl not available)"
        return 0
    fi
}

# Test 1: Check if ARM template is valid JSON
echo -e "${YELLOW}🔍 Test 1: ARM Template Validation${NC}"
if [ -f "deployment/azuredeploy.json" ]; then
    if command_exists jq; then
        if jq empty deployment/azuredeploy.json >/dev/null 2>&1; then
            echo -e "${GREEN}✅ ARM template is valid JSON${NC}"
        else
            echo -e "${RED}❌ ARM template has JSON syntax errors${NC}"
            exit 1
        fi
    elif command_exists python3; then
        if python3 -m json.tool deployment/azuredeploy.json >/dev/null 2>&1; then
            echo -e "${GREEN}✅ ARM template is valid JSON${NC}"
        else
            echo -e "${RED}❌ ARM template has JSON syntax errors${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}⚠️  Cannot validate JSON (jq or python3 required)${NC}"
    fi
else
    echo -e "${RED}❌ ARM template not found${NC}"
    exit 1
fi

# Test 2: Check required files exist
echo ""
echo -e "${YELLOW}🔍 Test 2: Required Files Check${NC}"
required_files=(
    "deployment/azuredeploy.json"
    "deployment/azuredeploy.parameters.json"
    "deployment/README.md"
    "deployment/one-click-deploy.md"
    "Dockerfile"
    "docker-compose.yml"
    ".env.example"
    "package.json"
)

missing_files=0
for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${RED}❌ $file (missing)${NC}"
        missing_files=$((missing_files + 1))
    fi
done

if [ $missing_files -gt 0 ]; then
    echo -e "${RED}❌ $missing_files required files are missing${NC}"
    exit 1
fi

# Test 3: Check environment template
echo ""
echo -e "${YELLOW}🔍 Test 3: Environment Template Check${NC}"
if [ -f ".env.example" ]; then
    required_vars=("OPENAI_API_KEY" "AZURE_STORAGE_ACCOUNT_NAME" "AZURE_STORAGE_ACCOUNT_KEY")
    missing_vars=0
    
    for var in "${required_vars[@]}"; do
        if grep -q "^$var=" .env.example; then
            echo -e "${GREEN}✅ $var${NC}"
        else
            echo -e "${RED}❌ $var (missing from .env.example)${NC}"
            missing_vars=$((missing_vars + 1))
        fi
    done
    
    if [ $missing_vars -gt 0 ]; then
        echo -e "${RED}❌ $missing_vars required environment variables missing${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ .env.example not found${NC}"
    exit 1
fi

# Test 4: Docker build test (if Docker is available)
echo ""
echo -e "${YELLOW}🔍 Test 4: Docker Build Test${NC}"
if command_exists docker; then
    if [ -f "Dockerfile" ]; then
        echo "Building Docker image for testing..."
        if docker build -t healthcare-ai-test . >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Docker image builds successfully${NC}"
            docker rmi healthcare-ai-test >/dev/null 2>&1 || true
        else
            echo -e "${RED}❌ Docker build failed${NC}"
            exit 1
        fi
    else
        echo -e "${RED}❌ Dockerfile not found${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}⚠️  Docker not available - skipping build test${NC}"
fi

# Test 5: GitHub repository structure
echo ""
echo -e "${YELLOW}🔍 Test 5: GitHub Repository Structure${NC}"
github_files=(
    ".github/workflows/ci-cd-with-tmas.yml"
    ".github/ISSUE_TEMPLATE/bug_report.md"
    ".github/ISSUE_TEMPLATE/feature_request.md"
    "README.md"
)

for file in "${github_files[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✅ $file${NC}"
    else
        echo -e "${YELLOW}⚠️  $file (recommended for GitHub)${NC}"
    fi
done

# Test 6: ARM template required parameters
echo ""
echo -e "${YELLOW}🔍 Test 6: ARM Template Parameters${NC}"
if command_exists jq; then
    required_params=("openAiApiKey")
    for param in "${required_params[@]}"; do
        if jq -e ".parameters.$param" deployment/azuredeploy.json >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Parameter: $param${NC}"
        else
            echo -e "${RED}❌ Missing required parameter: $param${NC}"
            exit 1
        fi
    done
fi

# Test 7: Generate deploy button URL
echo ""
echo -e "${YELLOW}🔍 Test 7: Deploy Button URL Generation${NC}"

# Check if we can generate a valid deploy button URL
if [ -f "deployment/azuredeploy.json" ]; then
    # Simulate GitHub raw URL (replace with actual repo URL when known)
    GITHUB_REPO="https://github.com/your-username/healthcare-ai-chatbot"
    RAW_TEMPLATE_URL="${GITHUB_REPO/github.com/raw.githubusercontent.com}/main/deployment/azuredeploy.json"
    ENCODED_URL=$(printf '%s' "$RAW_TEMPLATE_URL" | jq -sRr @uri)
    DEPLOY_URL="https://portal.azure.com/#create/Microsoft.Template/uri/$ENCODED_URL"
    
    echo -e "${GREEN}✅ Deploy button URL generated${NC}"
    echo "   Raw template URL: $RAW_TEMPLATE_URL"
    echo "   Deploy URL: $DEPLOY_URL"
else
    echo -e "${RED}❌ Cannot generate deploy button URL${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 All tests passed!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps for Testing One-Click Deployment:${NC}"
echo "1. Create a GitHub repository"
echo "2. Push this code to the repository"
echo "3. Update the deploy button URL in README.md with your actual repository"
echo "4. Test the deploy button by clicking it"
echo ""
echo -e "${BLUE}🔗 Example deploy button for your repository:${NC}"
echo '[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/YOUR_ENCODED_TEMPLATE_URL)'
echo ""
echo -e "${YELLOW}⚠️  Remember to:${NC}"
echo "- Replace 'your-username' with your actual GitHub username"
echo "- Test with a real Azure subscription"
echo "- Verify all resources are created correctly"
echo "- Test the application functionality after deployment"