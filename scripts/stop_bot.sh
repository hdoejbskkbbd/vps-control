#!/bin/bash
# DRC - Stop Priya Bot
pkill -f 'priya_bot_v3' 2>/dev/null
pkill -f 'playwright/driver' 2>/dev/null
sleep 1
echo "[+] Priya Bot stopped"
