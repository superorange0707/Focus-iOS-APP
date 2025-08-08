#!/bin/bash

# SkipFeed Website - 修复版本部署脚本
# 本地构建并部署到远程服务器

set -e

# 配置变量
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

echo -e "${BLUE}🚀 开始修复版本部署...${NC}"

# 检查本地 Docker 是否运行
echo -e "${BLUE}🔍 检查本地 Docker 守护进程...${NC}"
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ 本地 Docker 守护进程未运行。${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 本地 Docker 守护进程正在运行。${NC}"

# 本地构建镜像
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
ssh ${SERVER_USER}@${SERVER_IP} << 'EOF'
    echo "🛠️ 创建项目目录..."
    mkdir -p /root/skipfeed
    cd /root/skipfeed
    
    echo "🛑 停止现有容器..."
    docker stop skipfeed-website 2>/dev/null || echo "没有运行的容器"
    docker rm skipfeed-website 2>/dev/null || echo "没有需要删除的容器"
    
    echo "🌐 创建 Docker 网络..."
    docker network create web 2>/dev/null || echo "网络 'web' 已存在"
    
    echo "📥 加载新镜像..."
    docker load < /tmp/skipfeed-website.tar
    
    echo "🚀 启动新容器..."
    docker run -d \
        --name skipfeed-website \
        --network web \
        -p 3001:3001 \
        --restart unless-stopped \
        -e NODE_ENV=production \
        -e PORT=3001 \
        -e HOSTNAME=0.0.0.0 \
        skipfeed-website:production
    
    echo "🧹 清理临时文件..."
    rm -f /tmp/skipfeed-website.tar
    
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
    echo ""
    echo -e "${YELLOW}📋 接下来的步骤：${NC}"
    echo -e "1. 在 Nginx Proxy Manager 中配置："
    echo -e "   - 域名: skipfeed.app"
    echo -e "   - 转发主机: skipfeed-website 或 ${SERVER_IP}"
    echo -e "   - 转发端口: 3001"
    echo -e "   - 启用 SSL 和强制 HTTPS"
    echo ""
else
    echo -e "${RED}❌ 部署可能失败，请检查日志${NC}"
    ssh ${SERVER_USER}@${SERVER_IP} "docker logs skipfeed-website 2>/dev/null || echo '容器未找到'"
fi

echo -e "${GREEN}🎉 修复版本部署完成！${NC}"
