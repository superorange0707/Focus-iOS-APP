#!/bin/bash

# SkipFeed Website - 本地构建远程部署脚本
# 在本地构建 Docker 镜像，然后部署到远程服务器

set -e

# 配置变量 - 请修改为你的服务器信息
SERVER_IP="107.172.217.59"
SERVER_USER="root"
IMAGE_NAME="skipfeed-website"
VERSION="production"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 开始本地构建和远程部署...${NC}"

# 检查服务器连接
echo -e "${BLUE}🔍 检查服务器连接...${NC}"
if ! ssh -o ConnectTimeout=5 ${SERVER_USER}@${SERVER_IP} "echo 'Connected'" > /dev/null 2>&1; then
    echo -e "${RED}❌ 无法连接到服务器 ${SERVER_IP}${NC}"
    echo -e "${YELLOW}请确保：${NC}"
    echo -e "  1. 服务器 IP 地址正确"
    echo -e "  2. SSH 密钥已配置"
    echo -e "  3. 服务器可访问"
    exit 1
fi

# 本地构建
echo -e "${BLUE}🔨 在本地构建 Docker 镜像...${NC}"
docker build -t ${IMAGE_NAME}:${VERSION} .

# 导出镜像
echo -e "${BLUE}📦 导出镜像为 tar 文件...${NC}"
docker save ${IMAGE_NAME}:${VERSION} > ${IMAGE_NAME}.tar

# 上传到服务器
echo -e "${BLUE}📤 上传镜像到服务器...${NC}"
scp ${IMAGE_NAME}.tar ${SERVER_USER}@${SERVER_IP}:/tmp/

# 在服务器上部署
echo -e "${BLUE}🚀 在服务器上部署...${NC}"
ssh ${SERVER_USER}@${SERVER_IP} << EOF
    cd /root/skipfeed
    
    # 停止现有容器
    docker compose down 2>/dev/null || true
    
    # 导入新镜像
    docker load < /tmp/${IMAGE_NAME}.tar
    
    # 创建 docker-compose 文件
    cat > docker-compose.prod.yml << 'COMPOSE_EOF'
version: '3.8'

services:
  skipfeed-website:
    image: ${IMAGE_NAME}:${VERSION}
    container_name: skipfeed-website
    ports:
      - "3001:3001"
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
COMPOSE_EOF
    
    # 启动服务
    docker compose -f docker-compose.prod.yml up -d
    
    # 清理临时文件
    rm -f /tmp/${IMAGE_NAME}.tar
    
    echo "✅ 部署完成！"
EOF

# 清理本地临时文件
rm -f ${IMAGE_NAME}.tar

# 检查部署状态
echo -e "${BLUE}🔍 检查部署状态...${NC}"
sleep 5
if ssh ${SERVER_USER}@${SERVER_IP} "docker ps | grep skipfeed-website | grep -q Up"; then
    echo -e "${GREEN}✅ SkipFeed 网站部署成功！${NC}"
    echo -e "${GREEN}🌐 访问地址: https://skipfeed.app${NC}"
    echo -e "${GREEN}🌐 本地测试: http://${SERVER_IP}:3001${NC}"
else
    echo -e "${RED}❌ 部署可能失败，请检查日志${NC}"
    ssh ${SERVER_USER}@${SERVER_IP} "docker logs skipfeed-website"
fi

echo -e "${GREEN}🎉 本地构建远程部署完成！${NC}"
