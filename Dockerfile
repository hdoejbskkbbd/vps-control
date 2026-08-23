FROM ubuntu:22.04

# Install SSH and ngrok dependencies
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    wget \
    net-tools \
    vim \
    nano \
    htop \
    tmux \
    && rm -rf /var/lib/apt/lists/*

# Setup SSH
RUN mkdir /var/run/sshd
RUN echo 'root:Anony#234' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config

# Install ngrok
RUN curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
    && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | tee /etc/apt/sources.list.d/ngrok.list \
    && apt-get update \
    && apt-get install -y ngrok \
    && rm -rf /var/lib/apt/lists/*

# ngrok authtoken (will be set via env var)
# RUN ngrok config add-authtoken $NGROK_AUTHTOKEN

# Expose SSH port
EXPOSE 22

# Start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]
