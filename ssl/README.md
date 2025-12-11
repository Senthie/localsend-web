# SSL证书目录

请将你的SSL证书文件放在此目录下：

## 文件结构

```
ssl/
├── cert.pem      # SSL证书文件
├── key.pem       # 私钥文件
└── README.md     # 此说明文件
```

## 证书文件要求

1. **cert.pem**: SSL证书文件（包含完整证书链）
2. **key.pem**: 私钥文件

## 证书格式

确保证书文件是PEM格式。如果你的证书是其他格式，可以使用以下命令转换：

```bash
# 从 .crt 和 .key 转换
cp your-cert.crt ssl/cert.pem
cp your-private.key ssl/key.pem

# 从 .p12 转换
openssl pkcs12 -in certificate.p12 -out ssl/cert.pem -clcerts -nokeys
openssl pkcs12 -in certificate.p12 -out ssl/key.pem -nocerts -nodes
```

## 安全提醒

- 私钥文件包含敏感信息，请妥善保管
- 不要将私钥文件提交到版本控制系统
- 定期检查证书有效期并及时更新
