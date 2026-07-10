# Codex教程 GitHub 同步工具
# 用法: .\git_sync.ps1 [命令] [参数]
#
# 命令:
#   status              - 查看当前Git状态
#   push [说明]         - 推送所有更改到GitHub
#   pull                - 从GitHub拉取最新更改
#   add <路径>          - 添加指定文件/文件夹到Git
#   commit <说明>       - 提交已添加的更改
#   log                 - 查看提交历史
#   help                - 显示帮助信息
#
param(
    [string]$Command = "help",
    [string]$Param1 = ""
)

function Show-Status {
    Write-Host "=== Git 状态 ===" -ForegroundColor Cyan
    git status
}

function Push-Changes {
    param([string]$Message = "")
    
    Write-Host "=== 推送更改到 GitHub ===" -ForegroundColor Green
    
    # 检查是否有更改
    $status = git status --short
    if ([string]::IsNullOrEmpty($status)) {
        Write-Host "没有需要推送的更改。" -ForegroundColor Yellow
        return
    }
    
    # 显示当前更改
    Write-Host "[1/4] 当前更改:" -ForegroundColor Cyan
    git status --short
    
    # 添加所有更改
    Write-Host "
[2/4] 添加更改..." -ForegroundColor Cyan
    git add -A
    
    # 提交
    if ([string]::IsNullOrEmpty($Message)) {
        $Message = Read-Host "请输入提交说明"
        if ([string]::IsNullOrEmpty($Message)) {
            $Message = "更新于 $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
        }
    }
    
    Write-Host "
[3/4] 提交更改: $Message" -ForegroundColor Cyan
    git commit -m "$Message"
    
    # 推送到GitHub
    Write-Host "
[4/4] 推送到 GitHub..." -ForegroundColor Cyan
    git push origin master
    
    Write-Host "
=== 推送完成! ===" -ForegroundColor Green
}

function Pull-Changes {
    Write-Host "=== 从 GitHub 拉取最新更改 ===" -ForegroundColor Green
    git pull origin master
    Write-Host "=== 拉取完成! ===" -ForegroundColor Green
}

function Add-Path {
    param([string]$TargetPath)
    
    if ([string]::IsNullOrEmpty($TargetPath)) {
        Write-Host "错误: 请指定要添加的路径" -ForegroundColor Red
        Write-Host "用法: .\git_sync.ps1 add <文件或文件夹路径>"
        return
    }
    
    $fullPath = Resolve-Path $TargetPath -ErrorAction SilentlyContinue
    if (-not $fullPath) {
        Write-Host "错误: 路径不存在: $TargetPath" -ForegroundColor Red
        return
    }
    
    $relativePath = $fullPath.Path.Replace($(Get-Location).Path + '\', '')
    
    Write-Host "=== 添加指定路径到 Git ===" -ForegroundColor Green
    Write-Host "路径: $relativePath"
    
    git add -f "$relativePath"
    
    Write-Host "已添加: $relativePath" -ForegroundColor Green
    Write-Host "提示: 使用 'commit' 命令提交这些更改"
}

function Commit-Changes {
    param([string]$Message)
    
    if ([string]::IsNullOrEmpty($Message)) {
        $Message = Read-Host "请输入提交说明"
    }
    
    if ([string]::IsNullOrEmpty($Message)) {
        $Message = "更新于 $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    }
    
    Write-Host "=== 提交更改 ===" -ForegroundColor Green
    git commit -m "$Message"
}

function Show-Log {
    Write-Host "=== 提交历史 ===" -ForegroundColor Cyan
    git log --oneline --graph --all -20
}

function Show-Help {
    Write-Host "
========================================
   Codex教程 GitHub 同步工具
========================================

用法: .\git_sync.ps1 <命令> [参数]

命令:
  status              查看当前Git状态
  push [说明]          推送所有更改到GitHub
  pull                从GitHub拉取最新更改
  add <路径>           添加指定文件/文件夹到Git
  commit <说明>        提交已添加的更改
  log                 查看提交历史
  help                显示此帮助信息

示例:
  .\git_sync.ps1 status
  .\git_sync.ps1 push "更新教程内容"
  .\git_sync.ps1 pull
  .\git_sync.ps1 add .\Codex实战指南_完整20节教学大纲.md
  .\git_sync.ps1 add .\codex\
  .\git_sync.ps1 commit "添加新教程"
  .\git_sync.ps1 log

提示:
  - 视频文件(.mp4)和PDF默认被忽略，不会同步到GitHub
  - 要强制同步被忽略的文件，使用: git add -f <文件>
  - 当前GitHub仓库: $(git remote get-url origin 2>$null)
========================================" -ForegroundColor Cyan
}

# 主程序
switch ($Command.ToLower()) {
    'status' { Show-Status }
    'push' { Push-Changes -Message $Param1 }
    'pull' { Pull-Changes }
    'add' { Add-Path -TargetPath $Param1 }
    'commit' { Commit-Changes -Message $Param1 }
    'log' { Show-Log }
    default { Show-Help }
}