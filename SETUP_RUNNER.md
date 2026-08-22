# 🔧 Self-Hosted Runner Setup Guide

## What is this?
Self-hosted runner = Your VPS directly connected to GitHub Actions. No SSH keys, no ngrok, no VPS_HOST needed!

## Setup Steps (Run ONCE on VPS)

### 1. Get Runner Token from GitHub
- Go to: `https://github.com/hdoejbskkbbd/vps-control/settings/actions/runners`
- Click **"New self-hosted runner"**
- Select **Linux** → **x64**
- Copy the **token** from the command shown

### 2. Run Setup Script on VPS
```bash
cd /opt/priya
git pull origin main
bash scripts/setup-runner.sh YOUR_RUNNER_TOKEN
```

### 3. Verify
- Go back to GitHub runners page
- You should see `drc-vps-<hostname>` as **Online**

## That's it! 🎉

Now all workflows will run directly on your VPS:
- ✅ `bot-deploy.yml` → Auto-restarts bot on push
- ✅ `send-message.yml` → Sends messages to live chat
- ✅ `vps-health.yml` → Monitors VPS every 5 min
- ✅ `bot-logs.yml` → Fetches logs on demand
- ✅ `bot-command.yml` → Execute any command

## Troubleshooting

### Runner not showing online?
```bash
# Check service status
sudo systemctl status actions.runner.hdoejbskkbbd-vps-control.drc-vps-$(hostname).service

# Restart runner
sudo systemctl restart actions.runner.hdoejbskkbbd-vps-control.drc-vps-$(hostname).service

# Manual run (for debugging)
cd ~/actions-runner
./run.sh
```

### Remove runner
```bash
cd ~/actions-runner
sudo ./svc.sh stop
sudo ./svc.sh uninstall
./config.sh remove --token YOUR_RUNNER_TOKEN
```

---
**DRC Setup Complete** 👑
