#!/bin/bash

# SkipFeed Website - 跨平台部署脚本
# 本地构建 AMD64 镜像并部署到远程服务器

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

echo -e "${BLUE}🚀 开始跨平台部署 (AMD64)...${NC}"

# 检查本地 Docker 是否运行
echo -e "${BLUE}🔍 检查本地 Docker 守护进程...${NC}"
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ 本地 Docker 守护进程未运行。${NC}"
    exit 1
fi
echo -e "${GREEN}✅ 本地 Docker 守护进程正在运行。${NC}"

# 先停止服务器上的容器
echo -e "${BLUE}🛑 停止服务器上的现有容器...${NC}"
ssh ${SERVER_USER}@${SERVER_IP} "docker stop skipfeed-website 2>/dev/null || echo '没有运行的容器'; docker rm skipfeed-website 2>/dev/null || echo '没有需要删除的容器'"

# 本地构建 AMD64 镜像
echo -e "${BLUE}🔨 在本地构建 AMD64 Docker 镜像...${NC}"
docker buildx build --platform linux/amd64 -t ${IMAGE_NAME}:${VERSION} .

# 导出镜像
echo -e "${BLUE}📦 导出镜像为 tar 文件...${NC}"
docker save ${IMAGE_NAME}:${VERSION} > ${IMAGE_NAME}.tar

# 上传到服务器
echo -e "${BLUE}📤 上传镜像到服务器...${NC}"
scp ${IMAGE_NAME}.tar ${SERVER_USER}@${SERVER_IP}:/tmp/

# 在服务器上部署
echo -e "${BLUE}🚀 在服务器上部署...${NC}"
ssh ${SERVER_USER}@${SERVER_IP} << 'EOF'
    echo "🛠️ 确保项目目录存在..."
    mkdir -p /root/skipfeed
    cd /root/skipfeed
    
    echo "🌐 确保 Docker 网络存在..."
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

# 等待容器启动并检查状态
echo -e "${BLUE}⏳ 等待容器启动...${NC}"
sleep 10

echo -e "${BLUE}🔍 检查部署状态...${NC}"
if ssh ${SERVER_USER}@${SERVER_IP} "docker ps | grep skipfeed-website | grep -q Up"; then
    echo -e "${GREEN}✅ SkipFeed 网站部署成功！${NC}"
    echo ""
    echo -e "${BLUE}🧪 测试容器响应...${NC}"
    ssh ${SERVER_USER}@${SERVER_IP} "curl -s -o /dev/null -w 'HTTP状态: %{http_code}\n' http://localhost:3001" || echo "容器可能还在启动中..."
    echo ""
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
    echo -e "${GREEN}容器日志（最后几行）：${NC}"
    ssh ${SERVER_USER}@${SERVER_IP} "docker logs --tail 5 skipfeed-website"
else
    echo -e "${RED}❌ 部署失败，检查日志：${NC}"
    ssh ${SERVER_USER}@${SERVER_IP} "docker logs --tail 10 skipfeed-website 2>/dev/null || echo '容器未找到'"
    ssh ${SERVER_USER}@${SERVER_IP} "docker ps -a | grep skipfeed"
fi

echo -e "${GREEN}🎉 跨平台部署完成！${NC}"
