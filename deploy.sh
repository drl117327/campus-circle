#!/bin/bash
# ============================================
# 校园圈 - GitHub Pages 一键部署脚本
# ============================================
set -e

echo "========================================"
echo "  校园圈 - GitHub Pages 部署脚本"
echo "========================================"
echo ""

# Check gh auth
if ! gh auth status &>/dev/null; then
  echo "🔑 请先登录 GitHub..."
  gh auth login --web --git-protocol https
fi

# Get repo name
REPO_NAME="campus-circle"
echo ""
echo "📦 仓库名称: $REPO_NAME"
echo ""

# Create GitHub repo (public)
echo "🚀 正在创建 GitHub 仓库..."
gh repo create "$REPO_NAME" --public --source . --remote origin --push 2>/dev/null || {
  echo "⚠️  仓库可能已存在，尝试直接推送..."
  git remote add origin "https://github.com/$(gh api user --jq .login)/$REPO_NAME.git" 2>/dev/null || true
  git push -u origin main
}

# Enable GitHub Pages
echo ""
echo "📄 正在启用 GitHub Pages..."
REPO_FULL="$(gh api user --jq .login)/$REPO_NAME"
gh api "repos/$REPO_FULL/pages" -X POST -F "source[branch]=main" -F "source[path]=/" 2>/dev/null || {
  echo "⚠️  Pages 可能已启用，跳过 API 配置"
}

echo ""
echo "========================================"
echo "  ✅ 部署完成！"
echo "========================================"
echo ""
echo "🌐 你的网站地址:"
echo "   https://$(gh api user --jq .login).github.io/$REPO_NAME/"
echo ""
echo "🔗 GitHub 仓库地址:"
echo "   https://github.com/$REPO_FULL"
echo ""
echo "💡 提示: GitHub Pages 首次部署可能需要 1-3 分钟生效"
echo "   如果无法访问，请在仓库 Settings > Pages 中手动确认"
echo "========================================"
