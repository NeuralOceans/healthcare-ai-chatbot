#!/bin/bash

# GitHub setup script for Healthcare AI Chatbot
# This script helps prepare the repository for GitHub and generates deployment URLs

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📦 Healthcare AI Chatbot - GitHub Setup${NC}"
echo "============================================="
echo ""

# Get GitHub repository information
echo -e "${YELLOW}📝 GitHub Repository Setup${NC}"
echo ""

read -p "Enter your GitHub username: " GITHUB_USERNAME
read -p "Enter your repository name (default: healthcare-ai-chatbot): " REPO_NAME
REPO_NAME=${REPO_NAME:-healthcare-ai-chatbot}

GITHUB_REPO="https://github.com/$GITHUB_USERNAME/$REPO_NAME"
RAW_BASE_URL="https://raw.githubusercontent.com/$GITHUB_USERNAME/$REPO_NAME/main"

echo ""
echo -e "${BLUE}📋 Repository Information:${NC}"
echo "GitHub Repository: $GITHUB_REPO"
echo "Raw Content Base URL: $RAW_BASE_URL"
echo ""

# Generate ARM template URL
ARM_TEMPLATE_URL="$RAW_BASE_URL/deployment/azuredeploy.json"
ENCODED_TEMPLATE_URL=$(printf '%s' "$ARM_TEMPLATE_URL" | python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read().strip()))")
DEPLOY_URL="https://portal.azure.com/#create/Microsoft.Template/uri/$ENCODED_TEMPLATE_URL"

echo -e "${YELLOW}🔗 Generated URLs:${NC}"
echo "ARM Template URL: $ARM_TEMPLATE_URL"
echo "Deploy to Azure URL: $DEPLOY_URL"
echo ""

# Update README.md with correct repository URLs
echo -e "${YELLOW}📝 Updating README.md...${NC}"

# Replace placeholder URLs in README.md
if [ -f "README.md" ]; then
    # Create backup
    cp README.md README.md.backup
    
    # Replace URLs
    sed -i.tmp "s|your-username|$GITHUB_USERNAME|g" README.md
    sed -i.tmp "s|healthcare-ai-chatbot|$REPO_NAME|g" README.md
    rm README.md.tmp 2>/dev/null || true
    
    echo -e "${GREEN}✅ README.md updated with your repository URLs${NC}"
else
    echo -e "${RED}❌ README.md not found${NC}"
    exit 1
fi

# Update deployment documentation
echo -e "${YELLOW}📝 Updating deployment documentation...${NC}"

files_to_update=(
    "deployment/README.md"
    "deployment/one-click-deploy.md"
    "DISTRIBUTION.md"
)

for file in "${files_to_update[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$file.backup"
        sed -i.tmp "s|your-username|$GITHUB_USERNAME|g" "$file"
        sed -i.tmp "s|healthcare-ai-chatbot|$REPO_NAME|g" "$file"
        rm "$file.tmp" 2>/dev/null || true
        echo -e "${GREEN}✅ Updated $file${NC}"
    else
        echo -e "${YELLOW}⚠️  $file not found - skipping${NC}"
    fi
done

# Generate deployment instructions
echo ""
echo -e "${BLUE}📋 Your Deploy to Azure Button:${NC}"
echo ""
echo "Markdown (for README.md):"
echo "[![Deploy to Azure](https://aka.ms/deploytoazurebutton)]($DEPLOY_URL)"
echo ""
echo "HTML (for websites):"
echo "<a href=\"$DEPLOY_URL\" target=\"_blank\">"
echo "    <img src=\"https://aka.ms/deploytoazurebutton\" alt=\"Deploy to Azure\"/>"
echo "</a>"
echo ""

# Create deployment test instructions
cat > deployment-test-instructions.md << EOF
# Deployment Testing Instructions

## Repository Information
- GitHub Repository: $GITHUB_REPO
- ARM Template URL: $ARM_TEMPLATE_URL
- Deploy Button URL: $DEPLOY_URL

## Testing Steps

### 1. Upload to GitHub
\`\`\`bash
# Initialize git repository (if not already done)
git init

# Add all files
git add .

# Commit changes
git commit -m "Initial commit: Healthcare AI Chatbot with one-click Azure deployment"

# Add remote repository
git remote add origin $GITHUB_REPO.git

# Push to GitHub
git push -u origin main
\`\`\`

### 2. Test ARM Template Access
Test that the ARM template is accessible:
\`\`\`bash
curl -I $ARM_TEMPLATE_URL
\`\`\`
Should return HTTP 200 status.

### 3. Test Deploy Button
1. Go to your repository: $GITHUB_REPO
2. Click the "Deploy to Azure" button in the README
3. Verify Azure Portal opens with deployment form
4. Fill in required parameters:
   - OpenAI API Key
   - App Name
   - Resource Group
5. Deploy and test

### 4. Verify Deployment
After deployment completes:
1. Check that all Azure resources were created
2. Access the application URL
3. Test AI form generation functionality
4. Verify Azure storage integration
5. Check Application Insights monitoring

## Troubleshooting

### Common Issues
- **404 on ARM template**: Ensure repository is public and file exists
- **Invalid template**: Validate JSON syntax in deployment/azuredeploy.json
- **Deployment failures**: Check Azure Activity Log for details
- **Application errors**: Review Application Insights logs

### Template Validation
Test ARM template locally:
\`\`\`bash
az deployment group validate \\
  --resource-group test-rg \\
  --template-file deployment/azuredeploy.json \\
  --parameters deployment/azuredeploy.parameters.json
\`\`\`
EOF

echo -e "${GREEN}✅ Created deployment-test-instructions.md${NC}"
echo ""

# Generate git commands
echo -e "${BLUE}🚀 Ready for GitHub Upload${NC}"
echo ""
echo "Run these commands to upload to GitHub:"
echo ""
echo -e "${YELLOW}# Create repository on GitHub first, then run:${NC}"
echo "git init"
echo "git add ."
echo "git commit -m \"Healthcare AI Chatbot with one-click Azure deployment\""
echo "git branch -M main"
echo "git remote add origin $GITHUB_REPO.git"
echo "git push -u origin main"
echo ""

echo -e "${GREEN}🎉 GitHub setup complete!${NC}"
echo ""
echo -e "${BLUE}📋 Next Steps:${NC}"
echo "1. Create repository on GitHub: $GITHUB_REPO"
echo "2. Run the git commands above to upload your code"
echo "3. Test the deploy button from your GitHub repository"
echo "4. Share the repository with others for easy deployment"
echo ""
echo -e "${YELLOW}⚠️  Important:${NC}"
echo "- Ensure your repository is public so ARM templates are accessible"
echo "- Test the deployment yourself before sharing with others"
echo "- Monitor Azure costs after deployment"