@echo off
REM 生成测试用的自签名SSL证书
REM 仅用于开发和测试环境

echo 生成测试用自签名SSL证书...

REM 创建ssl目录
if not exist ssl mkdir ssl

REM 检查是否安装了OpenSSL
where openssl >nul 2>nul
if %errorlevel% neq 0 (
    echo 错误: 未找到 OpenSSL 命令
    echo 请安装 OpenSSL 或使用 Git Bash 运行 generate-test-cert.sh
    echo 下载地址: https://slproweb.com/products/Win32OpenSSL.html
    pause
    exit /b 1
)

REM 生成私钥
openssl genrsa -out ssl/key.pem 2048

REM 创建证书配置文件
echo [req] > ssl/cert.conf
echo default_bits = 2048 >> ssl/cert.conf
echo prompt = no >> ssl/cert.conf
echo default_md = sha256 >> ssl/cert.conf
echo distinguished_name = dn >> ssl/cert.conf
echo req_extensions = v3_req >> ssl/cert.conf
echo. >> ssl/cert.conf
echo [dn] >> ssl/cert.conf
echo C=CN >> ssl/cert.conf
echo ST=Beijing >> ssl/cert.conf
echo L=Beijing >> ssl/cert.conf
echo O=Test Organization >> ssl/cert.conf
echo OU=IT Department >> ssl/cert.conf
echo CN=localhost >> ssl/cert.conf
echo. >> ssl/cert.conf
echo [v3_req] >> ssl/cert.conf
echo basicConstraints = CA:FALSE >> ssl/cert.conf
echo keyUsage = nonRepudiation, digitalSignature, keyEncipherment >> ssl/cert.conf
echo subjectAltName = @alt_names >> ssl/cert.conf
echo. >> ssl/cert.conf
echo [alt_names] >> ssl/cert.conf
echo DNS.1 = localhost >> ssl/cert.conf
echo DNS.2 = *.localhost >> ssl/cert.conf
echo IP.1 = 127.0.0.1 >> ssl/cert.conf
echo IP.2 = ::1 >> ssl/cert.conf

REM 生成自签名证书
openssl req -new -x509 -key ssl/key.pem -out ssl/cert.pem -days 365 -config ssl/cert.conf -extensions v3_req

REM 清理临时文件
del ssl/cert.conf

echo.
echo ✓ 测试证书生成完成！
echo 证书文件：
echo - ssl/cert.pem (证书)
echo - ssl/key.pem (私钥)
echo.
echo 注意：这是自签名证书，仅用于测试！
echo 浏览器会显示安全警告，这是正常的。
echo.
echo 证书信息：
openssl x509 -in ssl/cert.pem -subject -dates -noout

pause