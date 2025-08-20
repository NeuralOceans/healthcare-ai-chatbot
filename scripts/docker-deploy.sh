#!/bin/bash

# Docker Deployment Script for Healthcare AI Chatbot
# Simple containerized deployment with security scanning

set -e

CONTAINER_NAME="healthcare-ai-chatbot"
IMAGE_NAME="healthcare-ai"
PORT="5000"

echo "🐳 Starting Docker deployment for Healthcare AI Chatbot..."

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found. Please create one from .env.example"
    echo "cp .env.example .env"
    echo "Then edit .env with your actual credentials."
    exit 1
fi

# Load environment variables
source .env

# Validate required environment variables
if [ -z "$OPENAI_API_KEY" ]; then
    echo "❌ OPENAI_API_KEY is required in .env file"
    exit 1
fi

# Stop and remove existing container if it exists
echo "🛑 Stopping existing container..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Build the Docker image
echo "🔨 Building Docker image..."
docker build -t $IMAGE_NAME:latest .

# Run security scan if TMAS is available
if command -v tmas &> /dev/null && [ ! -z "$VISION_ONE_API_KEY" ]; then
    echo "🔒 Running security scan..."
    tmas configure --api-key $VISION_ONE_API_KEY --region ${VISION_ONE_REGION:-us-1}
    tmas scan docker:$IMAGE_NAME:latest -VMS \
        --output-format json \
        --output-file tmas-scan-results.json \
        --override tmas_healthcare_overrides.yml || true
    
    if [ -f "tmas-scan-results.json" ]; then
        CRITICAL_COUNT=$(jq '.vulnerabilities | map(select(.severity == "critical")) | length' tmas-scan-results.json 2>/dev/null || echo "0")
        echo "Security scan: $CRITICAL_COUNT critical vulnerabilities found"
        
        if [ "$CRITICAL_COUNT" -gt "0" ]; then
            echo "⚠️  Critical vulnerabilities detected. Review scan results before production use."
        else
            echo "✅ Security scan passed!"
        fi
    fi
else
    echo "⚠️  Skipping security scan (TMAS not installed or Vision One key not configured)"
fi

# Run the container
echo "🚀 Starting healthcare AI chatbot container..."
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p $PORT:5000 \
    --env-file .env \
    -v "$(pwd)/logs:/app/logs" \
    $IMAGE_NAME:latest

# Wait for container to start
echo "⏳ Waiting for application to start..."
sleep 10

# Test the deployment
if curl -f -s "http://localhost:$PORT/api/azure/status" > /dev/null; then
    echo "✅ Container deployment successful!"
else
    echo "⚠️  Container started but application may not be fully ready"
fi

echo ""
echo "🎉 Healthcare AI Chatbot is running!"
echo "URL: http://localhost:$PORT"
echo "Container: $CONTAINER_NAME"
echo ""
echo "Useful commands:"
echo "View logs: docker logs $CONTAINER_NAME"
echo "Stop: docker stop $CONTAINER_NAME"
echo "Restart: docker restart $CONTAINER_NAME"
echo "Remove: docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME"
echo ""
echo "🔒 Security: Integrated with Vision One (if configured)"
echo "📊 Monitor: Check container logs for application metrics"