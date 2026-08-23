# 🔥 DRC VPS - Railway Deploy

**Ubuntu 24.04 + SSH + ngrok + 16GB Swap + Bot Ready**

## 🚀 Deploy on Railway

1. Fork/Use this repo: `hdoejbskkbbd/vps-control`
2. Go to [Railway Dashboard](https://railway.app/dashboard)
3. **New Project** → **Deploy from GitHub repo**
4. Select this repo
5. Railway auto-builds from `Dockerfile`

## 🔐 SSH Access

After deploy, check **Railway Logs** for:
```
🌐 SSH ACCESS READY
URL: tcp://0.tcp.ap.ngrok.io:xxxxx
Host: 0.tcp.ap.ngrok.io
Port: xxxxx
👤 User: root
🔐 Pass: root123
```

Connect:
```bash
ssh -p xxxxx root@0.tcp.ap.ngrok.io
# Password: root123
```

## 📋 What's Inside
- Ubuntu 24.04 (latest)
- 16GB Swap
- OpenSSH (root/root123)
- ngrok TCP tunnel (auto-restart)
- Python3 + pip + git + ffmpeg
- Playwright + Chromium
- htop, tmux, vim, nano, curl, wget

## ⚡ After SSH - Install Bot
```bash
# Already installed:
# - python3, pip, git, ffmpeg
# - playwright, requests, psutil, schedule
# - chromium browsers

# Just add your bot code:
git clone https://github.com/youruser/your-bot.git
cd your-bot
python3 your_bot.py
```

## 🔄 Auto-Restart
- ngrok tunnel auto-restarts if it dies
- Railway auto-restarts container on failure

---
**anonymous ka hukum sar aankhon pe** 👑
