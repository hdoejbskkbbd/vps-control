FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Install deps
RUN apt-get update && apt-get install -y \
    openssh-server curl wget unzip jq htop tmux vim nano net-tools \
    iputils-ping python3 python3-pip git ffmpeg \
    libglib2.0-0 libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libdbus-1-3 libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 libgbm1 libpango-1.0-0 \
    libcairo2 libasound2 libatspi2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 16GB swap
RUN fallocate -l 16G /swapfile || dd if=/dev/zero of=/swapfile bs=1G count=16 \
    && chmod 600 /swapfile && mkswap /swapfile && swapon /swapfile \
    && echo '/swapfile none swap sw 0 0' >> /etc/fstab

# SSH setup
RUN mkdir -p /var/run/sshd && echo 'root:root123' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Install ngrok
RUN curl -sSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -o ngrok.tgz \
    && tar -xzf ngrok.tgz -C /usr/local/bin && rm ngrok.tgz

# ngrok token EMBEDDED
RUN ngrok config add-authtoken 3HuPDUNr8MzvSSMkyIDKhrmqK5V_4n78XtG7aihTWjVAhcTxr

# Python packages
RUN pip3 install --no-cache-dir playwright requests psutil schedule \
    && playwright install chromium && playwright install-deps chromium

# Start script - foreground ngrok with logging
RUN cat > /start.sh << 'SCRIPT'
#!/bin/bash
set -e

echo "=========================================="
echo "  🔥 DRC VPS STARTING"
echo "=========================================="

# Show resources
echo "[+] RAM + Swap:"
free -h
echo ""

# Start SSH
service ssh start
echo "[+] SSH started on port 22"
echo ""

# Start ngrok in foreground with logging
echo "[+] Starting ngrok TCP tunnel..."
echo "[+] Token: 3HuPD... (embedded)"

# Run ngrok in background but capture output
ngrok tcp 22 --region ap --log=stdout > /tmp/ngrok.log 2>&1 &
NGROK_PID=$!

# Wait for tunnel
echo "[+] Waiting for tunnel (30s)..."
sleep 15

# Try to get tunnel info multiple times
for i in 1 2 3 4 5 6; do
    TUNNEL=$(curl -s --max-time 5 http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url // empty')
    if [ -n "$TUNNEL" ]; then
        echo ""
        echo "=========================================="
        echo "  🌐 SSH ACCESS READY"
        echo "=========================================="
        echo "  URL: $TUNNEL"
        HOST=$(echo $TUNNEL | sed 's|tcp://||' | cut -d: -f1)
        PORT=$(echo $TUNNEL | sed 's|tcp://||' | cut -d: -f2)
        echo "  Host: $HOST"
        echo "  Port: $PORT"
        echo ""
        echo "  👤 User: root"
        echo "  🔐 Pass: root123"
        echo "=========================================="
        break
    fi
    echo "  Attempt $i/6..."
    sleep 5
done

# If still no tunnel, show debug info
if [ -z "$TUNNEL" ]; then
    echo ""
    echo "[!] Tunnel not established yet"
    echo "[!] ngrok logs:"
    cat /tmp/ngrok.log | tail -20
    echo ""
    echo "[!] Retrying in 30s..."
    sleep 30
    TUNNEL=$(curl -s --max-time 5 http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url // empty')
    if [ -n "$TUNNEL" ]; then
        echo "🌐 URL: $TUNNEL"
    fi
fi

# Keep alive + monitor
echo ""
echo "[+] VPS running - monitoring tunnel..."
while true; do
    if ! kill -0 $NGROK_PID 2>/dev/null; then
        echo "⚠️  ngrok died! Restarting..."
        ngrok tcp 22 --region ap --log=stdout > /tmp/ngrok.log 2>&1 &
        NGROK_PID=$!
        sleep 15
        TUNNEL=$(curl -s --max-time 5 http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url // empty')
        [ -n "$TUNNEL" ] && echo "🌐 New URL: $TUNNEL"
    fi

    # Check if tunnel still active
    ACTIVE=$(curl -s --max-time 3 http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url // empty')
    if [ -z "$ACTIVE" ]; then
        echo "⚠️  Tunnel lost! Restarting..."
        kill $NGROK_PID 2>/dev/null || true
        ngrok tcp 22 --region ap --log=stdout > /tmp/ngrok.log 2>&1 &
        NGROK_PID=$!
        sleep 15
        ACTIVE=$(curl -s --max-time 5 http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url // empty')
        [ -n "$ACTIVE" ] && echo "🌐 New URL: $ACTIVE"
    fi

    echo "⏳ [$(date)] DRC VPS alive | Tunnel: ${ACTIVE:-checking...}"
    sleep 300
done
SCRIPT
RUN chmod +x /start.sh

EXPOSE 22
EXPOSE 4040

CMD ["/start.sh"]
