FROM ubuntu:22.04

# Install everything needed
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    wget \
    net-tools \
    vim \
    nano \
    htop \
    tmux \
    python3 \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir /var/run/sshd
RUN echo 'root:Anony#234' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config

# Install Python packages for bot later
RUN pip3 install --no-cache-dir requests psutil schedule

# Create info server script
cat > /info_server.py << 'PYEOF'
import http.server
import socketserver
import os
import json

class InfoHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html; charset=utf-8')
        self.end_headers()

        # Get Railway domain
        domain = os.environ.get('RAILWAY_PUBLIC_DOMAIN', 'Not available')

        html = f'''
<!DOCTYPE html>
<html>
<head>
    <title>DRC VPS - SSH Access</title>
    <style>
        body {{ background: #0a0a0a; color: #00ff41; font-family: monospace; padding: 40px; }}
        h1 {{ color: #ff0055; }}
        .box {{ background: #1a1a1a; padding: 20px; border-radius: 10px; margin: 20px 0; border-left: 3px solid #ff0055; }}
        .cmd {{ background: #000; padding: 10px; border-radius: 5px; color: #0ff; }}
        .warning {{ color: #ffaa00; }}
    </style>
</head>
<body>
    <h1>🔥 DRC VPS CONTROL CENTER</h1>
    <div class="box">
        <h2>📡 Railway Domain</h2>
        <p><strong>{domain}</strong></p>
    </div>
    <div class="box">
        <h2>🔐 SSH Access</h2>
        <p>User: <strong>root</strong></p>
        <p>Pass: <strong>Anony#234</strong></p>
        <p class="warning">⚠️ Railway does NOT expose port 22 publicly by default</p>
    </div>
    <div class="box">
        <h2>⚡ Quick Actions</h2>
        <p>1. Railway Dashboard → Deployments → Logs</p>
        <p>2. Or use Railway CLI: <span class="cmd">railway ssh</span></p>
    </div>
    <div class="box">
        <h2>🚀 Next Steps</h2>
        <p>Use Railway's built-in SSH:</p>
        <div class="cmd">railway login<br>railway link<br>railway ssh</div>
    </div>
</body>
</html>
'''
        self.wfile.write(html.encode())

    def log_message(self, format, *args):
        pass

PORT = int(os.environ.get('PORT', 8080))
with socketserver.TCPServer(("0.0.0.0", PORT), InfoHandler) as httpd:
    print(f"[+] Info server on port {PORT}")
    httpd.serve_forever()
PYEOF

# Expose the port Railway assigns
ENV PORT=8080
EXPOSE 8080

# Start everything
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
