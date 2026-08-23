# 🔥 DRC VPS - Railway Deploy

## 🚀 Deploy

1. **Fork/Use this repo**
2. [Railway Dashboard](https://railway.app/dashboard) → New Project → Deploy from GitHub repo
3. Select `hdoejbskkbbd/vps-control`
4. Railway auto-builds from Dockerfile

## 🔐 SSH Access (2 Methods)

### Method 1: Railway CLI (Recommended)
```bash
# Install Railway CLI
npm install -g @railway/cli

# Login and connect
railway login
railway link

# SSH into your VPS
railway ssh
# Then: su root (password: Anony#234)
```

### Method 2: Railway Dashboard
1. Go to your project in Railway Dashboard
2. Click on the service → "Shell" tab
3. Direct terminal access!

## 🌐 Web Info

After deploy, visit:
```
https://your-project.railway.app
```
Shows connection info.

## 📋 What's Inside

- Ubuntu 22.04
- OpenSSH (internal)
- Python3, pip, git
- curl, wget, vim, htop, tmux

## ⚡ Install Bot After SSH

Once inside:
```bash
apt update
pip3 install playwright requests psutil schedule
playwright install chromium
# Then add your bot code
```

---
**anonymous ka hukum sar aankhon pe** 👑
