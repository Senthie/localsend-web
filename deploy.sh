#!/bin/bash

# 部署脚本
echo "开始部署 Nuxt 应用..."

# 检查环境变量文件
if [ ! -f .env ]; then
    echo "警告: .env 文件不存在！"
    echo "请复制 .env.example 到 .env 并配置你的域名和邮箱："
    echo "cp .env.example .env"
    echo "然后编辑 .env 文件设置 DOMAIN 和 CADDY_EMAIL"
    exit 1
fi

# 检查SSL证书文件
if [ ! -f ssl/cert.pem ] || [ ! -f ssl/key.pem ]; then
    echo "警告: SSL证书文件不存在！"
    echo "请将SSL证书文件放在 ssl/ 目录下："
    echo "- ssl/cert.pem (证书文件)"
    echo "- ssl/key.pem (私钥文件)"
    echo ""
    echo "参考 ssl/README.md 了解详细说明"
    exit 1
fi

echo "检查SSL证书文件..."
if openssl x509 -in ssl/cert.pem -text -noout > /dev/null 2>&1; then
    echo "✓ SSL证书文件格式正确"
    # 显示证书信息
    echo "证书信息："
    openssl x509 -in ssl/cert.pem -subject -dates -noout
else
    echo "✗ SSL证书文件格式错误，请检查 ssl/cert.pem"
    exit 1
fi

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
echo "HTTP: http://localhost (将自动重定向到HTTPS)"
echo "HTTPS: https://localhost 或 https://你的域名"
echo ""
echo "注意事项："
echo "1. 使用自定义SSL证书，请确保证书有效"
echo "2. 确保域名已正确解析到服务器IP"
echo "3. 确保防火墙开放了80和443端口"
echo "4. 定期检查证书有效期并及时更新"
echo ""
echo "查看日志: docker-compose logs -f localsent-web"