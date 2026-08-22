# 🔥 DRC VPS CONTROL CENTER

**Owner:** anonymous | **Bot:** Priya v3.0 | **Status:** LIVE

## 🚀 Quick Start

### 1. Setup Self-Hosted Runner (ONCE)
Follow [SETUP_RUNNER.md](SETUP_RUNNER.md) to connect your VPS to GitHub Actions.

### 2. Use Workflows
After runner setup, all workflows run directly on your VPS:

| Workflow | Purpose | Trigger |
|----------|---------|---------|
| `bot-deploy.yml` | Auto-deploy bot on push | Push to main |
| `send-message.yml` | Send message to live chat | Manual |
| `vps-health.yml` | VPS health checks | Every 5 min / Manual |
| `bot-logs.yml` | Fetch bot logs | Manual |
| `bot-command.yml` | Execute any VPS command | Manual |

## 📡 Manual Commands (on VPS)

```bash
# Start bot
bash scripts/start_bot.sh

# Stop bot
bash scripts/stop_bot.sh

# Restart bot
bash scripts/restart_bot.sh

# View logs
bash scripts/logs.sh

# Send test message
python3 scripts/send_msg.py "Hello from DRC!"

# Update from repo
bash scripts/update.sh
```

## 🤖 Priya Bot Features

- ✅ YouTube Live Chat integration
- ✅ AI replies via OpenRouter/Ollama
- ✅ Auto-messages every 30s
- ✅ Moderation commands (.block, .ban, .timeout)
- ✅ Creator-only admin commands (a, t, .g, .s)
- ✅ Points system & custom commands
- ✅ Anti-spam & flood protection

## 📁 Repo Structure

```
vps-control/
├── .github/workflows/     # GitHub Actions (self-hosted runner)
├── scripts/               # Shell/Python scripts
├── config/                # Config files
├── requirements.txt       # Python deps
├── SETUP_RUNNER.md        # Runner setup guide
└── README.md
```

---

**anonymous ka hukum sar aankhon pe** 👑

*Built by DRC for anonymous | No limits, no mercy*
