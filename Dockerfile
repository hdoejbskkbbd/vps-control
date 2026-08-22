FROM python:3.10-slim

LABEL maintainer="DRC"
LABEL description="Priya Bot v3.0 - YouTube Live Chat Commander"

# Install system deps
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    ssh \
    ffmpeg \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxkbcommon0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libatspi2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Copy requirements first (for caching)
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install playwright browsers
RUN playwright install chromium
RUN playwright install-deps chromium

# Copy bot files
COPY . .

# Create bot directory structure
RUN mkdir -p /app/priya_chrome_data /app/logs /app/outputs

# Environment
ENV PYTHONUNBUFFERED=1
ENV DISPLAY=:1
ENV YOUTUBE_VIDEO_ID=WTgdVYtWeSg
ENV CREATOR=james-2d

# Expose port (for health checks)
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start command
CMD ["python3", "bot/priya_bot_v3_all_in_one.py"]
