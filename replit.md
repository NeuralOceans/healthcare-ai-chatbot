# Healthcare AI Assistant

## Overview

This is a healthcare patient data management system that combines AI-powered form generation with secure cloud storage. The application uses OpenAI's GPT-4o model to generate realistic patient information for testing purposes and integrates with Azure Blob Storage for secure data persistence. It features a modern React frontend with a chat interface and form management capabilities, backed by a Node.js/Express server.

## User Preferences

Preferred communication style: Simple, everyday language.

## Recent Changes

**August 20, 2025**: Completed comprehensive one-click Azure deployment system with educational licensing. Added:
- One-click Azure deployment with ARM templates and deploy button
- Complete testing tools and validation scripts for deployment verification
- GitHub repository structure with professional documentation
- Educational Use License (Copyright Scarlett Menendez, Neural Oceans)
- Enterprise security with HIPAA compliance and TMAS integration
- Distribution package for easy sharing (~$20/month Azure deployment costs)

## System Architecture

### Frontend Architecture
The client uses **React 18** with **TypeScript** and **Vite** as the build tool. The UI is built with **shadcn/ui** components (Radix UI primitives) and styled with **Tailwind CSS**. The application follows a component-based architecture with:

- **Routing**: Wouter for client-side routing
- **State Management**: TanStack Query for server state management
- **Forms**: React Hook Form with Zod validation
- **Styling**: Tailwind CSS with custom healthcare-themed color palette

The main interface consists of two panels: a chat interface for AI interaction and a patient form for data entry and generation.

### Backend Architecture
The server uses **Express.js** with TypeScript running on Node.js. It follows a modular architecture with:

- **Storage Layer**: In-memory storage implementation with interface abstraction for easy database migration
- **Service Layer**: Separate services for OpenAI integration and Azure Blob Storage operations
- **API Routes**: RESTful endpoints for patient data management and chat functionality
- **Middleware**: Request logging, error handling, and JSON parsing

### Database Architecture
Currently uses **in-memory storage** with a clean interface design that allows for easy migration to persistent storage. The schema is defined using **Drizzle ORM** with PostgreSQL dialect, ready for production database implementation. Key entities include:

- **Patients**: Store patient information with Azure blob URLs
- **Chat Messages**: Conversation history with the AI assistant

### Authentication & Authorization
The application is currently designed for development/testing purposes without authentication. The architecture supports adding authentication middleware in the future.

### AI Integration
**OpenAI GPT-4o** integration for:
- Generating realistic patient data for form testing
- Providing chat-based assistance through the healthcare AI assistant
- JSON-structured responses for form population

### File Upload & Storage
**Azure Blob Storage** integration for:
- Secure patient data storage in JSON format
- Automatic blob naming with timestamps
- Connection status monitoring
- Error handling for upload failures

### Development Tools
- **TypeScript** for type safety across frontend and backend
- **Drizzle Kit** for database schema management
- **ESBuild** for production builds
- **Vite** for development server with HMR

### Security & Compliance
- **Trend Micro Artifact Scanner (TMAS)** for comprehensive security scanning
- **Healthcare-specific override configurations** for HIPAA compliance
- **Multi-stage CI/CD pipelines** with security gates
- **Container security scanning** for vulnerabilities, malware, and secrets
- **SARIF integration** for GitHub Security tab reporting

## External Dependencies

### Cloud Services
- **Azure Blob Storage**: Patient data persistence and file storage
- **Neon Database**: PostgreSQL hosting (configured but not actively used with in-memory storage)

### AI Services  
- **OpenAI API**: GPT-4o model for data generation and chat responses

### UI Libraries
- **Radix UI**: Accessible component primitives
- **shadcn/ui**: Pre-built component system
- **Tailwind CSS**: Utility-first styling framework
- **Lucide React**: Icon library

### Backend Libraries
- **Express.js**: Web application framework
- **Drizzle ORM**: Type-safe database ORM
- **Zod**: Runtime type validation
- **TanStack Query**: Server state management

### Development Dependencies
- **Vite**: Build tool and development server
- **TypeScript**: Static type checking
- **ESLint**: Code linting
- **PostCSS**: CSS processing