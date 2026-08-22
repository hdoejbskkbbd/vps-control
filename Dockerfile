FROM python:3.10-slim

LABEL maintainer="DRC"
LABEL description="Priya Bot v3.0 - YouTube Live Chat Commander"

# Install system deps
RUN apt-get update && apt-get install -y \
    curl wget git ssh ffmpeg \
    libglib2.0-0 libnss3 libnspr4 \
    libatk1.0-0 libatk-bridge2.0-0 \
    libcups2 libdrm2 libdbus-1-3 \
    libxkbcommon0 libxcomposite1 \
    libxdamage1 libxfixes3 libxrandr2 \
    libgbm1 libpango-1.0-0 libcairo2 \
    libasound2 libatspi2.0-0 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy and install Python deps
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright browsers
RUN playwright install chromium
RUN playwright install-deps chromium

# Copy bot code
COPY bot/ ./bot/
COPY config/bot.env ./config/

# Create data dirs
RUN mkdir -p /app/priya_chrome_data /app/logs /app/outputs

ENV PYTHONUNBUFFERED=1
ENV DISPLAY=:1

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD python3 -c "import urllib.request; urllib.request.urlopen('http://localhost:8080/health')" || exit 1

CMD ["python3", "bot/priya_bot_v3_all_in_one.py"]
