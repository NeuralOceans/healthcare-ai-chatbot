# Live Deployment Test Instructions

## Step 1: Create GitHub Repository

1. Go to [GitHub.com](https://github.com)
2. Click "New" to create a new repository
3. Name it: `healthcare-ai-chatbot`
4. Make it **Public** (required for ARM template access)
5. Don't initialize with README (we have our own)
6. Click "Create repository"

## Step 2: Upload Code to GitHub

Copy your repository URL from GitHub, then run:

```bash
# Add remote repository (replace YOUR-USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR-USERNAME/healthcare-ai-chatbot.git

# Commit all files
git commit -m "Healthcare AI Chatbot with one-click Azure deployment"

# Push to GitHub
git push -u origin main
```

## Step 3: Update Deploy Button

1. Edit `README.md` in your GitHub repository
2. Replace `your-username` with your actual GitHub username
3. The deploy button URL will automatically work

## Step 4: Test Deploy Button

1. Go to your GitHub repository
2. Click the "Deploy to Azure" button in the README
3. Azure Portal should open with a deployment form

## Step 5: Complete Test Deployment

Fill in the deployment form:
- **Subscription**: Your Azure subscription
- **Resource Group**: Create new `healthcare-ai-test-rg`
- **Region**: East US (or closest to you)
- **App Name**: `healthcare-ai-test-[random]`
- **OpenAI API Key**: Your actual OpenAI API key
- **Vision One API Key**: Leave empty (optional)

Click "Review + Create" then "Create"

## Step 6: Verify Deployment (5-10 minutes)

After deployment:
1. Go to Azure Portal → Resource Groups → `healthcare-ai-test-rg`
2. Click on your App Service
3. Click "Browse" to open the application
4. Test the healthcare AI chatbot functionality

## Expected Results

- Healthcare AI dashboard loads
- Chat interface works with AI responses
- Patient form generation works
- Data saves to Azure storage
- Total cost: ~$20/month

## Cleanup After Testing

```bash
az group delete --name healthcare-ai-test-rg --yes --no-wait
```

---

Ready to start? Create your GitHub repository first!