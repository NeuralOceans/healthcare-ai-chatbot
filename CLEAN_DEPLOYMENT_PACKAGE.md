# Clean Deployment Package - Healthcare AI Chatbot

## Professional Repository Structure

Here's exactly what your clean repository should contain for successful deployment:

## Core Application Files
```
client/src/
├── components/ui/          # shadcn/ui components
├── pages/                  # Application pages
├── hooks/                  # React hooks
├── lib/                    # Utilities
├── App.tsx                 # Main app component
├── main.tsx               # Entry point
└── index.css              # Styles

server/
├── services/              # External services
├── index.ts               # Server entry
├── routes.ts              # API routes
├── storage.ts             # Storage interface
└── vite.ts                # Vite integration

shared/
└── schema.ts              # Type definitions
```

## Configuration Files
- `package.json` - Dependencies and scripts
- `tsconfig.json` - TypeScript configuration  
- `vite.config.ts` - Build configuration
- `tailwind.config.ts` - Styling configuration
- `Dockerfile` - Container setup
- `docker-compose.yml` - Local development

## Deployment Infrastructure
```
deployment/
├── azuredeploy.json           # ARM template (CRITICAL)
├── azuredeploy.parameters.json # Template parameters
├── README.md                   # Deployment guide
├── one-click-deploy.md        # User instructions
├── azure-setup.sh             # Automation script
└── button-generator.html      # Testing tool
```

## Documentation
- `README.md` - Main documentation with deploy button
- `LICENSE.txt` - Educational Use License
- `DISTRIBUTION.md` - Sharing guidelines
- `TESTING.md` - Deployment testing guide

## Critical for Deploy Button

The deploy button requires these specific files:
1. `README.md` - Contains the deploy button link
2. `deployment/azuredeploy.json` - ARM template for Azure resources

## Deploy Button URL Format
```markdown
[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FYOUR-USERNAME%2FHEALTHCARE-AI-CHATBOT%2Fmain%2Fdeployment%2Fazuredeploy.json)
```

## Verification Checklist

After clean setup, verify:
- [ ] Folders show properly (client/, server/, deployment/)
- [ ] README.md displays with formatted deploy button
- [ ] ARM template URL is accessible
- [ ] No zip files or duplicate content
- [ ] Professional appearance for sharing

This structure ensures your Healthcare AI Chatbot is ready for professional distribution and one-click Azure deployment.