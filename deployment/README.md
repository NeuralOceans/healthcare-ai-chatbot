# Healthcare AI Chatbot - Deployment Guide

## Quick Deployment to Your Azure Account

This guide helps you deploy the Healthcare AI Chatbot to your own Azure subscription in under 10 minutes.

## Prerequisites

- Azure subscription
- OpenAI API key
- Docker installed locally (optional)
- Azure CLI (for automated setup)

## Option 1: One-Click Azure Deployment

### Step 1: One-Click Deployment
Click this button to automatically create all required Azure resources and deploy the application:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FNeuralOceans%2Fhealthcare-ai-chatbot%2Fmain%2Fdeployment%2Fazuredeploy.json)

**What this button does:**
- Creates App Service with Linux container support
- Sets up Storage Account with GRS redundancy and HIPAA compliance  
- Configures Application Insights monitoring
- Establishes security controls (HTTPS only, TLS 1.2, private storage)
- Pre-configures all healthcare compliance settings
- Takes 5-10 minutes from click to running application

### Step 2: Configure Application
After deployment, add these application settings in Azure Portal:

1. Go to your App Service in Azure Portal
2. Navigate to **Configuration** → **Application settings**
3. Add these settings:

| Name | Value | Description |
|------|--------|-------------|
| `OPENAI_API_KEY` | `your_openai_key` | Get from platform.openai.com |
| `AZURE_STORAGE_ACCOUNT_NAME` | `auto-created` | Will be provided after deployment |
| `AZURE_STORAGE_ACCOUNT_KEY` | `auto-created` | Will be provided after deployment |
| `AZURE_CONTAINER_NAME` | `patient-data` | Storage container name |
| `NODE_ENV` | `production` | Environment setting |
| `ENABLE_HIPAA_COMPLIANCE` | `true` | Healthcare compliance |

## Option 2: Manual Setup

### Step 1: Clone the Repository
```bash
git clone https://github.com/your-repo/healthcare-ai-chatbot.git
cd healthcare-ai-chatbot
```

### Step 2: Create Azure Resources
```bash
# Login to Azure
az login

# Run automated setup
chmod +x deployment/azure-setup.sh
./deployment/azure-setup.sh
```

### Step 3: Configure Environment Variables
Copy the provided values from the setup script output and configure in Azure Portal.

### Step 4: Deploy Application
```bash
# Deploy using the deployment script
chmod +x deployment/azure-deploy.sh
export VISION_ONE_API_KEY="your_key_here"  # Optional
./deployment/azure-deploy.sh
```

## Option 3: Docker Container Deployment

### Local Testing
```bash
# Copy environment template
cp .env.example .env

# Edit with your values
nano .env

# Deploy with Docker Compose
chmod +x scripts/docker-compose-deploy.sh
./scripts/docker-compose-deploy.sh
```

### Azure Container Instances
```bash
# Deploy container to Azure
az container create \
  --resource-group your-resource-group \
  --name healthcare-ai \
  --image your-registry.azurecr.io/healthcare-ai-chatbot:latest \
  --ports 5000 \
  --environment-variables \
    OPENAI_API_KEY=your_key \
    AZURE_STORAGE_ACCOUNT_NAME=your_storage \
    AZURE_STORAGE_ACCOUNT_KEY=your_key
```

## Required Environment Variables

### Essential (Required)
- `OPENAI_API_KEY`: Your OpenAI API key from platform.openai.com
- `AZURE_STORAGE_ACCOUNT_NAME`: Azure storage account name
- `AZURE_STORAGE_ACCOUNT_KEY`: Azure storage account access key

### Optional (Enhanced Features)
- `VISION_ONE_API_KEY`: Trend Vision One API key for security monitoring
- `VISION_ONE_REGION`: Vision One region (default: us-1)
- `AZURE_CONTAINER_NAME`: Storage container name (default: patient-data)

## Security Configuration

### HIPAA Compliance
The application includes built-in HIPAA compliance features:
- Encrypted data storage
- Audit logging
- Access controls
- PHI protection patterns

### Security Scanning
If you have Trend Vision One:
- Add your Vision One API key
- Security scans run automatically
- Compliance reports generated
- Threat monitoring enabled

## Post-Deployment Steps

1. **Test the Application**
   - Visit your Azure App Service URL
   - Test the chat interface
   - Generate sample patient data
   - Verify Azure storage integration

2. **Configure Monitoring**
   - Set up Application Insights alerts
   - Configure log analytics
   - Enable health checks

3. **Security Review**
   - Review access permissions
   - Enable Azure Security Center
   - Configure backup policies

## Troubleshooting

### Common Issues

**Application not starting:**
- Check application logs in Azure Portal
- Verify all environment variables are set
- Ensure OpenAI API key is valid

**Storage connection errors:**
- Verify storage account credentials
- Check network access policies
- Ensure container exists

**Build failures:**
- Check resource quotas
- Verify subscription permissions
- Review deployment logs

### Getting Help

- Check Azure deployment logs
- Review application logs
- Contact support with deployment details

## Cost Estimation

Typical monthly costs for production use:
- Azure App Service (B1): ~$13/month
- Azure Storage: ~$5/month
- Application Insights: ~$2/month
- **Total: ~$20/month**

*Costs may vary based on usage and region*

## Advanced Configuration

### Custom Domain
Configure a custom domain in Azure App Service settings.

### SSL Certificate
Azure provides free SSL certificates for custom domains.

### Auto-scaling
Configure auto-scaling rules based on CPU/memory usage.

### Backup and Recovery
Set up automated backups for your application and data.

## Support

For deployment issues or questions:
- Review this documentation
- Check Azure documentation
- Open an issue in the repository
- Contact your Azure support team

---

Your Healthcare AI Chatbot will be securely deployed with enterprise-grade security, HIPAA compliance, and production-ready configuration.