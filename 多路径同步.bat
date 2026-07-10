@echo off
chcp 65001 >nul
title 多路径 GitHub 同步工具
echo.
echo ==========================================
echo    多路径 GitHub 同步工具
echo ==========================================
echo.

REM ==========================================
REM 配置区域 - 修改这里添加更多路径
REM ==========================================

REM 主项目路径（当前已配置）
set PATH1=G:\codex教程
set REPO1=https://github.com/eg0u9173/liyun.git

REM 你可以添加更多路径，格式如下：
REM set PATH2=G:\其他项目
REM set REPO2=https://github.com/eg0u9173/其他仓库.git

REM set PATH3=D:\我的文档
REM set REPO3=https://github.com/eg0u9173/文档仓库.git

REM ==========================================
REM 菜单
REM ==========================================

:menu
echo.
echo 请选择要同步的项目：
echo.
echo [1] codex教程  -  %PATH1%
echo     仓库: %REPO1%
echo.
REM echo [2] 其他项目   -  %PATH2%
REM echo     仓库: %REPO2%
REM echo.
echo [0] 退出
echo.
set /p choice="请输入选项 (1/0): "

if "%choice%"=="1" goto sync1
if "%choice%"=="0" goto end
goto menu

REM ==========================================
REM 同步项目1
REM ==========================================
:sync1
echo.
echo ==========================================
echo 同步项目: codex教程
echo ==========================================
echo.
cd /d %PATH1%

REM 检查是否是git仓库
if not exist .git (
    echo 初始化Git仓库...
    git init
    git remote add origin %REPO1%
)

echo.
echo [1/4] 检查更改...
git status --short

echo.
echo [2/4] 添加更改...
git add -A

echo.
echo [3/4] 提交更改...
set /p msg="请输入提交说明 (直接回车使用默认): "
if "%msg%"=="" set msg=更新于 %date% %time%
git commit -m "%msg%"

echo.
echo [4/4] 推送到GitHub...
git push origin master

echo.
echo === 同步完成! ===
echo.
pause
goto menu

:end
echo.
echo 再见!
echo.
