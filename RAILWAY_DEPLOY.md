# 🚂 Railway Deployment Guide

## Step 1: Connect Repo to Railway
1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click **"New Project"**
3. Select **"Deploy from GitHub repo"**
4. Choose `hdoejbskkbbd/vps-control`
5. Railway will auto-detect `Dockerfile` and build

## Step 2: Add Environment Variables
In Railway project settings, add:

| Variable | Value |
|----------|-------|
| `YOUTUBE_VIDEO_ID` | `WTgdVYtWeSg` |
| `CREATOR` | `james-2d` |
| `RAILWAY_RUN_UID` | `0` (for root permissions) |

## Step 3: Deploy
1. Railway auto-builds from Dockerfile
2. Health check on port 8080
3. Bot starts automatically

## Step 4: View Logs
```bash
# Railway CLI
railway logs

# Or in Dashboard: Deployments > Logs
```

## Step 5: Send Messages
Use GitHub Actions workflow `send-message.yml` or Railway CLI:
```bash
railway run python3 bot/priya_bot_v3_all_in_one.py
```

---
**DRC Railway Deploy Ready** 🔥
