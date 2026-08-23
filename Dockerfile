FROM ubuntu:24.04

LABEL maintainer="DRC"
LABEL description="DRC VPS - Ubuntu 24.04 with SSH + ngrok + 16GB Swap"

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Install everything
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    wget \
    unzip \
    jq \
    htop \
    tmux \
    vim \
    nano \
    net-tools \
    iputils-ping \
    python3 \
    python3-pip \
    git \
    ffmpeg \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libatspi2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Setup 16GB swap
RUN fallocate -l 16G /swapfile || dd if=/dev/zero of=/swapfile bs=1G count=16 \
    && chmod 600 /swapfile \
    && mkswap /swapfile \
    && swapon /swapfile \
    && echo '/swapfile none swap sw 0 0' >> /etc/fstab

# Setup SSH
RUN mkdir -p /var/run/sshd \
    && echo 'root:root123' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config

# Install ngrok
RUN curl -sSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -o ngrok.tgz \
    && tar -xzf ngrok.tgz -C /usr/local/bin \
    && rm ngrok.tgz \
    && ngrok version

# ngrok token EMBEDDED (no env var needed)
RUN ngrok config add-authtoken 3HuPDUNr8MzvSSMkyIDKhrmqK5V_4n78XtG7aihTWjVAhcTxr

# Install Python packages for bot
RUN pip3 install --no-cache-dir playwright requests psutil schedule \
    && playwright install chromium \
    && playwright install-deps chromium

# Create startup script
RUN cat > /start.sh << 'EOF'
#!/bin/bash
echo "=========================================="
echo "  🔥 DRC VPS STARTING"
echo "=========================================="

# Show resources
echo "[+] RAM + Swap:"
free -h

# Start SSH
service ssh start
echo "[+] SSH started on port 22"

# Start ngrok tunnel
echo "[+] Starting ngrok tunnel..."
ngrok tcp 22 --region ap &
sleep 10

# Get and display tunnel info
TUNNEL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
if [ -n "$TUNNEL" ] && [ "$TUNNEL" != "null" ]; then
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
else
    echo "[!] Tunnel info:"
    curl -s http://localhost:4040/api/tunnels | jq .
fi

# Keep alive + auto-restart
echo ""
echo "[+] VPS running - auto-restart enabled"
while true; do
    if ! curl -s http://localhost:4040/api/tunnels > /dev/null 2>&1; then
        echo "⚠️  Tunnel died! Restarting..."
        pkill ngrok || true
        ngrok tcp 22 --region ap &
        sleep 10
        TUNNEL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
        echo "🌐 New URL: $TUNNEL"
    fi
    sleep 300
done
EOF
RUN chmod +x /start.sh

# Expose SSH port (Railway will map this)
EXPOSE 22

# Health check
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=3 \
    CMD service ssh status || exit 1

# Start everything
CMD ["/start.sh"]
