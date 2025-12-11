# Docker方法三修复说明

## 问题

使用DOCKER_DEPLOY.md中的方法三（直接使用Docker）无法访问443端口。

## 原因

原来的方法三命令缺少以下关键配置：

1. 没有映射443端口 (`-p 443:443`)
2. 没有挂载SSL证书目录 (`-v ./ssl:/etc/ssl/certs:ro`)
3. 没有加载环境变量文件 (`--env-file .env`)

## 解决方案

### 快速修复（推荐）

使用提供的自动化脚本：

```bash
# Linux/Mac
./run-docker.sh

# Windows  
run-docker.bat
```

### 手动修复

使用正确的Docker运行命令：

```bash
# 完整命令
docker run -d \
  -p 80:80 \
  -p 443:443 \
  -v $(pwd)/ssl:/etc/ssl/certs:ro \
  --env-file .env \
  --name localsent-web \
  localsent-web-app
```

## 必要条件

1. SSL证书文件存在：`ssl/cert.pem` 和 `ssl/key.pem`
2. 环境变量文件存在：`.env`
3. Docker镜像已构建：`docker build -t localsent-web-app .`

## 验证

运行后应该能够访问：

- HTTP: <http://localhost> (自动重定向到HTTPS)
- HTTPS: <https://localhost>

## 故障排除

如果仍然无法访问443端口：

1. 检查容器状态：`docker ps`
2. 查看容器日志：`docker logs localsent-web`
3. 确认端口映射：`docker port localsent-web`
4. 检查防火墙设置
