#!/bin/bash

# Docker Compose Deployment Script
# Easy deployment using Docker Compose for development and testing

set -e

echo "🐳 Starting Docker Compose deployment..."

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found. Creating from example..."
    cp .env.example .env
    echo "✅ Created .env file. Please edit it with your actual credentials:"
    echo "nano .env"
    echo ""
    echo "Required variables:"
    echo "- OPENAI_API_KEY: Your OpenAI API key"
    echo "- AZURE_STORAGE_ACCOUNT_NAME: Azure storage account name"
    echo "- AZURE_STORAGE_ACCOUNT_KEY: Azure storage account key"
    echo "- VISION_ONE_API_KEY: Trend Vision One API key (optional)"
    exit 1
fi

# Load environment variables to validate
source .env

if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ OPENAI_API_KEY is required in .env file"
    echo "Please add your OpenAI API key to the .env file"
    exit 1
fi

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down 2>/dev/null || docker compose down 2>/dev/null || true

# Build and start containers
echo "🔨 Building and starting containers..."
if command -v docker-compose &> /dev/null; then
    docker-compose up --build -d
else
    docker compose up --build -d
fi

# Wait for application to start
echo "⏳ Waiting for application to start..."
sleep 15

# Test the deployment
PORT=5000
if curl -f -s "http://localhost:$PORT/api/azure/status" > /dev/null; then
    echo "✅ Docker Compose deployment successful!"
else
    echo "⚠️  Containers started but application may not be fully ready"
    echo "Check logs with: docker-compose logs healthcare-ai"
fi

echo ""
echo "🎉 Healthcare AI Chatbot is running!"
echo "URL: http://localhost:$PORT"
echo ""
echo "Management commands:"
echo "View logs: docker-compose logs healthcare-ai"
echo "Stop: docker-compose down"
echo "Restart: docker-compose restart"
echo "Update: docker-compose up --build -d"
echo ""
echo "🔒 Security: Integrated with Vision One monitoring"
echo "📊 Health check: Available at http://localhost:$PORT/api/azure/status"