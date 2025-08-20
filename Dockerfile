# Healthcare AI Chatbot - Production Dockerfile
# Multi-stage build for security and optimization

# Stage 1: Build the frontend
FROM node:20-alpine AS frontend-builder

WORKDIR /app

# Copy package files
COPY package*.json ./
COPY tsconfig.json ./
COPY vite.config.ts ./
COPY tailwind.config.ts ./
COPY postcss.config.js ./
COPY components.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy source code
COPY client/ ./client/
COPY shared/ ./shared/

# Build the frontend
RUN npm run build

# Stage 2: Setup the production server
FROM node:20-alpine AS production

# Add security enhancements
RUN addgroup -g 1001 -S nodejs && \
    adduser -S healthcare -u 1001

# Set working directory
WORKDIR /app

# Install security updates and necessary tools
RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    ca-certificates \
    tzdata && \
    rm -rf /var/cache/apk/*

# Copy package files and install production dependencies
COPY package*.json ./
RUN npm ci --only=production && \
    npm cache clean --force && \
    rm -rf /tmp/*

# Copy built frontend from previous stage
COPY --from=frontend-builder /app/dist ./dist

# Copy server source code
COPY server/ ./server/
COPY shared/ ./shared/
COPY tsconfig.json ./

# Copy configuration files
COPY drizzle.config.ts ./

# Create necessary directories and set permissions
RUN mkdir -p /app/uploads /app/logs && \
    chown -R healthcare:nodejs /app

# Switch to non-root user for security
USER healthcare

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD node -e "require('http').get('http://localhost:5000/api/azure/status', (res) => { process.exit(res.statusCode === 200 ? 0 : 1); }).on('error', () => { process.exit(1); });"

# Expose port
EXPOSE 5000

# Environment variables
ENV NODE_ENV=production
ENV PORT=5000

# Start the application
CMD ["npm", "start"]