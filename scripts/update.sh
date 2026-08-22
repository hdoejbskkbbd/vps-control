#!/bin/bash
# DRC - Update Bot from Repo
cd /opt/priya
git pull origin main
source venv/bin/activate
pip install -r requirements.txt 2>/dev/null
bash scripts/restart_bot.sh
echo "[+] Update complete"
