# 第9节：CLI 入门

> 详细讲解脚本

---

## 1. 安装 CLI（3分钟）

【录屏】在终端输入 npm install -g @openai/codex，等待安装完成。然后用 codex auth login 登录。安装很简单，两行命令搞定。

---

## 2. 核心命令（3分钟）

最基础的用法就是 codex 后面跟你的需求描述。比如 codex 「帮我写一个 Python 快速排序」。还可以用 --model 指定模型，用 --approval-mode 设置权限模式。

---

## 3. CLI 改代码实战（4分钟）

【录屏】进入项目目录，输入 codex 「找到 main.py 里的 bug 并修复」。Codex 会读取代码、分析问题、修改文件。你审查 diff 确认后提交就完成了。

---


> 预计总时长：约10分钟

> 本节关键词：安装 CLI, 核心命令, CLI 改代码实战
