# DRC VPS - Railway + ngrok

Exact copy of `yesf` repo workflow for Railway deploy.

## Deploy
1. Railway Dashboard → New Project → Deploy from GitHub repo
2. Select `hdoejbskkbbd/vps-control`

## SSH Access
Check Railway logs for:
```
URL: tcp://0.tcp.ap.ngrok.io:xxxxx
Host: 0.tcp.ap.ngrok.io
Port: xxxxx
Username: root
Password: root123
```

Connect: `ssh -p xxxxx root@0.tcp.ap.ngrok.io`

---
**anonymous ka hukum sar aankhon pe** 👑
