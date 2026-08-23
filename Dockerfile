FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Install everything including a web-based terminal
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
    ttyd \
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
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Install Python packages for bot
RUN pip3 install --no-cache-dir playwright requests psutil schedule \
    && playwright install chromium \
    && playwright install-deps chromium

# Create web terminal + info server script
RUN cat > /start.sh << 'EOF'
#!/bin/bash
echo "=========================================="
echo "  🔥 DRC VPS STARTING"
echo "=========================================="

# Show resources
echo "[+] System Info:"
free -h
echo ""

# Start SSH
service ssh start
echo "[+] SSH started internally"

# Get Railway public domain
RAILWAY_DOMAIN=${RAILWAY_PUBLIC_DOMAIN:-"not-set"}
STATIC_URL=${RAILWAY_STATIC_URL:-"not-set"}

echo ""
echo "=========================================="
echo "  🌐 RAILWAY ACCESS"
echo "=========================================="
echo "  Public Domain: $RAILWAY_DOMAIN"
echo "  Static URL: $STATIC_URL"
echo ""
echo "  Web Terminal: https://$RAILWAY_DOMAIN"
echo "  (ttyd - web-based terminal)"
echo ""
echo "  SSH (internal only):"
echo "    User: root"
echo "    Pass: root123"
echo "=========================================="

# Start web terminal on Railway's PORT
echo "[+] Starting web terminal on port ${PORT:-8080}..."
ttyd -p ${PORT:-8080} -c root:root123 bash &

# Keep alive
echo "[+] VPS running..."
while true; do
    echo "⏳ [$(date)] DRC VPS alive | Domain: $RAILWAY_DOMAIN"
    sleep 300
done
EOF
RUN chmod +x /start.sh

# Expose Railway port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:${PORT:-8080} || exit 1

CMD ["/start.sh"]
