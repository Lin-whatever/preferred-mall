@echo off
echo 正在停止所有 Java 进程...
taskkill /F /IM java.exe >nul 2>&1
echo 已停止
pause
