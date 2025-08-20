#!/bin/bash

# Setup script for distributing Healthcare AI Chatbot
# This script prepares the project for easy deployment by others

set -e

echo "🚀 Preparing Healthcare AI Chatbot for distribution..."

# Create distribution directory
DIST_DIR="healthcare-ai-chatbot-distribution"
rm -rf $DIST_DIR
mkdir -p $DIST_DIR

echo "📦 Copying application files..."

# Copy essential application files
cp -r client/ $DIST_DIR/
cp -r server/ $DIST_DIR/
cp -r shared/ $DIST_DIR/
cp -r deployment/ $DIST_DIR/
cp -r scripts/ $DIST_DIR/
cp -r docs/ $DIST_DIR/

# Copy configuration files
cp package.json $DIST_DIR/
cp package-lock.json $DIST_DIR/
cp tsconfig.json $DIST_DIR/
cp vite.config.ts $DIST_DIR/
cp tailwind.config.ts $DIST_DIR/
cp postcss.config.js $DIST_DIR/
cp components.json $DIST_DIR/
cp drizzle.config.ts $DIST_DIR/

# Copy Docker and CI/CD files
cp Dockerfile $DIST_DIR/
cp .dockerignore $DIST_DIR/
cp docker-compose.yml $DIST_DIR/
cp .env.example $DIST_DIR/
cp .github/workflows/ci-cd-with-tmas.yml $DIST_DIR/.github/workflows/
cp azure-pipelines.yml $DIST_DIR/
cp gitlab-ci.yml $DIST_DIR/
cp jenkins/Jenkinsfile $DIST_DIR/jenkins/

# Copy TMAS configuration
cp tmas_healthcare_overrides.yml $DIST_DIR/

# Copy documentation
cp README.md $DIST_DIR/ 2>/dev/null || echo "# Healthcare AI Chatbot" > $DIST_DIR/README.md

echo "📝 Creating deployment instructions..."

# Create main README for distribution
cat > $DIST_DIR/README.md << 'EOF'
# Healthcare AI Chatbot - Ready to Deploy

## Quick Start

### Option 1: One-Click Azure Deployment
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fyour-repo%2Fhealthcare-ai-chatbot%2Fmain%2Fdeployment%2Fazuredeploy.json)

### Option 2: Docker Deployment
```bash
# Copy environment template
cp .env.example .env

# Edit with your credentials
nano .env

# Deploy with Docker Compose
./scripts/docker-compose-deploy.sh
```

### Option 3: Manual Azure Setup
```bash
# Run automated Azure setup
./deployment/azure-setup.sh

# Deploy application
./deployment/azure-deploy.sh
```

## Required Credentials

1. **OpenAI API Key**: Get from platform.openai.com
2. **Azure Storage**: Create storage account in Azure Portal
3. **Vision One API Key**: Optional, from portal.xdr.trendmicro.com

## Features

- AI-powered patient form generation
- Secure Azure Blob Storage integration
- HIPAA compliance built-in
- Trend Vision One security monitoring
- Production-ready Docker containers
- Automated CI/CD pipelines

## Documentation

- [Deployment Guide](deployment/README.md)
- [Vision One Integration](deployment/vision-one-setup.md)
- [TMAS Security Guide](docs/TMAS_INTEGRATION_GUIDE.md)

## Support

Review the documentation in the `deployment/` and `docs/` folders for detailed setup instructions.
EOF

# Create environment setup script
cat > $DIST_DIR/setup-environment.sh << 'EOF'
#!/bin/bash

# Environment setup helper script

echo "🔧 Healthcare AI Chatbot - Environment Setup"
echo ""

# Check if .env exists
if [ -f ".env" ]; then
    echo "✅ .env file already exists"
else
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "✅ Created .env file"
fi

echo ""
echo "Please edit .env file with your credentials:"
echo "1. OPENAI_API_KEY - Get from platform.openai.com"
echo "2. AZURE_STORAGE_ACCOUNT_NAME - Your Azure storage account"
echo "3. AZURE_STORAGE_ACCOUNT_KEY - Your Azure storage key"
echo "4. VISION_ONE_API_KEY - Optional, from portal.xdr.trendmicro.com"
echo ""
echo "Edit command: nano .env"
echo ""
echo "After editing, run: ./scripts/docker-compose-deploy.sh"
EOF

chmod +x $DIST_DIR/setup-environment.sh

# Make scripts executable
chmod +x $DIST_DIR/scripts/*.sh
chmod +x $DIST_DIR/deployment/*.sh

echo "🎁 Creating distribution package..."

# Create a tar.gz package
tar -czf healthcare-ai-chatbot-v1.0.tar.gz $DIST_DIR/

echo ""
echo "✅ Distribution package ready!"
echo ""
echo "📦 Package: healthcare-ai-chatbot-v1.0.tar.gz"
echo "📁 Directory: $DIST_DIR/"
echo ""
echo "🚀 Ready for distribution!"
echo ""
echo "Users can:"
echo "1. Extract the package"
echo "2. Run ./setup-environment.sh"
echo "3. Edit .env with their credentials"
echo "4. Run ./scripts/docker-compose-deploy.sh"
echo ""
echo "Or use the one-click Azure deployment button in README.md"