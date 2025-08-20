# Upload Priority List - Healthcare AI Chatbot

## Critical Files (Upload First)

These files are essential for the deploy button to work:

### 1. ARM Template (Highest Priority)
- `deployment/azuredeploy.json` - The Azure deployment template
- `deployment/azuredeploy.parameters.json` - Template parameters

### 2. Documentation (High Priority)  
- `README.md` - Contains deploy button and main documentation
- `LICENSE.txt` - Educational Use License

### 3. Configuration (High Priority)
- `package.json` - Project dependencies and scripts
- `tsconfig.json` - TypeScript configuration
- `vite.config.ts` - Build configuration

## Application Files (Upload Second)

### Core Application
- `client/` folder - Complete React frontend
- `server/` folder - Complete Node.js backend
- `shared/` folder - Shared types and schemas

### Container Setup
- `Dockerfile` - Container configuration
- `docker-compose.yml` - Local development setup

## Documentation (Upload Third)

- `deployment/` folder - All deployment guides and scripts
- `docs/` folder - Additional documentation
- `scripts/` folder - Automation scripts

## Upload Strategy

1. **Start small** - Upload critical files first to verify repository works
2. **Test early** - Update deploy button and test after uploading ARM template
3. **Add incrementally** - Upload remaining folders once core functionality verified

## Verification After Each Upload

- Repository structure looks clean
- Files display properly in GitHub
- No upload errors or conflicts
- Deploy button formatting appears correct

This approach ensures your repository works correctly from the beginning and allows testing at each stage.