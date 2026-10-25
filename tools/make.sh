#!/bin/sh
# 時刻データ(raw/*.txt)からページを組み立てる。
# 出力: tools/artifact.html (claude.ai Artifact 用) と ../index.html (GitHub Pages 用)
set -e
cd "$(dirname "$0")"
python3 -I build.py raw > data.json
cat head.html extra.css body1.html data.json body2.html > artifact.html
python3 -I - <<'PY'
src=open('artifact.html',encoding='utf-8').read().replace('<title>葛西トラックターミナル周辺バス</title>','<title>葛西バス</title>',1)
head='''<!doctype html>
<html lang="ja">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<meta name="theme-color" content="#0a7a4f">
<link rel="manifest" href="manifest.webmanifest">
<link rel="icon" href="icon-192.png">
<link rel="apple-touch-icon" href="icon-192.png">
<style>:root{padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0}</style>
'''
i=src.index('<div class="wrap">')
tail='\n<script>if("serviceWorker" in navigator)navigator.serviceWorker.register("sw.js").catch(()=>{});</script>\n</body></html>\n'
open('../index.html','w',encoding='utf-8').write(head+src[:i]+'</head>\n<body>\n'+src[i:]+tail)
PY
rm data.json
