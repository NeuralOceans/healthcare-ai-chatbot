# One-Click Azure Deployment Guide

## Deploy Healthcare AI Chatbot to Your Azure Account

This guide shows you how to deploy the Healthcare AI Chatbot to your Azure account with a single click.

## Prerequisites

- Azure subscription
- OpenAI API key from [platform.openai.com](https://platform.openai.com)

## One-Click Deployment

### Step 1: Click Deploy Button

Click this button to start the automated deployment:

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fyour-repo%2Fhealthcare-ai-chatbot%2Fmain%2Fdeployment%2Fazuredeploy.json)

### Step 2: Fill Deployment Form

The Azure Portal will open with a deployment form. Fill in:

| Field | Value | Description |
|-------|--------|-------------|
| **Subscription** | Your Azure subscription | Choose your active subscription |
| **Resource group** | `healthcare-ai-rg` | Create new or use existing |
| **Region** | `East US` | Choose region closest to you |
| **App Name** | `healthcare-ai-yourname` | Unique name for your app |
| **Open Ai Api Key** | `sk-your-key-here` | Your OpenAI API key |
| **Vision One Api Key** | Leave empty | Optional security monitoring |
| **Sku** | `B1` | App Service plan size |

### Step 3: Review and Create

1. Click **"Review + create"**
2. Azure validates your template
3. Click **"Create"** to start deployment
4. Wait 5-10 minutes for completion

### Step 4: Access Your Application

After deployment completes:

1. Go to **Resource Groups** → **healthcare-ai-rg**
2. Click on your **App Service** (healthcare-ai-yourname)
3. Click **"Browse"** to open your application
4. Your Healthcare AI Chatbot is now running!

## What Gets Created

The one-click deployment automatically creates:

### Azure Resources
- **App Service**: Hosts your Healthcare AI application
- **App Service Plan (B1)**: Compute resources for your app
- **Storage Account (GRS)**: Secure patient data storage with geo-redundancy
- **Blob Container**: "patient-data" container for storing generated data
- **Application Insights**: Monitoring and analytics
- **Log Analytics Workspace**: Centralized logging

### Security Features
- **HTTPS Only**: All traffic encrypted
- **TLS 1.2 Minimum**: Latest security protocols
- **Private Storage**: No public access to patient data
- **Soft Delete**: 30-day recovery for deleted data
- **Versioning**: Keep history of data changes
- **HIPAA Compliance**: Healthcare-ready configuration

### Monitoring & Logging
- **Application Performance Monitoring**: Track app health
- **Error Tracking**: Automatic error detection
- **Usage Analytics**: User interaction insights
- **Health Checks**: Automatic availability monitoring

## Post-Deployment Configuration

### Optional: Add Security Monitoring

If you have Trend Vision One:

1. Go to your **App Service** → **Configuration**
2. Add new application setting:
   - **Name**: `VISION_ONE_API_KEY`
   - **Value**: Your Vision One API key
3. Click **Save**

### Optional: Custom Domain

To use your own domain:

1. Go to **App Service** → **Custom domains**
2. Add your domain
3. Configure DNS records
4. Azure provides free SSL certificate

## Testing Your Deployment

### Basic Functionality Test

1. Open your application URL
2. You should see the Healthcare AI dashboard
3. Try the chat interface - ask "Generate a patient form"
4. Verify the patient form appears and can be filled
5. Click "Submit to Azure" to test storage integration

### Verify Azure Storage

1. Go to **Storage Account** → **Containers**
2. Click **"patient-data"** container
3. Generate and submit a patient form in your app
4. Refresh - you should see a new JSON file with patient data

### Check Monitoring

1. Go to **Application Insights** → **Live Metrics**
2. Use your application - you'll see real-time metrics
3. Go to **Failures** to check for any errors

## Monthly Costs

Your one-click deployment costs approximately:

- **App Service B1**: $13.14/month
- **Storage Account**: $5.00/month
- **Application Insights**: $2.30/month
- **Total**: **~$20/month**

*Costs may vary by region and usage*

## Troubleshooting

### Common Issues

**"Template deployment failed"**
- Check your OpenAI API key is valid
- Ensure your Azure subscription has sufficient permissions
- Try a different region if resources are unavailable

**"Application Error" on website**
- Verify OpenAI API key is correctly set
- Check Application Insights logs for detailed errors
- Restart the App Service

**"Storage connection failed"**
- Storage account and keys are configured automatically
- Check if storage account creation completed successfully

### Getting Help

1. Check **Application Insights** → **Failures** for error details
2. Go to **App Service** → **Log stream** for real-time logs
3. Review **Activity log** in resource group for deployment issues

## Security Best Practices

Your one-click deployment includes enterprise security:

- All data encrypted in transit and at rest
- Private storage with no public access
- Automatic security updates
- Built-in DDoS protection
- Azure Security Center monitoring

### Additional Security Steps

1. **Enable Azure Defender** for additional threat protection
2. **Configure backup policies** for your storage account
3. **Set up alerts** for unusual activity
4. **Review access logs** regularly

## Scaling and Production Use

### Auto-scaling (Optional)

To handle more users:

1. Go to **App Service Plan** → **Scale out**
2. Enable **Autoscale**
3. Set rules based on CPU/memory usage

### Database Upgrade (Optional)

For high-volume production use:

1. Provision Azure Database for PostgreSQL
2. Update connection strings in App Service configuration
3. Run database migrations

## Support

Your Healthcare AI Chatbot is now running with:

- ✅ Production-ready infrastructure
- ✅ HIPAA compliance configuration
- ✅ Automatic monitoring and logging
- ✅ Enterprise security controls
- ✅ Scalable architecture

For technical support:
- Review Application Insights for errors
- Check Azure Service Health for outages
- Contact Azure Support for infrastructure issues

---

**Congratulations!** Your Healthcare AI Chatbot is now securely running in your Azure account with enterprise-grade infrastructure.