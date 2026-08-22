#!/bin/bash
# DRC - GitHub Self-Hosted Runner Setup for Railway VPS
# Run this ONCE on your VPS to connect it to GitHub Actions

REPO_URL="https://github.com/hdoejbskkbbd/vps-control"
TOKEN="${1:-YOUR_RUNNER_TOKEN_HERE}"
RUNNER_NAME="drc-vps-$(hostname)"

echo "=========================================="
echo "  DRC Self-Hosted Runner Setup"
echo "=========================================="

# Create runner directory
mkdir -p ~/actions-runner && cd ~/actions-runner

# Download latest runner (Linux x64)
echo "[1/5] Downloading runner..."
curl -o actions-runner-linux-x64-2.319.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.319.1/actions-runner-linux-x64-2.319.1.tar.gz

# Extract
echo "[2/5] Extracting..."
tar xzf ./actions-runner-linux-x64-2.319.1.tar.gz

# Configure
echo "[3/5] Configuring runner..."
./config.sh --url $REPO_URL --token $TOKEN --name $RUNNER_NAME --work _work --labels self-hosted,linux,x64,drc --unattended

# Install as service
echo "[4/5] Installing service..."
sudo ./svc.sh install
sudo ./svc.sh start

# Verify
echo "[5/5] Verifying..."
sudo ./svc.sh status

echo ""
echo "=========================================="
echo "  ✅ Runner installed: $RUNNER_NAME"
echo "  Check GitHub: Settings > Actions > Runners"
echo "=========================================="
