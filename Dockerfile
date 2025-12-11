# 为了兼容性，创建一个标准的Dockerfile（与Containerfile相同）
FROM node:24-bookworm AS builder

WORKDIR /data

COPY ./ /data

RUN corepack enable pnpm && \
    pnpm install && \
    pnpm run generate

FROM caddy:alpine
COPY --from=builder /data/.output/public /usr/share/caddy
COPY <<"EOT" /etc/caddy/Caddyfile
:80 {
    file_server
    root * /usr/share/caddy
}
EOT