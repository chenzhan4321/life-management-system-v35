#!/bin/bash

# GitHub自动上传脚本 - 生活管理系统 v3.5
# 作者: Claude Assistant
# 日期: 2025-08-26

set -e

echo "🚀 GitHub自动上传脚本"
echo "======================="

# 项目信息
PROJECT_NAME="life-management-system-v35"
DESCRIPTION="🎯 现代化生活管理系统 v3.5 - FastAPI + Vercel + AI智能处理"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印彩色消息
print_message() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}📋 $1${NC}"
}

# 检查Git安装
check_git() {
    print_info "检查Git安装..."
    if ! command -v git &> /dev/null; then
        print_error "Git未安装，请先安装Git"
        echo "下载地址: https://git-scm.com/downloads"
        exit 1
    fi
    print_message "Git已安装"
}

# 检查GitHub CLI (可选)
check_github_cli() {
    if command -v gh &> /dev/null; then
        echo -e "${GREEN}📱 检测到GitHub CLI，将使用自动创建仓库功能${NC}"
        return 0
    else
        echo -e "${YELLOW}📱 未检测到GitHub CLI，需要手动创建仓库${NC}"
        return 1
    fi
}

# 初始化Git仓库
init_git() {
    print_info "初始化Git仓库..."
    
    if [ -d ".git" ]; then
        print_warning "Git仓库已存在，跳过初始化"
    else
        git init
        print_message "Git仓库初始化完成"
    fi
    
    # 配置Git用户信息（如果未配置）
    if [ -z "$(git config user.name)" ]; then
        echo -n "请输入你的Git用户名: "
        read git_username
        git config user.name "$git_username"
    fi
    
    if [ -z "$(git config user.email)" ]; then
        echo -n "请输入你的Git邮箱: "
        read git_email
        git config user.email "$git_email"
    fi
    
    print_message "Git配置完成"
}

# 添加文件并提交
commit_files() {
    print_info "添加文件到Git..."
    
    # 添加所有文件
    git add .
    
    # 检查是否有文件变更
    if git diff --staged --quiet; then
        print_warning "没有文件变更，跳过提交"
        return
    fi
    
    # 提交文件
    commit_message="🚀 生活管理系统 v3.5 完整版

✨ 功能特性:
- 🎯 FastAPI后端 + Vercel部署
- 🤖 AI智能任务处理
- 📊 实时统计分析
- 🎨 现代化响应式UI
- 📱 PWA支持
- 🔒 完整CORS配置

🏗️ 技术架构:
- 后端: FastAPI + Vercel Serverless
- 前端: HTML5 + CSS3 + JavaScript
- 部署: 零配置一键部署
- 存储: 内存存储（可扩展）

📦 包含文件:
- api/index.py - 完整后端API
- index.html - 现代化前端
- vercel.json - 部署配置
- README.md - 完整文档
- deploy.sh - 自动化脚本

🎉 立即可用，一键部署到Vercel！"

    git commit -m "$commit_message"
    print_message "文件提交完成"
}

# 使用GitHub CLI创建仓库
create_repo_with_cli() {
    print_info "使用GitHub CLI创建仓库..."
    
    gh repo create "$PROJECT_NAME" \
        --description "$DESCRIPTION" \
        --public \
        --push \
        --source .
    
    print_message "仓库创建并推送完成"
    
    # 获取仓库URL
    REPO_URL=$(gh repo view --json url --jq .url)
    echo
    print_message "🎉 仓库创建成功！"
    print_info "仓库地址: $REPO_URL"
}

# 手动创建仓库说明
manual_repo_creation() {
    print_info "手动创建GitHub仓库..."
    
    echo
    echo "请按以下步骤手动创建仓库:"
    echo
    echo "1. 访问 https://github.com/new"
    echo "2. 仓库名称: $PROJECT_NAME"
    echo "3. 描述: $DESCRIPTION"
    echo "4. 设置为公开仓库 (Public)"
    echo "5. 不要勾选 README、.gitignore、License"
    echo "6. 点击 'Create repository'"
    echo
    echo -n "仓库创建完成后，请输入仓库URL (格式: https://github.com/用户名/仓库名): "
    read repo_url
    
    if [ -z "$repo_url" ]; then
        print_error "仓库URL不能为空"
        exit 1
    fi
    
    # 添加远程仓库
    if git remote get-url origin &> /dev/null; then
        git remote set-url origin "$repo_url.git"
    else
        git remote add origin "$repo_url.git"
    fi
    
    # 推送代码
    print_info "推送代码到GitHub..."
    git branch -M main
    git push -u origin main
    
    print_message "代码推送完成"
    print_info "仓库地址: $repo_url"
}

# 生成部署说明
generate_deployment_info() {
    print_info "生成部署信息..."
    
    cat > GITHUB_DEPLOYMENT_INFO.md << EOF
# 🎉 GitHub上传成功！

## 📋 仓库信息
- **项目名称**: $PROJECT_NAME
- **描述**: $DESCRIPTION
- **创建时间**: $(date)

## 🚀 下一步：Vercel部署

### 1. 访问Vercel
打开 [https://vercel.com](https://vercel.com) 并登录

### 2. 导入项目
1. 点击 "New Project"
2. 选择 "Import Git Repository"
3. 选择你刚创建的仓库: \`$PROJECT_NAME\`

### 3. 配置部署
- **Framework**: 自动检测为 "Other"
- **Root Directory**: \`./\` (默认)
- **Build Command**: 留空 (自动检测)
- **Output Directory**: 留空 (自动检测)

### 4. 点击部署
点击 "Deploy" 按钮，Vercel会自动：
- 检测到 \`vercel.json\` 配置
- 安装Python依赖
- 部署Serverless函数
- 生成全球CDN链接

### 5. 获取URL
部署完成后，你会获得类似这样的URL：
\`https://life-management-system-v35-abc123.vercel.app\`

### 6. 测试功能
访问你的Vercel URL，测试：
- ✅ 健康检查页面
- ✅ 添加任务功能  
- ✅ AI智能处理
- ✅ 统计面板

## 🔧 可选：自定义域名

如果你有自己的域名：
1. 在Vercel项目设置中点击 "Domains"
2. 添加你的域名
3. 根据提示配置DNS记录

## 📞 需要帮助？

如果遇到问题：
1. 查看Vercel构建日志
2. 检查浏览器开发者工具
3. 确保所有文件都已正确上传

## 🎊 恭喜！

你的生活管理系统现在已经：
- ✅ 成功上传到GitHub
- ✅ 准备好一键部署到Vercel
- ✅ 具备生产级特性
- ✅ 支持全球访问

**下一步**: 打开Vercel开始部署吧！

---
*自动生成于: $(date)*
EOF

    print_message "部署信息已生成: GITHUB_DEPLOYMENT_INFO.md"
}

# 主函数
main() {
    echo "🎯 开始上传生活管理系统到GitHub..."
    echo
    
    # 检查环境
    check_git
    
    # 初始化Git
    init_git
    
    # 提交文件
    commit_files
    
    # 创建GitHub仓库
    if check_github_cli; then
        echo
        echo "选择创建方式:"
        echo "1. 使用GitHub CLI自动创建 (推荐)"
        echo "2. 手动创建仓库"
        echo -n "请选择 (1-2): "
        read choice
        
        case $choice in
            1)
                create_repo_with_cli
                ;;
            2)
                manual_repo_creation
                ;;
            *)
                print_warning "无效选择，使用手动创建方式"
                manual_repo_creation
                ;;
        esac
    else
        manual_repo_creation
    fi
    
    # 生成部署信息
    generate_deployment_info
    
    echo
    print_message "🎉 GitHub上传完成！"
    echo
    print_info "接下来请:"
    print_info "1. 访问 https://vercel.com"
    print_info "2. 导入你的GitHub仓库"
    print_info "3. 一键部署完成"
    echo
    print_info "详细说明请查看: GITHUB_DEPLOYMENT_INFO.md"
}

# 运行主函数
main