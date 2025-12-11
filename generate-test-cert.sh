#!/bin/bash

# 生成测试用的自签名SSL证书
# 仅用于开发和测试环境

echo "生成测试用自签名SSL证书..."

# 创建ssl目录
mkdir -p ssl

# 生成私钥
openssl genrsa -out ssl/key.pem 2048

# 生成证书签名请求配置
cat > ssl/cert.conf << EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = v3_req

[dn]
C=CN
ST=Beijing
L=Beijing
O=Test Organization
OU=IT Department
CN=localhost

[v3_req]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = *.localhost
IP.1 = 127.0.0.1
IP.2 = ::1
EOF

# 生成自签名证书
openssl req -new -x509 -key ssl/key.pem -out ssl/cert.pem -days 365 -config ssl/cert.conf -extensions v3_req

# 清理临时文件
rm ssl/cert.conf

echo "✓ 测试证书生成完成！"
echo "证书文件："
echo "- ssl/cert.pem (证书)"
echo "- ssl/key.pem (私钥)"
echo ""
echo "注意：这是自签名证书，仅用于测试！"
echo "浏览器会显示安全警告，这是正常的。"
echo ""
echo "证书信息："
openssl x509 -in ssl/cert.pem -subject -dates -noout