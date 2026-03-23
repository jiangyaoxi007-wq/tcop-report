import http.server, json, base64, os

class Handler(http.server.BaseHTTPRequestHandler):
    def do_POST(self):
        length = int(self.headers['Content-Length'])
        data = json.loads(self.rfile.read(length))
        fname = data['filename']
        img_data = data['data'].split(',')[1] if ',' in data['data'] else data['data']
        path = f"/Users/yoxi/Documents/JYX-Test-0319/tcop-report/screenshots/{fname}"
        with open(path, 'wb') as f:
            f.write(base64.b64decode(img_data))
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        self.wfile.write(b'{"ok":true}')
        print(f"Saved: {path}")
    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'POST')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type')
        self.end_headers()
    def log_message(self, *args): pass

os.makedirs('/Users/yoxi/Documents/JYX-Test-0319/tcop-report/screenshots', exist_ok=True)
print("Screenshot server running on port 9999...")
http.server.HTTPServer(('', 9999), Handler).serve_forever()
