# Healthcare AI Chatbot

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fyour-username%2Fhealthcare-ai-chatbot%2Fmain%2Fdeployment%2Fazuredeploy.json)

## Overview

A healthcare patient data management system that combines AI-powered form generation with secure cloud storage. Generate realistic patient information using OpenAI's GPT-4o model and store it securely in Azure Blob Storage with HIPAA compliance.

## Features

- **AI-Powered Form Generation**: Generate realistic patient data for testing
- **Secure Azure Storage**: HIPAA-compliant data storage with encryption
- **Modern React Interface**: Chat-based AI assistant with form management
- **Enterprise Security**: Built-in Trend Micro security scanning and monitoring
- **One-Click Deployment**: Deploy to your Azure account in under 10 minutes

## Quick Start

### Option 1: One-Click Azure Deployment (Recommended)

Deploy directly to your Azure account with all resources pre-configured:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FNeuralOceans%2Fhealthcare-ai-chatbot%2Fmain%2Fdeployment%2Fazuredeploy.json)

**What you'll need:**
- Azure subscription
- OpenAI API key from [platform.openai.com](https://platform.openai.com)

**What gets created:**
- App Service with healthcare AI application
- Storage Account with HIPAA compliance
- Application Insights monitoring
- All security configurations

**Monthly cost:** ~$20 (App Service $13 + Storage $5 + Monitoring $2)

### Option 2: Docker Deployment

```bash
# Clone the repository
git clone https://github.com/your-username/healthcare-ai-chatbot.git
cd healthcare-ai-chatbot

# Setup environment
cp .env.example .env
nano .env  # Add your API keys

# Deploy with Docker Compose
./scripts/docker-compose-deploy.sh
```

### Option 3: Local Development

```bash
# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Add your OPENAI_API_KEY and Azure credentials

# Start development server
npm run dev
```

## Required Environment Variables

```bash
# Essential
OPENAI_API_KEY=sk-your-openai-key
AZURE_STORAGE_ACCOUNT_NAME=your-storage-account
AZURE_STORAGE_ACCOUNT_KEY=your-storage-key

# Optional (Enhanced Security)
VISION_ONE_API_KEY=your-vision-one-key
VISION_ONE_REGION=us-1
```

## Architecture

- **Frontend**: React 18 + TypeScript + Tailwind CSS + shadcn/ui
- **Backend**: Node.js + Express + TypeScript
- **Database**: Drizzle ORM (configured for PostgreSQL, currently using in-memory)
- **Storage**: Azure Blob Storage with HIPAA compliance
- **AI**: OpenAI GPT-4o for patient data generation
- **Security**: Trend Micro Artifact Scanner (TMAS) integration
- **Deployment**: Docker containers + Azure ARM templates

## Security & Compliance

- **HIPAA Compliance**: Built-in healthcare data protection
- **Encryption**: Data encrypted in transit and at rest
- **Security Scanning**: Automated vulnerability and malware detection
- **Access Controls**: Private storage with role-based access
- **Audit Logging**: Comprehensive activity tracking

## CI/CD Pipelines

Pre-configured pipelines for multiple platforms:
- GitHub Actions (`.github/workflows/ci-cd-with-tmas.yml`)
- Azure DevOps (`azure-pipelines.yml`)
- GitLab CI (`gitlab-ci.yml`)
- Jenkins (`jenkins/Jenkinsfile`)

## Documentation

- [One-Click Deployment Guide](deployment/one-click-deploy.md)
- [Complete Deployment Options](deployment/README.md)
- [TMAS Security Integration](docs/TMAS_INTEGRATION_GUIDE.md)
- [Distribution Guide](DISTRIBUTION.md)

## Support

### Troubleshooting

**Common Issues:**
- **OpenAI API errors**: Verify your API key and billing status
- **Azure storage connection**: Check storage account credentials
- **Deployment failures**: Review Azure Activity Log for details

**Getting Help:**
- Review documentation in `deployment/` folder
- Check Application Insights for error logs
- Open an issue for bug reports

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run security scans: `./scripts/run-security-checks.sh`
5. Submit a pull request

## License

This project is licensed under an Educational Use License - see the LICENSE.txt file for details.

**Copyright (c) 2025 Scarlett Menendez, Neural Oceans**

This software is provided for personal and educational use only. Commercial use is strictly prohibited.

## Disclaimer

This application generates synthetic patient data for testing purposes only. Do not use with real patient information without proper HIPAA compliance review and approval from your organization's compliance team.