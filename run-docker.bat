@echo off
REM 直接使用Docker运行应用的脚本
REM 这是DOCKER_DEPLOY.md中方法三的自动化版本

echo 使用Docker直接运行Nuxt应用...

REM 检查环境变量文件
if not exist .env (
    echo 错误: .env 文件不存在！
    echo 请先运行: copy .env.example .env
    echo 然后编辑 .env 文件设置你的域名和邮箱
    pause
    exit /b 1
)

REM 检查SSL证书文件
if not exist ssl\cert.pem (
    echo 错误: SSL证书文件不存在！
    echo 请将SSL证书文件放在 ssl\ 目录下：
    echo - ssl\cert.pem (证书文件)
    echo - ssl\key.pem (私钥文件)
    echo.
    echo 或运行测试证书生成脚本: generate-test-cert.bat
    pause
    exit /b 1
)

if not exist ssl\key.pem (
    echo 错误: SSL私钥文件不存在！
    echo 请将SSL证书文件放在 ssl\ 目录下：
    echo - ssl\cert.pem (证书文件)
    echo - ssl\key.pem (私钥文件)
    echo.
    echo 或运行测试证书生成脚本: generate-test-cert.bat
    pause
    exit /b 1
)

REM 停止并删除现有容器（如果存在）
docker ps -a | findstr localsent-web >nul 2>&1
if %errorlevel% equ 0 (
    echo 停止并删除现有容器...
    docker stop localsent-web >nul 2>&1
    docker rm localsent-web >nul 2>&1
)

REM 构建镜像
echo 构建Docker镜像...
docker build -t localsent-web-app .

if %errorlevel% neq 0 (
    echo 错误: Docker镜像构建失败！
    pause
    exit /b 1
)

REM 运行容器
echo 启动容器...
docker run -d -p 80:80 -p 443:443 -v %cd%/ssl:/etc/ssl/certs:ro --env-file .env --name localsent-web localsent-web-app

if %errorlevel% equ 0 (
    echo ✓ 容器启动成功！
    echo.
    echo 应用已在以下地址运行：
    echo HTTP: http://localhost (将自动重定向到HTTPS)
    echo HTTPS: https://localhost
    echo.
    echo 查看日志: docker logs -f localsent-web
    echo 停止容器: docker stop localsent-web
    echo.
    echo 容器状态：
    docker ps | findstr localsent-web
) else (
    echo ✗ 容器启动失败！
    echo 查看错误日志: docker logs localsent-web
    pause
    exit /b 1
)

pause