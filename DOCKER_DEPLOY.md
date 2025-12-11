# Docker 部署指南

## 快速开始

### 方法一：使用 Docker Compose（推荐）

1. **构建并启动服务**

   ```bash
   docker-compose up -d --build
   ```

2. **访问应用**
   - 打开浏览器访问：<http://localhost>

3. **查看日志**

   ```bash
   docker-compose logs -f
   ```

4. **停止服务**

   ```bash
   docker-compose down
   ```

### 方法二：使用部署脚本

1. **给脚本执行权限**

   ```bash
   chmod +x deploy.sh
   ```

2. **运行部署脚本**

   ```bash
   ./deploy.sh
   ```

### 方法三：直接使用 Docker

1. **构建镜像**

   ```bash
   docker build -t nuxt-app .
   ```

2. **运行容器**

   ```bash
   docker run -d -p 80:80 --name nuxt-app nuxt-app
   ```

## 生产环境配置

### 自定义域名和HTTPS

如果你有自己的域名，可以修改 `Containerfile` 中的 Caddyfile：

```dockerfile
FROM caddy:alpine
COPY --from=builder /data/.output/public /usr/share/caddy
COPY <<"EOT" /etc/caddy/Caddyfile
your-domain.com {
    file_server
    root * /usr/share/caddy
}
EOT
```

### 端口配置

在 `docker-compose.yml` 中修改端口映射：

```yaml
ports:
  - "8080:80"  # 将应用映射到8080端口
```

## 常用命令

- 重新构建：`docker-compose build --no-cache`
- 查看状态：`docker-compose ps`
- 进入容器：`docker-compose exec nuxt-app sh`
- 清理资源：`docker system prune -a`

## 故障排除

1. **端口被占用**
   - 修改 docker-compose.yml 中的端口映射
   - 或停止占用端口的服务

2. **构建失败**
   - 检查网络连接
   - 清理Docker缓存：`docker system prune -a`

3. **应用无法访问**
   - 检查容器状态：`docker-compose ps`
   - 查看日志：`docker-compose logs`
