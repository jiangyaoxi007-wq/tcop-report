#!/bin/bash
set -e

REPO="tcop-report"
USER="jiangyaoxi03"
API="https://api.github.com"

echo "🔑 请输入 GitHub Personal Access Token (需要 repo 权限):"
read -s TOKEN

echo ""
echo "📦 Step 1: 创建仓库..."
curl -s -X POST "$API/user/repos" \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"name\":\"$REPO\",\"description\":\"腾讯云可观测平台竞品分析报告\",\"public\":true,\"auto_init\":false}" \
  | python3 -c "import sys,json; r=json.load(sys.stdin); print('✅ 仓库创建成功:', r.get('html_url','')) if 'html_url' in r else print('⚠️ ', r.get('message',''))"

echo ""
echo "📝 Step 2: 初始化 git 并推送..."
cd /Users/yoxi/Documents/JYX-Test-0319/tcop-report
git init -b main 2>/dev/null || git init && git checkout -b main 2>/dev/null || true
git config user.email "deploy@tcop-report"
git config user.name "Deploy Bot"
git add .
git commit -m "Deploy: TCOP竞品分析报告" 2>/dev/null || true
git remote remove origin 2>/dev/null || true
git remote add origin "https://$TOKEN@github.com/$USER/$REPO.git"
git push -u origin main --force
echo "✅ 代码已推送"

echo ""
echo "🌐 Step 3: 启用 GitHub Pages..."
sleep 2
curl -s -X POST "$API/repos/$USER/$REPO/pages" \
  -H "Authorization: token $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"source":{"branch":"main","path":"/"}}' \
  | python3 -c "import sys,json; r=json.load(sys.stdin); print('✅ Pages 已启用:', r.get('html_url','')) if 'html_url' in r else print('ℹ️ ', r.get('message',''))"

echo ""
echo "🎉 部署完成！"
echo "📖 报告链接（约1-2分钟后生效）: https://$USER.github.io/$REPO"
