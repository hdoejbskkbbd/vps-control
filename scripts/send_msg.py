#!/usr/bin/env python3
# DRC - Send Message to YouTube Live Chat
import sys
import time
from playwright.sync_api import sync_playwright

VIDEO_ID = "WTgdVYtWeSg"
MSG = sys.argv[1] if len(sys.argv) > 1 else "🔥 Hello from DRC!"

print(f"[+] Sending: {MSG}")

with sync_playwright() as p:
    context = p.chromium.launch_persistent_context(
        "/opt/priya/priya_chrome_data",
        headless=True,
        args=["--no-sandbox", "--disable-dev-shm-usage", "--disable-gpu"]
    )
    page = context.new_page()
    page.goto(f"https://www.youtube.com/live_chat?is_popout=1&v={VIDEO_ID}", timeout=120000)
    time.sleep(8)

    # Find input
    inp = None
    for sel in ["[contenteditable='true']", "yt-live-chat-text-input-field-renderer", "#input", "textarea"]:
        try:
            el = page.locator(sel).first
            if el.count() > 0 and el.is_visible(timeout=5000):
                inp = el
                break
        except:
            continue

    if inp:
        inp.click()
        time.sleep(0.5)
        inp.type(MSG, delay=5)
        time.sleep(0.5)

        try:
            btn = page.locator("button#send-button").first
            if btn.count() > 0 and btn.is_enabled():
                btn.click()
            else:
                inp.press("Enter")
        except:
            inp.press("Enter")

        print("[+] Message sent!")
    else:
        print("[-] Chat input not found")
        page.screenshot(path="/opt/priya/debug_send.png")

    time.sleep(3)
    context.close()
