# Docker 部署指南

## 快速开始

### 方法一：使用 Docker Compose（推荐）

1. **准备SSL证书**

   将你的SSL证书文件放在 `ssl/` 目录下：

   ```
   ssl/
   ├── cert.pem    # SSL证书文件
   └── key.pem     # 私钥文件
   ```

   如果只是测试，可以生成自签名证书：

   ```bash
   # Linux/Mac
   ./generate-test-cert.sh
   
   # Windows
   generate-test-cert.bat
   ```

2. **配置环境变量**

   ```bash
   # 复制环境变量模板
   cp .env.example .env
   
   # 编辑环境变量文件
   nano .env  # 或使用其他编辑器
   ```

   在 `.env` 文件中设置：

   ```env
   DOMAIN=your-domain.com
   CADDY_EMAIL=your-email@example.com
   NODE_ENV=production
   ```

2. **构建并启动服务**

   ```bash
   docker-compose up -d --build
   ```

3. **访问应用**
   - HTTP：<http://localhost> （自动重定向到HTTPS）
   - HTTPS：<https://localhost> 或 <https://your-domain.com>

4. **查看日志**

   ```bash
   docker-compose logs -f
   ```

5. **停止服务**

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

### HTTPS 自定义证书配置

本项目使用 Caddy 作为 Web 服务器，支持自定义 SSL 证书：

1. **自定义证书**：使用你提供的 SSL 证书文件
2. **HTTP 重定向**：自动将 HTTP 请求重定向到 HTTPS
3. **安全头**：自动添加安全相关的 HTTP 头
4. **证书挂载**：证书文件通过 Docker 卷挂载到容器

### 环境变量配置

| 变量名 | 说明 | 示例 |
|--------|------|------|
| `DOMAIN` | 你的域名 | `example.com` |
| `CADDY_EMAIL` | 管理员邮箱 | `admin@example.com` |
| `NODE_ENV` | 运行环境 | `production` |

### SSL证书要求

1. **证书格式**：PEM 格式的证书文件
2. **文件位置**：`ssl/cert.pem` 和 `ssl/key.pem`
3. **域名匹配**：证书域名必须与 DOMAIN 环境变量匹配
4. **证书有效性**：确保证书未过期

### 部署要求

1. **DNS 解析**：确保域名已正确解析到服务器 IP
2. **端口开放**：确保服务器防火墙开放 80 和 443 端口
3. **证书权限**：确保证书文件可读

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

4. **HTTPS 证书问题**
   - 确保 SSL 证书文件存在且格式正确
   - 检查证书域名是否与 DOMAIN 环境变量匹配
   - 确保证书未过期
   - 查看 Caddy 日志：`docker-compose logs nuxt-app`

5. **环境变量未生效**
   - 确保 `.env` 文件存在且格式正确
   - 重新构建容器：`docker-compose up -d --build`

## 安全注意事项

1. **保护 .env 文件**：不要将包含敏感信息的 `.env` 文件提交到版本控制
2. **定期更新**：定期更新 Docker 镜像和依赖
3. **监控日志**：定期检查应用和 Caddy 日志
4. **证书安全**：不要将私钥文件提交到版本控制系统
5. **证书更新**：定期检查证书有效期并及时更新
