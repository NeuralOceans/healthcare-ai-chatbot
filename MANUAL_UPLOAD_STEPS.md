# Manual Upload Steps - Healthcare AI Chatbot

## Problem: Only .zip file visible in repository

GitHub didn't automatically extract your zip file. Here's how to fix it:

## Step-by-Step Fix

### 1. Extract Files Locally
- Download the zip file from your GitHub repository
- Extract it on your computer
- You should see folders like `client/`, `server/`, `deployment/`, etc.

### 2. Clear Repository
- Go to your GitHub repository
- Click on the .zip file
- Click the trash/delete icon
- Commit the deletion

### 3. Upload Actual Files
- Click "Add file" → "Upload files" in GitHub
- Drag these folders and files from your extracted zip:
  - `client/` folder
  - `server/` folder  
  - `deployment/` folder
  - `shared/` folder
  - `docs/` folder
  - `scripts/` folder
  - `README.md`
  - `LICENSE.txt`
  - `package.json`
  - `Dockerfile`
  - `docker-compose.yml`
  - And all other configuration files (.json, .ts, .js, .md files)

### 4. Commit Upload
- Add commit message: "Healthcare AI Chatbot with one-click deployment"
- Click "Commit changes"

### 5. Update Deploy Button
- Click on `README.md` in your repository
- Click pencil icon to edit
- Replace `your-username` with your actual GitHub username in the deploy button URL
- Commit changes

### 6. Test Deploy Button
- Click the "Deploy to Azure" button in README
- Should open Azure Portal with deployment form

## Alternative: Use GitHub Web Interface

If the above is complex, you can:
1. Create individual files/folders using GitHub's web interface
2. Copy and paste content from each file in your local extraction
3. This takes longer but ensures everything is properly uploaded

## Verification

Your repository should look like:
```
healthcare-ai-chatbot/
├── client/
├── server/
├── deployment/
├── shared/
├── docs/
├── scripts/
├── README.md
├── LICENSE.txt
├── package.json
└── (other config files)
```

NOT just a single .zip file.

Once files are properly uploaded, the deploy button will work for live Azure deployment testing.