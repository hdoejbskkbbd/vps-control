#!/bin/bash
# DRC - Restart Priya Bot
bash $(dirname "$0")/stop_bot.sh
sleep 2
bash $(dirname "$0")/start_bot.sh
