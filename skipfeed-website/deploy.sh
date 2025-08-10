#!/bin/bash

# SkipFeed Website Deployment Script
# This script builds and deploys the SkipFeed website using Docker and Nginx Proxy Manager

set -e

echo "🚀 Starting SkipFeed website deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker and try again.${NC}"
    exit 1
fi

# Check if Docker Compose is available (either docker-compose or docker compose)
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}❌ Docker Compose is not installed. Please install it and try again.${NC}"
    exit 1
fi

# Determine which Docker Compose command to use
if command -v docker-compose &> /dev/null; then
    COMPOSE_CMD="docker-compose"
else
    COMPOSE_CMD="docker compose"
fi

echo -e "${BLUE}🔧 Using Docker Compose command: ${COMPOSE_CMD}${NC}"

# Create external network if it doesn't exist
echo -e "${BLUE}📡 Creating external network 'web'...${NC}"
docker network create web 2>/dev/null || echo -e "${YELLOW}⚠️  Network 'web' already exists${NC}"

# Stop and remove existing containers
echo -e "${BLUE}🛑 Stopping existing containers...${NC}"
${COMPOSE_CMD} down 2>/dev/null || echo -e "${YELLOW}⚠️  No existing containers to stop${NC}"

# Build and start the containers
echo -e "${BLUE}🔨 Building and starting containers...${NC}"
${COMPOSE_CMD} up -d --build

# Wait for the application to be ready
echo -e "${BLUE}⏳ Waiting for application to be ready...${NC}"
sleep 30

# Check if the container is running
if ${COMPOSE_CMD} ps | grep -q "Up"; then
    echo -e "${GREEN}✅ SkipFeed website is now running!${NC}"
    echo -e "${GREEN}🌐 Application is available at: http://localhost:3001${NC}"
    echo -e "${BLUE}📝 Next steps:${NC}"
    echo -e "   1. Configure Nginx Proxy Manager to point skipfeed.app to this container"
    echo -e "   2. Set up SSL certificate for skipfeed.app"
    echo -e "   3. Test all language versions and pages"
    echo ""
    echo -e "${YELLOW}📋 Nginx Proxy Manager Configuration:${NC}"
    echo -e "   - Domain: skipfeed.app"
    echo -e "   - Forward Hostname: skipfeed-website"
    echo -e "   - Forward Port: 3001"
    echo -e "   - Enable SSL and Force SSL"
    echo ""
else
    echo -e "${RED}❌ Deployment failed. Check logs with: ${COMPOSE_CMD} logs${NC}"
    exit 1
fi

echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
