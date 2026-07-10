@echo off
echo === Codex教程 GitHub 同步脚本 ===
echo.
echo 用法:
echo   sync_github.bat push    - 推送本地更改到 GitHub
echo   sync_github.bat pull    - 从 GitHub 拉取最新更改
echo.
echo 当前时间: %date% %time%
echo.

if "%1"=="push" goto push
if "%1"=="pull" goto pull
if "%1"=="" goto menu

:menu
echo 请选择操作:
echo 1. 推送本地更改到 GitHub
echo 2. 从 GitHub 拉取最新更改
echo 3. 查看当前状态
echo.
set /p choice="请输入选项 (1/2/3): "
if %choice%==1 goto push
if %choice%==2 goto pull
if %choice%==3 goto status
goto end

:push
echo.
echo [1/4] 检查 Git 状态...
git status --short
echo.
echo [2/4] 添加所有更改...
git add -A
echo.
echo [3/4] 提交更改...
set /p msg="请输入提交说明 (直接回车使用默认): "
if "%msg%"=="" set msg="更新于 %date% %time%"
git commit -m "%msg%"
echo.
echo [4/4] 推送到 GitHub...
git push origin master
echo.
echo === 推送完成! ===
goto end

:pull
echo.
echo [1/2] 从 GitHub 拉取最新更改...
git pull origin master
echo.
echo [2/2] 合并完成
echo === 拉取完成! ===
goto end

:status
echo.
echo 当前 Git 状态:
git status
goto end

:end
echo.
echo 按任意键退出...
pause > nul
