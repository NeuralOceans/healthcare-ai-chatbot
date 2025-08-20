# Trend Vision One Integration Setup Guide

## Overview
This guide helps you connect your healthcare AI chatbot to Trend Vision One for centralized security monitoring and compliance management.

## Prerequisites
1. Trend Vision One account with appropriate permissions
2. Azure subscription with deployment access
3. Healthcare AI chatbot deployed on Azure

## Step 1: Configure Trend Vision One

### Access Vision One Console
1. Login to your Trend Vision One console at: https://portal.xdr.trendmicro.com
2. Navigate to **Code Security** section
3. Go to **Artifact Scanner** settings

### Generate API Key
1. Click **Settings** → **API Keys**
2. Create new API key with these permissions:
   - Artifact Scanning
   - Code Security Analysis
   - Compliance Reporting
3. Select region closest to your Azure deployment
4. Save the API key securely

### Configure Container Security Policies
1. Go to **Code Security** → **Policies**
2. Create new policy for healthcare applications:
   - Name: "Healthcare AI Chatbot Policy"
   - Severity thresholds:
     - Critical: Block deployment
     - High: Allow with review
     - Medium/Low: Allow
3. Enable HIPAA compliance checks
4. Configure notification channels

## Step 2: Azure Integration Setup

### Create Azure Resources
Run the automated setup script:
```bash
./deployment/azure-setup.sh
```

This creates:
- Resource groups for staging and production
- Azure Container Registry
- Azure App Services
- Storage accounts for patient data
- Application Insights for monitoring

### Configure Vision One Integration
Add these environment variables to your Azure App Service:

```bash
# Vision One Configuration
VISION_ONE_API_KEY=your_vision_one_api_key
VISION_ONE_REGION=us-1  # or your preferred region
VISION_ONE_ENDPOINT=https://api.xdr.trendmicro.com

# Healthcare Compliance Settings
ENABLE_HIPAA_COMPLIANCE=true
ENABLE_PHI_SCANNING=true
HEALTHCARE_OVERRIDE_CONFIG=true
```

## Step 3: Deploy with Security Scanning

### Using GitHub Actions
1. Add these secrets to your GitHub repository:
   - `VISION_ONE_API_KEY`
   - `AZURE_CLIENT_ID`
   - `AZURE_CLIENT_SECRET`
   - `AZURE_TENANT_ID`
   - `AZURE_SUBSCRIPTION_ID`

2. Push to main branch to trigger deployment:
```bash
git add .
git commit -m "Deploy with Vision One integration"
git push origin main
```

### Manual Azure Deployment
```bash
# Login to Azure
az login

# Build and push container
docker build -t healthcareai .
docker tag healthcareai your-registry.azurecr.io/healthcare-ai-chatbot:latest
docker push your-registry.azurecr.io/healthcare-ai-chatbot:latest

# Deploy to App Service
az webapp config container set \
  --name your-app-name \
  --resource-group your-resource-group \
  --docker-custom-image-name your-registry.azurecr.io/healthcare-ai-chatbot:latest
```

## Step 4: Configure Data Integration

### Patient Data Storage
Your Azure Blob Storage is configured for secure patient data:
- Container: `patient-data`
- Encryption: Enabled by default
- Access: Private only
- Audit logging: Enabled

### Vision One Data Monitoring
Configure Vision One to monitor your data flows:

1. **Code Security Dashboard**:
   - Monitor container vulnerabilities
   - Track dependency updates
   - Review secret detection alerts

2. **Compliance Dashboard**:
   - HIPAA compliance status
   - PHI exposure risks
   - Audit trail reports

3. **Threat Intelligence**:
   - Real-time threat feeds
   - Healthcare-specific indicators
   - Incident response automation

## Step 5: Production Deployment Checklist

### Security Validation
- [ ] TMAS scan passes with no critical issues
- [ ] Vision One policy compliance verified
- [ ] HIPAA requirements met
- [ ] Patient data encryption confirmed

### Azure Configuration
- [ ] App Service configured with proper scaling
- [ ] Storage account secured with private access
- [ ] Application Insights monitoring enabled
- [ ] Backup and disaster recovery configured

### Vision One Integration
- [ ] API connectivity tested
- [ ] Compliance policies active
- [ ] Alerting configured
- [ ] Reporting dashboards accessible

## Step 6: Monitoring and Maintenance

### Daily Operations
1. **Vision One Dashboard Review**:
   - Check security alerts
   - Review compliance status
   - Monitor threat intelligence

2. **Azure Monitoring**:
   - Application performance metrics
   - Resource utilization
   - Error logs and alerts

### Weekly Tasks
1. **Security Review**:
   - Vulnerability scan results
   - Dependency updates needed
   - Compliance drift analysis

2. **Performance Optimization**:
   - Resource scaling adjustments
   - Cost optimization review
   - User experience metrics

### Monthly Activities
1. **Compliance Reporting**:
   - Generate HIPAA compliance reports
   - Review audit logs
   - Update security policies

2. **Disaster Recovery Testing**:
   - Test backup restoration
   - Validate failover procedures
   - Update emergency contacts

## Troubleshooting

### Common Issues

#### Vision One API Connection Errors
```bash
# Test API connectivity
curl -H "Authorization: Bearer $VISION_ONE_API_KEY" \
  https://api.xdr.trendmicro.com/v3.0/healthcheck
```

#### Azure Deployment Failures
```bash
# Check App Service logs
az webapp log tail --name your-app-name --resource-group your-resource-group

# Verify container registry access
az acr check-health --name your-registry
```

#### TMAS Scan Failures
```bash
# Verify TMAS configuration
tmas configure --api-key $VISION_ONE_API_KEY --region $VISION_ONE_REGION
tmas version

# Test basic scan
tmas scan registry:alpine:latest --dry-run
```

### Support Resources
- Vision One Documentation: https://docs.trendmicro.com/vision-one
- Azure Support: https://azure.microsoft.com/support
- Healthcare Compliance Guides: Available in Vision One console

## Next Steps

After successful deployment:
1. Configure automated compliance reporting
2. Set up incident response workflows
3. Integrate with your existing healthcare systems
4. Train your team on Vision One dashboard usage
5. Schedule regular security assessments

Your healthcare AI chatbot is now deployed on Azure with comprehensive security monitoring through Vision One, ensuring HIPAA compliance and patient data protection.