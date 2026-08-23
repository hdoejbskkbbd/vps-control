# 🔥 DRC SSH VPS - Railway Deploy

**Purpose:** SSH access to Railway VPS via ngrok tunnel

## 🚀 Deploy on Railway

1. **Fork/Use this repo** on GitHub
2. **Connect to Railway:**
   - Go to [Railway Dashboard](https://railway.app/dashboard)
   - New Project → Deploy from GitHub repo
   - Select this repo
3. **Add Environment Variable:**
   - `NGROK_AUTHTOKEN` = Your ngrok authtoken
4. **Deploy!** Railway builds from Dockerfile

## 🔐 SSH Access

After deploy, check Railway logs for:
```
🌐 SSH ACCESS READY
URL: tcp://0.tcp.ap.ngrok.io:xxxxx
User: root
Pass: Anony#234
```

Connect:
```bash
ssh -p xxxxx root@0.tcp.ap.ngrok.io
# Password: Anony#234
```

## 📋 What's Inside

- Ubuntu 22.04 base
- OpenSSH server (root/Anony#234)
- ngrok TCP tunnel (auto-starts)
- Basic tools: curl, wget, vim, htop, tmux

## ⚡ Next Steps

Once SSH is ready, you can:
```bash
# Install anything you need
apt update && apt install -y python3 python3-pip

# Setup your bot manually
# Or clone your bot repo
git clone https://github.com/youruser/your-bot.git
```

---
**anonymous ka hukum sar aankhon pe** 👑
