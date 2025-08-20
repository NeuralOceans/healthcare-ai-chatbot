# Healthcare AI Chatbot - Testing Guide

## How to Test the One-Click Azure Deployment

### Step 1: Setup GitHub Repository

1. **Create GitHub Repository**
   - Go to GitHub.com
   - Create new repository: `healthcare-ai-chatbot`
   - Make it public (required for ARM template access)

2. **Upload Code**
   ```bash
   git init
   git add .
   git commit -m "Healthcare AI Chatbot with one-click deployment"
   git branch -M main
   git remote add origin https://github.com/YOUR-USERNAME/healthcare-ai-chatbot.git
   git push -u origin main
   ```

3. **Update Deploy Button**
   - Replace `your-username` in README.md with your GitHub username
   - Commit and push changes

### Step 2: Test ARM Template Access

Verify your ARM template is accessible:
```bash
curl -I https://raw.githubusercontent.com/YOUR-USERNAME/healthcare-ai-chatbot/main/deployment/azuredeploy.json
```

Should return `HTTP/1.1 200 OK`

### Step 3: Test Deploy Button

1. Go to your GitHub repository
2. Click the "Deploy to Azure" button in README.md
3. Azure Portal should open with deployment form

### Step 4: Complete Test Deployment

**Prerequisites:**
- Azure subscription
- OpenAI API key from platform.openai.com

**Deployment Form:**
- **Subscription**: Choose your Azure subscription
- **Resource Group**: Create new `healthcare-ai-test-rg`
- **Region**: Choose closest region (e.g., East US)
- **App Name**: `healthcare-ai-test`
- **OpenAI API Key**: Your actual API key
- **Vision One API Key**: Leave empty (optional)
- **SKU**: B1 (default)

**Click "Review + Create" then "Create"**

### Step 5: Verify Deployment (5-10 minutes)

After deployment completes:

1. **Check Azure Resources**
   - Go to Resource Groups → `healthcare-ai-test-rg`
   - Verify these resources exist:
     - App Service: `healthcare-ai-test`
     - Storage Account: `storage[random]`
     - Application Insights: `healthcare-ai-test-insights`
     - App Service Plan: `healthcare-ai-test-plan`

2. **Test Application**
   - Click on App Service → Browse
   - Should open Healthcare AI Chatbot interface
   - Test chat: "Generate a patient form"
   - Verify form appears and can be filled
   - Click "Submit to Azure" button

3. **Verify Storage Integration**
   - Go to Storage Account → Containers
   - Click `patient-data` container
   - Submit a form in the app
   - Refresh - should see JSON file with patient data

4. **Check Monitoring**
   - Go to Application Insights → Live Metrics
   - Use the app - should see real-time data
   - Check Overview for performance metrics

### Step 6: Test Different Scenarios

**Test with Different Parameters:**
- Try different Azure regions
- Test with different app names
- Verify error handling with invalid API keys

**Security Verification:**
- Confirm HTTPS-only access
- Verify storage container is private
- Check that no sensitive data is logged

### Step 7: Cleanup Test Resources

After successful testing:
```bash
az group delete --name healthcare-ai-test-rg --yes --no-wait
```

## Expected Results

### Successful Deployment Creates:

**Azure Resources:**
- **App Service (B1)**: ~$13/month
- **Storage Account (GRS)**: ~$5/month  
- **Application Insights**: ~$2/month
- **Total Cost**: ~$20/month

**Security Features:**
- HTTPS-only access
- TLS 1.2 minimum
- Private blob storage
- Encrypted data at rest
- HIPAA compliance settings

**Application Features:**
- React-based healthcare dashboard
- AI-powered form generation
- Secure Azure storage integration
- Real-time monitoring
- Error handling and logging

### Common Issues and Solutions

**"Template not found" Error:**
- Ensure repository is public
- Check ARM template path is correct
- Verify GitHub username in URL

**"Invalid template" Error:**
- Validate JSON syntax: `python3 -m json.tool deployment/azuredeploy.json`
- Check required parameters are present

**"Deployment failed" Error:**
- Check Azure Activity Log for details
- Verify OpenAI API key is valid
- Ensure sufficient Azure quotas

**"Application Error" after deployment:**
- Check App Service logs
- Verify environment variables are set
- Confirm OpenAI API key has sufficient credits

### Success Criteria

✅ Deploy button opens Azure Portal with form
✅ All Azure resources created successfully  
✅ Application loads and shows healthcare dashboard
✅ AI chat generates patient forms
✅ Forms submit successfully to Azure storage
✅ Data appears in storage container
✅ Application Insights shows metrics
✅ No security warnings or errors

## Sharing with Others

Once tested successfully:

1. **Update Documentation**
   - Add actual screenshots to deployment guide
   - Document any issues encountered
   - Update cost estimates based on actual usage

2. **Create Release**
   - Tag repository with version number
   - Create GitHub release with deployment guide
   - Include troubleshooting tips

3. **Distribution**
   - Share repository URL
   - Provide clear setup instructions
   - Offer support for deployment issues

Your Healthcare AI Chatbot is now ready for distribution with enterprise-grade one-click Azure deployment!