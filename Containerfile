FROM node:24-bookworm AS builder

WORKDIR /data

COPY ./ /data

RUN corepack enable pnpm && \
    pnpm install && \
    pnpm run generate

FROM caddy:alpine
COPY --from=builder /data/.output/public /usr/share/caddy

# 创建SSL证书目录
RUN mkdir -p /etc/ssl/certs

COPY <<"EOT" /etc/caddy/Caddyfile
{
    # 全局配置
    email {$CADDY_EMAIL:admin@localhost}
    # 禁用自动HTTPS，使用自定义证书
    auto_https off
}

# HTTPS配置 - 所有访问（域名和IP）
:443 {
    root * /usr/share/caddy
    
    # 使用自定义SSL证书
    tls /etc/ssl/certs/cert.pem /etc/ssl/certs/key.pem
    
    # 启用压缩
    encode gzip
    
    # SPA路由支持 - 对于不存在的文件，回退到index.html
    try_files {path} /index.html
    file_server
    
    # 安全头（局域网友好配置）
    header {
        # 允许在iframe中显示
        X-Frame-Options "SAMEORIGIN"
        # 防止MIME类型嗅探
        X-Content-Type-Options "nosniff"
        # XSS保护
        X-XSS-Protection "1; mode=block"
        # 引用策略
        Referrer-Policy "strict-origin-when-cross-origin"
    }
}

# HTTP配置 - 重定向到HTTPS
:80 {
    redir https://{host}{uri} permanent
}
EOT
