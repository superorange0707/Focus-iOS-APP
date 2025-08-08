#!/bin/bash

# 简化版本的部署脚本 - 手动输入密码

set -e

SERVER_IP="107.172.217.59"
SERVER_USER="root"
IMAGE_NAME="skipfeed-website"
VERSION="latest"

echo "🚀 开始本地构建..."

# 检查 Docker 是否运行
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Docker 未运行，请先启动 Docker Desktop"
    exit 1
fi

# 本地构建
echo "🔨 构建 Docker 镜像..."
docker build -t ${IMAGE_NAME}:${VERSION} .

# 导出镜像
echo "📦 导出镜像..."
docker save ${IMAGE_NAME}:${VERSION} > ${IMAGE_NAME}.tar

# 上传到服务器
echo "📤 上传镜像到服务器（需要输入密码）..."
scp ${IMAGE_NAME}.tar ${SERVER_USER}@${SERVER_IP}:/tmp/

# 在服务器上部署
echo "🚀 在服务器上部署（需要输入密码）..."
ssh ${SERVER_USER}@${SERVER_IP} "
    cd /root/skipfeed
    docker compose down 2>/dev/null || true
    docker load < /tmp/${IMAGE_NAME}.tar
    
    cat > docker-compose.prod.yml << 'EOF'
version: '3.8'

services:
  skipfeed-website:
    image: ${IMAGE_NAME}:${VERSION}
    container_name: skipfeed-website
    ports:
      - \"3001:3001\"
    environment:
      - NODE_ENV=production
      - HOSTNAME=0.0.0.0
      - PORT=3001
    restart: unless-stopped
    networks:
      - web

networks:
  web:
    external: true
EOF
    
    docker compose -f docker-compose.prod.yml up -d
    rm -f /tmp/${IMAGE_NAME}.tar
    echo '✅ 部署完成！'
"

# 清理本地文件
rm -f ${IMAGE_NAME}.tar

echo "🎉 部署完成！访问 https://skipfeed.app"
