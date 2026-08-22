#!/bin/bash
# DRC - Start Priya Bot
cd /opt/priya
source venv/bin/activate

# Kill existing
pkill -f 'priya_bot_v3' 2>/dev/null
sleep 2

# Start fresh
nohup python3 priya_bot_v3_all_in_one.py > bot_run.log 2>&1 &
echo "[+] Priya Bot started - PID: $!"
echo "[+] Logs: tail -f /opt/priya/bot_run.log"
