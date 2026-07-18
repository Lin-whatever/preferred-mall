@echo off
chcp 65001 >nul
echo ================================
echo   优选商城 - 启动中...
echo ================================
echo.
echo [1/2] 启动商城后端...
start "优选商城" java -jar "E:\webweb\eshop	arget\eshop-1.0.0.jar"
echo   等待启动... (约10秒)
timeout /t 8 /nobreak >nul
echo.
echo [2/2] 启动后台管理...
call "D:pache-tomcat-9.0.109pache-tomcat-9.0.109in\startup.bat"
echo.
echo ================================
echo   启动完成！
echo   商城首页: http://localhost:8080/eshop/
echo   后台管理: http://localhost:8081/ecpbm/admin_login.jsp
echo   账号: john / admin  密码: 123456
echo ================================
pause
