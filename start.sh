#!/bin/bash
# DRC VPS Startup - Railway Native

echo "=========================================="
echo "  DRC VPS - Railway Deploy"
echo "=========================================="

# Start SSH (internal only, Railway doesn't expose 22)
service ssh start
echo "[+] SSH started (internal port 22)"

# Show Railway info
echo ""
echo "[+] Railway Domain: $RAILWAY_PUBLIC_DOMAIN"
echo "[+] Railway URL: $RAILWAY_STATIC_URL"
echo ""

# Start info web server on Railway's PORT
python3 /info_server.py &
echo "[+] Info server started on port ${PORT:-8080}"

echo ""
echo "=========================================="
echo "  🌐 Access your VPS:"
echo "  https://$RAILWAY_PUBLIC_DOMAIN"
echo "=========================================="
echo ""
echo "[+] For SSH, use Railway CLI:"
echo "    railway login && railway ssh"
echo ""

# Keep running
tail -f /dev/null
