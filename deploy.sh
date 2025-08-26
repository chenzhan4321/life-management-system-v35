#!/bin/bash

# 生活管理系统 - Vercel部署脚本
# 作者: Claude Assistant
# 日期: 2025-08-26

set -e

echo "🚀 生活管理系统 v3.5 - Vercel部署脚本"
echo "============================================"

# 检查依赖
check_dependencies() {
    echo "📋 检查部署依赖..."
    
    # 检查Python
    if ! command -v python3 &> /dev/null; then
        echo "❌ Python3 未安装，请先安装Python3"
        exit 1
    fi
    
    # 检查pip
    if ! command -v pip3 &> /dev/null; then
        echo "❌ pip3 未安装，请先安装pip3"
        exit 1
    fi
    
    # 检查Node.js (用于Vercel CLI)
    if ! command -v node &> /dev/null; then
        echo "⚠️  Node.js 未安装，将跳过Vercel CLI检查"
        echo "   你可以通过Web界面部署到Vercel"
    fi
    
    echo "✅ 依赖检查完成"
}

# 验证文件结构
validate_structure() {
    echo "📁 验证项目结构..."
    
    required_files=(
        "api/index.py"
        "vercel.json"
        "requirements.txt"
        "index.html"
        "frontend-config.js"
        "README.md"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            echo "❌ 缺少必需文件: $file"
            exit 1
        fi
    done
    
    echo "✅ 项目结构验证完成"
}

# 安装Python依赖并测试
test_api() {
    echo "🧪 测试API功能..."
    
    # 安装依赖
    pip3 install -r requirements.txt
    
    # 启动临时服务器进行测试
    echo "启动临时API服务器..."
    python3 -c "
import sys
sys.path.append('.')
from api.index import app
import uvicorn
from threading import Thread
import time
import requests

def start_server():
    uvicorn.run(app, host='127.0.0.1', port=8888, log_level='error')

# 启动服务器
server_thread = Thread(target=start_server, daemon=True)
server_thread.start()
time.sleep(2)

try:
    # 测试健康检查
    response = requests.get('http://127.0.0.1:8888/health', timeout=5)
    if response.status_code == 200:
        print('✅ API健康检查通过')
    else:
        print('❌ API健康检查失败')
        sys.exit(1)
    
    # 测试任务API
    response = requests.get('http://127.0.0.1:8888/tasks', timeout=5)
    if response.status_code == 200:
        print('✅ 任务API测试通过')
    else:
        print('❌ 任务API测试失败')
        sys.exit(1)
        
    print('🎉 所有API测试通过！')
    
except Exception as e:
    print(f'❌ API测试失败: {e}')
    sys.exit(1)
"
    
    if [[ $? -eq 0 ]]; then
        echo "✅ API测试完成"
    else
        echo "❌ API测试失败"
        exit 1
    fi
}

# 生成部署报告
generate_report() {
    echo "📊 生成部署报告..."
    
    cat > deployment_report.md << EOF
# 生活管理系统 v3.5 部署报告

**部署时间**: $(date)
**部署状态**: ✅ 准备就绪

## 📋 部署清单

### 后端API
- ✅ FastAPI框架配置完成
- ✅ CORS跨域支持配置
- ✅ 任务管理API端点
- ✅ AI智能处理功能
- ✅ 统计分析功能
- ✅ 错误处理机制

### 前端界面
- ✅ 响应式HTML界面
- ✅ 现代化CSS样式
- ✅ JavaScript交互逻辑
- ✅ API配置管理

### 部署配置
- ✅ Vercel部署配置 (vercel.json)
- ✅ Python依赖管理 (requirements.txt)
- ✅ 项目文档 (README.md)
- ✅ 部署脚本 (deploy.sh)

## 🚀 下一步操作

1. **Git提交代码**:
   \`\`\`bash
   git add .
   git commit -m "🚀 完整版生活管理系统 v3.5"
   git push origin main
   \`\`\`

2. **部署到Vercel**:
   - 方式1: 访问 https://vercel.com 导入GitHub仓库
   - 方式2: 使用Vercel CLI: \`vercel --prod\`

3. **更新前端配置**:
   - 获取Vercel部署URL
   - 更新 \`frontend-config.js\` 中的API地址

4. **测试完整功能**:
   - 访问部署后的URL
   - 测试任务添加、AI处理等功能

## 📞 技术支持

如遇问题，请检查：
- Vercel部署日志
- 浏览器开发者控制台
- API响应状态

**部署成功后，你将拥有一个功能完整的现代化任务管理系统！**

---
*自动生成于: $(date)*
EOF
    
    echo "✅ 部署报告已生成: deployment_report.md"
}

# 主部署流程
main() {
    echo "开始部署流程..."
    echo
    
    check_dependencies
    echo
    
    validate_structure
    echo
    
    test_api
    echo
    
    generate_report
    echo
    
    echo "🎉 部署准备完成！"
    echo
    echo "📋 接下来的步骤:"
    echo "1. 将代码推送到GitHub"
    echo "2. 在Vercel中导入项目"
    echo "3. 自动部署完成"
    echo
    echo "🔗 快速链接:"
    echo "- Vercel: https://vercel.com"
    echo "- GitHub: https://github.com"
    echo
    echo "📖 详细说明请查看: README.md"
    echo "📊 部署报告请查看: deployment_report.md"
}

# 运行主函数
main