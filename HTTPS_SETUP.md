# HTTPS 自定义证书配置指南

## 快速设置

1. **准备SSL证书**

   将你的SSL证书文件放在 `ssl/` 目录下：

   ```
   ssl/
   ├── cert.pem    # SSL证书文件
   └── key.pem     # 私钥文件
   ```

2. **复制环境变量文件**

   ```bash
   cp .env.example .env
   ```

3. **编辑配置**

   ```bash
   # 编辑 .env 文件
   nano .env
   ```

   设置以下变量：

   ```env
   DOMAIN=your-domain.com          # 替换为你的域名
   CADDY_EMAIL=your-email@example.com  # 替换为你的邮箱
   NODE_ENV=production
   ```

4. **部署应用**

   ```bash
   ./deploy.sh
   ```

## 证书格式要求

- **cert.pem**: SSL证书文件（PEM格式，包含完整证书链）
- **key.pem**: 私钥文件（PEM格式，无密码保护）

## 证书转换

如果你的证书是其他格式，可以转换：

```bash
# 从 .crt 和 .key 文件
cp your-cert.crt ssl/cert.pem
cp your-private.key ssl/key.pem

# 从 .p12 文件
openssl pkcs12 -in certificate.p12 -out ssl/cert.pem -clcerts -nokeys
openssl pkcs12 -in certificate.p12 -out ssl/key.pem -nocerts -nodes
```

## 工作原理

- **Caddy Web服务器**：使用你提供的SSL证书
- **自动重定向**：HTTP请求自动重定向到HTTPS
- **证书挂载**：证书文件通过Docker卷挂载到容器

## 重要提醒

1. **证书有效性**：确保SSL证书未过期且格式正确
2. **域名匹配**：证书域名必须与DOMAIN环境变量匹配
3. **防火墙**：开放80和443端口
4. **证书安全**：不要将私钥文件提交到版本控制
5. **定期更新**：定期检查证书有效期并及时更新

## 测试证书生成

如果只是本地测试，可以生成自签名证书：

```bash
# 生成测试证书
chmod +x generate-test-cert.sh
./generate-test-cert.sh
```

然后设置：

```env
DOMAIN=localhost
CADDY_EMAIL=test@example.com
```

注意：自签名证书会在浏览器显示安全警告，这是正常的。
