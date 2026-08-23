# 🔥 DRC VPS - Railway Deploy (No ngrok needed!)

**Ubuntu 24.04 + Web Terminal + 16GB Swap + Bot Ready**

## 🚀 Deploy on Railway

1. Fork/Use this repo: `hdoejbskkbbd/vps-control`
2. Go to [Railway Dashboard](https://railway.app/dashboard)
3. **New Project** → **Deploy from GitHub repo**
4. Select this repo
5. Railway auto-builds from `Dockerfile`

## 🌐 Access Your VPS

After deploy, Railway gives you a **public domain** automatically:
```
https://your-project-name.up.railway.app
```

This opens a **web terminal** — direct browser access!

### Login:
- **Username:** `root`
- **Password:** `root123`

## 📋 What's Inside
- Ubuntu 24.04 (latest)
- 16GB Swap
- Web-based terminal (ttyd) — no SSH client needed!
- Python3 + pip + git + ffmpeg
- Playwright + Chromium
- htop, tmux, vim, nano, curl, wget

## ⚡ After Login - Install Bot
```bash
# Check resources
free -h

# Bot dependencies already installed:
# python3, pip, git, ffmpeg, playwright, chromium

# Just add your bot code:
git clone https://github.com/youruser/your-bot.git
cd your-bot
python3 your_bot.py
```

## 🔄 Auto-Restart
- Railway auto-restarts container on failure
- Web terminal auto-starts

---
**anonymous ka hukum sar aankhon pe** 👑
