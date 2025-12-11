#!/bin/bash

# 部署脚本
echo "开始部署 Nuxt 应用..."

# 停止并删除现有容器
echo "停止现有容器..."
docker-compose down

# 构建新镜像
echo "构建新镜像..."
docker-compose build --no-cache

# 启动服务
echo "启动服务..."
docker-compose up -d

# 显示运行状态
echo "检查服务状态..."
docker-compose ps

echo "部署完成！"
echo "应用已在以下地址运行："
echo "HTTP: http://localhost"
echo "查看日志: docker-compose logs -f"