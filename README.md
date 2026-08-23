# 🔥 DRC VPS - Railway + ngrok

**Ubuntu 24.04 + SSH + ngrok TCP tunnel + 16GB Swap**

## 🚀 Deploy on Railway

1. Fork/Use: `hdoejbskkbbd/vps-control`
2. [Railway Dashboard](https://railway.app/dashboard)
3. **New Project** → **Deploy from GitHub repo**
4. Select this repo

## 🔐 SSH Access

After deploy, check **Railway Logs** for:
```
==========================================
  🌐 SSH ACCESS READY
==========================================
  URL: tcp://0.tcp.ap.ngrok.io:xxxxx
  Host: 0.tcp.ap.ngrok.io
  Port: xxxxx
  👤 User: root
  🔐 Pass: root123
==========================================
```

Connect:
```bash
ssh -p xxxxx root@0.tcp.ap.ngrok.io
# Password: root123
```

## ⚡ What's Inside
- Ubuntu 24.04
- 16GB Swap
- OpenSSH (root/root123)
- ngrok TCP tunnel (auto-restart + debug)
- Python3 + Playwright + Chromium
- htop, tmux, vim, nano

## 🔄 Auto-Restart
- ngrok auto-restarts if it dies
- Tunnel health check every 5 min
- Debug logs visible in Railway

---
**anonymous ka hukum sar aankhon pe** 👑
