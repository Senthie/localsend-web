# Docker 部署指南

## 快速开始

### 方法一：使用 Docker Compose（推荐）

1. **准备SSL证书**

   将你的SSL证书文件放在 `ssl/` 目录下：

   ```sh
   ssl/
   ├── cert.pem    # SSL证书文件
   └── key.pem     # 私钥文件
   ```

   如果只是测试，可以生成自签名证书：

   ```bash
   # Linux/Macsh
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

3. **构建并启动服务**

   ```bash
   docker compose up -d --build
   ```

4. **访问应用**
   - 本地访问：<https://localhost> (HTTP自动重定向到HTTPS)
   - 局域网访问：<https://服务器IP地址> (例如: <https://14.12.0.102>)
   - 域名访问：<https://your-domain.com> (需要DNS解析)
   
   **注意**: LocalSend需要HTTPS环境才能使用Web Crypto API，所有HTTP访问会自动重定向到HTTPS

5. **查看日志**

   ```bash
   docker-compose logs -f
   ```

6. **停止服务**

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

#### 选项A：使用自动化脚本（推荐）

**运行自动化脚本**

```bash
# Linux/Mac
chmod +x run-docker.sh
./run-docker.sh

# Windows
run-docker.bat
```

脚本会自动检查SSL证书、构建镜像并运行容器。

#### 选项B：手动执行命令

1. **准备SSL证书和环境变量**

   确保已准备好SSL证书文件和.env文件（参考方法一的步骤1-2）

2. **构建镜像**

   ```bash
   docker build -t localsent-web-app .
   ```

3. **运行容器**

   ```bash
   # 基本运行（映射80和443端口，挂载SSL证书）
   docker run -d \
     -p 80:80 \
     -p 443:443 \
     -v $(pwd)/ssl:/etc/ssl/certs:ro \
     --env-file .env \
     --name localsent-web \
     localsent-web-app
   ```

   或者使用单行命令：

   ```bash
   docker run -d -p 80:80 -p 443:443 -v $(pwd)/ssl:/etc/ssl/certs:ro --env-file .env --name localsent-web localsent-web-app
   ```

   **Windows PowerShell用户请使用：**

   ```powershell
   docker run -d -p 80:80 -p 443:443 -v ${PWD}/ssl:/etc/ssl/certs:ro --env-file .env --name localsent-web localsent-web-app
   ```

   **Windows CMD用户请使用：**

   ```cmd
   docker run -d -p 80:80 -p 443:443 -v %cd%/ssl:/etc/ssl/certs:ro --env-file .env --name localsent-web localsent-web-app
   ```

## 局域网访问配置

### 获取服务器IP地址

要让局域网内的其他设备访问，首先需要获取服务器的IP地址：

```bash
# 获取服务器IP地址
hostname -I
# 或者
ip addr show | grep inet
```

### 局域网访问地址

- **HTTPS访问**: `https://服务器IP地址`
- **示例**: `https://14.12.0.102`
- **HTTP重定向**: 访问 `http://14.12.0.102` 会自动重定向到HTTPS

**重要**: 
- LocalSend Web需要HTTPS环境才能正常工作，因为它依赖Web Crypto API进行加密通信
- 应用支持单页应用(SPA)路由，可以直接访问 `/zh`、`/en` 等语言路径，刷新页面也不会出现404错误

### 客户端设备要求

1. **网络连接**: 确保客户端设备与服务器在同一局域网内
2. **防火墙**: 确保服务器防火墙允许80和443端口访问
3. **浏览器**: 使用现代浏览器访问应用

### 测试局域网访问

在其他设备上打开浏览器，访问：
- `https://你的服务器IP地址` (例如: `https://14.12.0.102`)

**浏览器安全警告处理**:
由于使用自签名证书，浏览器会显示安全警告。请按以下步骤继续：
1. 点击"高级"或"Advanced"
2. 点击"继续访问"或"Proceed to site"
3. 应用将正常加载并支持Web Crypto API
4. 可以直接访问语言路径，如 `https://14.12.0.102/zh` 或 `https://14.12.0.102/en`

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

### Docker Compose 命令

- 重新构建：`docker-compose build --no-cache`
- 查看状态：`docker-compose ps`
- 进入容器：`docker-compose exec localsent-web sh`
- 查看日志：`docker-compose logs -f localsent-web`

### 直接 Docker 命令

- 查看容器状态：`docker ps`
- 查看日志：`docker logs localsent-web`
- 进入容器：`docker exec -it localsent-web sh`
- 停止容器：`docker stop localsent-web`
- 删除容器：`docker rm localsent-web`
- 重新运行：`docker stop localsent-web && docker rm localsent-web` 然后重新运行docker run命令

### 通用命令

- 清理资源：`docker system prune -a`
- 查看镜像：`docker images`
- 删除镜像：`docker rmi localsent-web-app`

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
   - 查看 Caddy 日志：`docker-compose logs localsent-web`

5. **环境变量未生效**
   - 确保 `.env` 文件存在且格式正确
   - 重新构建容器：`docker-compose up -d --build`

6. **方法三（直接Docker）特定问题**
   - **443端口无法访问**：确保运行命令包含 `-p 443:443`
   - **SSL证书未找到**：确保包含 `-v $(pwd)/ssl:/etc/ssl/certs:ro`
   - **环境变量未加载**：确保包含 `--env-file .env`
   - **容器重启**：先停止并删除容器 `docker stop localsent-web && docker rm localsent-web`

7. **SPA路由问题**
   - **刷新页面404错误**：已通过 `try_files` 配置解决，所有路由都会回退到 `index.html`
   - **语言路径访问**：支持直接访问 `/zh`、`/en` 等路径，无需担心刷新问题
   - **静态资源**：CSS、JS、图片等静态文件正常访问不受影响

## 安全注意事项

1. **保护 .env 文件**：不要将包含敏感信息的 `.env` 文件提交到版本控制
2. **定期更新**：定期更新 Docker 镜像和依赖
3. **监控日志**：定期检查应用和 Caddy 日志
4. **证书安全**：不要将私钥文件提交到版本控制系统
5. **证书更新**：定期检查证书有效期并及时更新
