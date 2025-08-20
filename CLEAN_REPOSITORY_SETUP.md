# Clean Repository Setup Guide

## Step 1: Create New Repository

1. Go to GitHub.com
2. Click "New" repository
3. Repository name: `healthcare-ai-chatbot`
4. Description: `Healthcare AI chatbot with one-click Azure deployment`
5. Make it **Public** (required for ARM template access)
6. Check "Add a README file"
7. Choose license: None (you have custom educational license)
8. Click "Create repository"

## Step 2: Upload Files in Correct Order

### Upload Method: Drag and Drop (Recommended)

1. **Extract your zip file completely on your computer**
2. **Go to your new GitHub repository**
3. **Click "uploading an existing file"**
4. **Upload in this specific order:**

#### First Upload - Essential Files:
Drag these files first:
- `README.md` (will replace the default one)
- `LICENSE.txt`
- `package.json`
- `package-lock.json`
- `tsconfig.json`
- `vite.config.ts`
- `tailwind.config.ts`
- `postcss.config.js`
- `components.json`
- `Dockerfile`
- `docker-compose.yml`

#### Second Upload - Folders:
Create folders by dragging entire folders:
- `client/` folder (entire folder with all contents)
- `server/` folder (entire folder with all contents)
- `shared/` folder
- `deployment/` folder (CRITICAL - contains ARM template)
- `docs/` folder
- `scripts/` folder

#### Commit Message:
`Healthcare AI Chatbot with one-click Azure deployment`

## Step 3: Verify Upload Success

Your repository should show:
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
└── other config files
```

## Step 4: Update Deploy Button

1. Click on `README.md` in your repository
2. Click pencil icon (edit)
3. Find this line:
```markdown
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fyour-username%2Fhealthcare-ai-chatbot%2Fmain%2Fdeployment%2Fazuredeploy.json)
```
4. Replace `your-username` with your actual GitHub username
5. Click "Commit changes"

## Step 5: Test Deploy Button

1. Go back to repository main page
2. Scroll down to README
3. Click "Deploy to Azure" button
4. Should open Azure Portal with deployment form

## Success Indicators

- Repository shows professional folder structure
- README displays properly with deploy button
- No zip files or duplicate content
- ARM template accessible via URL

Ready to start? Begin with creating the new repository on GitHub.