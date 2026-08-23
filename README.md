# 🔥 DRC SSH VPS

**One-click GitHub Actions → Ubuntu VPS with ngrok SSH tunnel**

## 🚀 How to Use

1. **Go to Actions tab** in this repo
2. Click **"DRC Root SSH VPS"** workflow
3. Click **"Run workflow"**
4. Wait 1-2 minutes
5. Check logs for SSH connection details:
```
🌐 SSH URL: tcp://0.tcp.ap.ngrok.io:xxxxx
👤 Username: root
🔐 Password: root123
```

## 🔐 Connect
```bash
ssh -p xxxxx root@0.tcp.ap.ngrok.io
# Password: root123
```

## ⚡ What's Inside
- Ubuntu latest (GitHub Actions runner)
- 16GB RAM + 16GB Swap
- Root SSH access
- ngrok TCP tunnel (auto-restart)
- Basic tools: curl, wget, htop, tmux

## ⏰ Session
- **6 hours** max (GitHub Actions limit)
- Auto-restarts if ngrok tunnel dies

---
**anonymous ka hukum sar aankhon pe** 👑
