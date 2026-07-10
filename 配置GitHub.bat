@echo off
chcp 65001 >nul
title Codex教程 GitHub 一键配置工具
echo.
echo ==========================================
echo    Codex教程 GitHub 一键配置工具
echo ==========================================
echo.
echo 使用前请修改以下参数：
echo.
echo 第1步：填写你的 GitHub 信息
echo 第2步：保存并双击运行此文件
echo.
echo ==========================================
echo.

REM ==========================================
REM 请在这里填写你的参数（修改等号后面的内容）
REM ==========================================

REM 你的 GitHub 用户名
set GITHUB_USERNAME=eg0u9173

REM 你的 GitHub 邮箱（用于Git提交记录）
set GITHUB_EMAIL=your-email@example.com

REM 你的 GitHub 仓库名称（可以自定义）
set REPO_NAME=liyun

REM 你的 GitHub 个人访问令牌（Token）
REM 获取方式：https://github.com/settings/tokens -
REM 点击 "Generate new token" -
REM 勾选 "repo" 权限 -
REM 生成后复制到这里
set GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx

REM 本地项目路径（一般不需要修改）
set LOCAL_PATH=G:\codex教程

REM ==========================================
REM 参数填写完成，下面开始自动配置
REM ==========================================

echo.
echo [1/8] 检查参数...
echo.

if "%GITHUB_USERNAME%"=="你的GitHub用户名" (
    echo 错误：请修改 GITHUB_USERNAME 参数！
    echo 请右键编辑此文件，填写你的GitHub用户名。
    pause
    exit /b 1
)

if "%GITHUB_TOKEN%"=="ghp_xxxxxxxxxxxxxxxxxxxx" (
    echo 错误：请修改 GITHUB_TOKEN 参数！
    echo 请右键编辑此文件，填写你的GitHub Token。
    echo 获取方式：https://github.com/settings/tokens
    pause
    exit /b 1
)

echo [2/8] 配置Git用户信息...
cd /d %LOCAL_PATH%
git config user.name "%GITHUB_USERNAME%"
git config user.email "%GITHUB_EMAIL%"
echo 完成！

echo.
echo [3/8] 设置远程仓库...
git remote remove origin 2>nul
git remote add origin https://%GITHUB_TOKEN%@github.com/%GITHUB_USERNAME%/%REPO_NAME%.git
echo 完成！

echo.
echo [4/8] 检查GitHub仓库是否存在...
REM 尝试推送，如果失败则创建仓库
git push -u origin master >push_result.txt 2>&1
findstr /C:"failed" push_result.txt >nul
if %errorlevel%==0 (
    echo 仓库不存在，正在创建...
    
    REM 使用curl创建仓库
    curl -s -X POST -H "Authorization: token %GITHUB_TOKEN%" -H "Accept: application/vnd.github.v3+json" https://api.github.com/user/repos -d "{\"name\":\"%REPO_NAME%\",\"private\":false}" >create_repo.json
    
    echo 仓库创建完成！
    echo.
    echo [5/8] 重新推送...
    git push -u origin master
) else (
    echo 仓库已存在，推送成功！
)
del push_result.txt 2>nul

echo.
echo [6/8] 验证配置...
git remote -v
echo 完成！

echo.
echo [7/8] 创建快捷同步脚本...
(
echo @echo off
chcp 65001 ^>nul
echo title Codex教程 GitHub同步
echo cd /d %LOCAL_PATH%
echo echo ==========================================
echo echo    Codex教程 GitHub 同步工具
echo echo ==========================================
echo echo.
echo echo 用法：双击运行后选择操作
echo echo.
echo echo 1. 推送本地更改到GitHub
echo echo 2. 从GitHub拉取最新更改
echo echo 3. 查看Git状态
echo echo 4. 退出
echo echo.
echo set /p choice=请选择操作 (1-4)：
echo.
echo if "%%choice%%"=="1" goto push
echo if "%%choice%%"=="2" goto pull
echo if "%%choice%%"=="3" goto status
echo if "%%choice%%"=="4" goto end
echo goto menu
echo.
echo :push
echo echo [1/3] 添加更改...
echo git add -A
echo echo [2/3] 提交更改...
echo set /p msg=请输入提交说明（直接回车使用默认）：
echo if "%%msg%%"=="" set msg=更新于 %%date%% %%time%%
echo git commit -m "%%msg%%"
echo echo [3/3] 推送到GitHub...
echo git push origin master
echo echo.
echo echo === 推送完成！===
echo pause
echo goto end
echo.
echo :pull
echo echo 正在拉取最新更改...
echo git pull origin master
echo echo === 拉取完成！===
echo pause
echo goto end
echo.
echo :status
echo git status
echo pause
echo goto end
echo.
echo :end
) > "%LOCAL_PATH%\一键同步.bat"

echo 完成！

echo.
echo [8/8] 创建指定文件同步脚本...
(
echo @echo off
chcp 65001 ^>nul
echo title 同步指定文件到GitHub
echo cd /d %LOCAL_PATH%
echo echo ==========================================
echo echo    同步指定文件到 GitHub
echo echo ==========================================
echo echo.
echo echo 用法：
echo echo   1. 将文件路径拖放到此窗口，或手动输入
echo echo   2. 支持单个文件或整个文件夹
echo echo.
echo set /p filepath=请输入要同步的文件/文件夹路径：
echo.
echo echo 正在添加文件...
echo git add -f "%%filepath%%"
echo echo.
echo set /p msg=请输入提交说明：
echo if "%%msg%%"=="" set msg=更新文件 %%filepath%%
echo git commit -m "%%msg%%"
echo echo.
echo echo 正在推送到GitHub...
echo git push origin master
echo echo.
echo echo === 同步完成！===
echo pause
) > "%LOCAL_PATH%\同步指定文件.bat"

echo 完成！

echo.
echo ==========================================
echo    配置完成！
echo ==========================================
echo.
echo 已创建的快捷工具：
echo   1. 一键同步.bat          - 日常同步所有更改
echo   2. 同步指定文件.bat      - 同步特定文件/文件夹
echo   3. git_sync.ps1          - 高级命令行工具
echo.
echo 使用方式：
echo   - 日常更新：双击 "一键同步.bat"
echo   - 同步特定文件：双击 "同步指定文件.bat"
echo   - 高级操作：使用 git_sync.ps1 命令
echo.
echo 示例：
echo   git_sync.ps1 status          查看状态
echo   git_sync.ps1 push            推送所有更改
echo   git_sync.ps1 pull            拉取最新更改
echo   git_sync.ps1 add .\文件.md   添加指定文件
echo   git_sync.ps1 log             查看历史
echo.
echo ==========================================
echo.
pause
