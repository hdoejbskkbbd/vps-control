# 🔥 DRC VPS CONTROL CENTER

**Owner:** anonymous | **Bot:** Priya v3.0 | **Status:** LIVE

## 📡 Quick Access

| Service | Command |
|---------|---------|
| Restart Bot | `bash scripts/restart_bot.sh` |
| Check Logs | `bash scripts/logs.sh` |
| Send Message | `python3 scripts/send_msg.py "your message"` |
| Update Bot | `bash scripts/update.sh` |

## 🚀 GitHub Actions Workflows

Trigger from GitHub UI or API:

| Workflow | Purpose | Trigger |
|----------|---------|---------|
| `bot-deploy.yml` | Auto-deploy bot on push | Push to main |
| `vps-health.yml` | VPS health checks | Every 5 min / Manual |
| `send-message.yml` | Send message to live chat | Manual |
| `bot-logs.yml` | Fetch bot logs | Manual |
| `bot-command.yml` | Execute any VPS command | Manual |
| `ngrok-start.yml` | Start ngrok SSH tunnel | Manual |

## 🔐 Required Secrets (GitHub Settings)

Add these in **Settings > Secrets and variables > Actions**:

| Secret | Value |
|--------|-------|
| `VPS_HOST` | Your VPS IP or ngrok host |
| `VPS_SSH_KEY` | Private SSH key for root access |
| `NGROK_TOKEN` | Your ngrok authtoken |

## 🤖 Priya Bot Features

- ✅ YouTube Live Chat integration
- ✅ AI replies via OpenRouter/Ollama
- ✅ Auto-messages every 30s
- ✅ Moderation commands (.block, .ban, .timeout)
- ✅ Creator-only admin commands (a, t, .g, .s)
- ✅ Points system & custom commands
- ✅ Anti-spam & flood protection

## ⚡ DRC Commands

```bash
# Start bot
bash scripts/start_bot.sh

# Stop bot
bash scripts/stop_bot.sh

# View live logs
tail -f /opt/priya/bot_run.log

# Send test message
python3 scripts/send_msg.py "Hello from DRC!"

# Check VPS health
bash scripts/health.sh
```

## 📁 Repo Structure

```
vps-control/
├── .github/workflows/     # GitHub Actions
├── scripts/               # Shell/Python scripts
├── config/                # Config files
├── requirements.txt       # Python deps
└── README.md
```

---

**anonymous ka hukum sar aankhon pe** 👑

*Built by DRC for anonymous | No limits, no mercy*
