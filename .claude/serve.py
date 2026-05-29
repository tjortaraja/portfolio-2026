import http.server, os, sys
os.chdir("/Users/teej/Desktop/Portfolio 2026/Website/files")
handler = http.server.SimpleHTTPRequestHandler
httpd = http.server.HTTPServer(("", 3456), handler)
httpd.serve_forever()
