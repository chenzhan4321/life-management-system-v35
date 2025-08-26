// 前端API配置 - 自动检测部署环境
const API_CONFIG = (() => {
    const hostname = window.location.hostname;
    
    // Vercel部署
    if (hostname.includes('vercel.app')) {
        return {
            baseUrl: '',  // 同域API
            platform: 'vercel'
        };
    }
    
    // GitHub Pages - 使用Vercel API
    if (hostname.includes('github.io')) {
        return {
            baseUrl: 'https://YOUR_VERCEL_PROJECT_URL',  // 替换为实际Vercel URL
            platform: 'github-pages'
        };
    }
    
    // 本地开发
    if (hostname === 'localhost' || hostname === '127.0.0.1') {
        return {
            baseUrl: 'http://localhost:8000',
            platform: 'local'
        };
    }
    
    // 默认使用Vercel
    return {
        baseUrl: 'https://YOUR_VERCEL_PROJECT_URL',  // 替换为实际Vercel URL
        platform: 'production'
    };
})();

// 导出配置
window.API_BASE = API_CONFIG.baseUrl;
window.API_PLATFORM = API_CONFIG.platform;

console.log(`🚀 API配置: ${API_CONFIG.platform} - ${API_CONFIG.baseUrl}`);