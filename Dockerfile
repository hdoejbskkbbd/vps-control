FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies (exact from yesf workflow)
RUN apt-get update -qq && apt-get install -y -qq \
    openssh-server curl wget unzip jq > /dev/null 2>&1

# Setup SSH & Root (exact from yesf)
RUN systemctl enable ssh 2>/dev/null || true \
    && service ssh start 2>/dev/null || true \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && echo "root:root123" | chpasswd

# Install ngrok (exact from yesf)
RUN curl -sSL https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz -o ngrok.tgz \
    && tar -xzf ngrok.tgz -C /usr/local/bin \
    && rm ngrok.tgz

# Auth ngrok (EXACT token from yesf)
RUN ngrok config add-authtoken 3HuPDUNr8MzvSSMkyIDKhrmqK5V_4n78XtG7aihTWjVAhcTxr

# Create startup script (exact yesf logic)
RUN cat > /start.sh << 'EOF'
#!/bin/bash
set -x

echo "=========================================="
echo "  DRC VPS - ngrok SSH Tunnel"
echo "=========================================="

# Start SSH
service ssh start || /usr/sbin/sshd
echo "[+] SSH started"

# Start ngrok
ngrok tcp 22 --region ap &
sleep 10

# Get connection details
echo ""
echo "=========================================="
echo "  SSH Connection Details:"
echo "=========================================="

TUNNEL=$(curl -s --max-time 10 http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url // empty')
if [ -n "$TUNNEL" ]; then
    echo "URL: $TUNNEL"
    HOST=$(echo $TUNNEL | sed 's|tcp://||' | cut -d: -f1)
    PORT=$(echo $TUNNEL | sed 's|tcp://||' | cut -d: -f2)
    echo "Host: $HOST"
    echo "Port: $PORT"
else
    echo "[!] Tunnel not ready, retrying..."
    sleep 10
    TUNNEL=$(curl -s --max-time 10 http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url // empty')
    echo "URL: $TUNNEL"
fi

echo ""
echo "Username: root"
echo "Password: root123"
echo "=========================================="

# KEEP ALIVE (exact from yesf)
while true; do
    echo "⏳ Still running... $(date)"

    if ! curl -s http://localhost:4040/api/tunnels > /dev/null 2>&1; then
        echo "⚠️ Tunnel died! Restarting..."
        pkill ngrok || true
        ngrok tcp 22 --region ap &
        sleep 10
        TUNNEL=$(curl -s http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url // empty')
        echo "New URL: $TUNNEL"
    fi

    sleep 300
done
EOF
RUN chmod +x /start.sh

EXPOSE 22
EXPOSE 4040

CMD ["/start.sh"]
