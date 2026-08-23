#!/bin/bash
# DRC SSH + ngrok Tunnel Startup

echo "=========================================="
echo "  DRC SSH VPS - Starting..."
echo "=========================================="

# Start SSH service
service ssh start
echo "[+] SSH service started on port 22"

# Configure ngrok with token from env
if [ -n "$NGROK_AUTHTOKEN" ]; then
    echo "[+] Configuring ngrok..."
    ngrok config add-authtoken "$NGROK_AUTHTOKEN"

    # Start ngrok TCP tunnel for SSH
    echo "[+] Starting ngrok tunnel..."
    ngrok tcp 22 --region ap &

    # Wait for tunnel
    sleep 10

    # Get public URL
    TUNNEL_URL=$(curl -s http://localhost:4040/api/tunnels | grep -o 'tcp://[^"]*' | head -1)
    if [ -n "$TUNNEL_URL" ]; then
        echo ""
        echo "=========================================="
        echo "  🌐 SSH ACCESS READY"
        echo "  URL: $TUNNEL_URL"
        echo "  User: root"
        echo "  Pass: Anony#234"
        echo "=========================================="
    else
        echo "[!] ngrok tunnel not established yet"
        echo "[!] Check: curl http://localhost:4040/api/tunnels"
    fi
else
    echo "[!] NGROK_AUTHTOKEN not set!"
    echo "[!] Set it as environment variable in Railway"
fi

# Keep container running
echo ""
echo "[+] Container running - SSH active"
tail -f /dev/null
