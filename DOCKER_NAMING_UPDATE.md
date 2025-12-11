# Docker 镜像和容器名称更新

## 变更说明

为了更好地标识项目，已将Docker相关的名称进行了统一更新：

### 名称变更

- **镜像名称**: `nuxt-app` → `localsent-web-app`
- **容器名称**: `nuxt-app` → `localsent-web`
- **网络名称**: `nuxt-network` → `localsent-network`

### 更新的文件

1. `docker-compose.yml` - Docker Compose配置
2. `deploy.sh` - 部署脚本
3. `run-docker.sh` - Linux/Mac直接Docker运行脚本
4. `run-docker.bat` - Windows直接Docker运行脚本
5. `DOCKER_DEPLOY.md` - 部署文档
6. `DOCKER_METHOD3_FIX.md` - 方法三修复说明

### 新的命令示例

#### Docker Compose

```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f localsent-web

# 进入容器
docker-compose exec localsent-web sh
```

#### 直接Docker

```bash
# 构建镜像
docker build -t localsent-web-app .

# 运行容器
docker run -d -p 80:80 -p 443:443 \
  -v $(pwd)/ssl:/etc/ssl/certs:ro \
  --env-file .env \
  --name localsent-web \
  localsent-web-app

# 查看日志
docker logs localsent-web

# 停止容器
docker stop localsent-web
```

### 清理旧容器和镜像

如果之前使用过旧名称，建议清理：

```bash
# 停止并删除旧容器
docker stop nuxt-app 2>/dev/null
docker rm nuxt-app 2>/dev/null

# 删除旧镜像
docker rmi nuxt-app 2>/dev/null

# 清理未使用的资源
docker system prune -f
```

### 注意事项

1. 所有脚本和文档已更新为新名称
2. 如果有自定义脚本引用了旧名称，请相应更新
3. 新名称更好地反映了项目的实际用途（LocalSend Web应用）
