FROM ghcr.io/actions/actions-runner:2.322.0

# Switch to root user
USER root

# Setup Docker repo
RUN apt update -y \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
    && chmod a+r /etc/apt/keyrings/docker.asc \
    && echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update -y

# Install essential packages, including Docker Compose, fuser (psmisc), and Cypress dependencies
RUN apt update -y \
    && apt install -y --no-install-recommends \
        lsb-release gpg-agent software-properties-common curl jq unzip file \
        psmisc \
        libnss3-tools \
        docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
        libgtk2.0-0 libgtk-3-0 libnotify-dev libgconf-2-4 libgbm-dev libnss3 libxss1 libasound2 libxtst6 tidy xauth xvfb \
    && rm -rf /var/lib/apt/lists/*

RUN apt update -y \
    && apt install -y debian-keyring debian-archive-keyring apt-transport-https curl \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg \
    && curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list \
    && apt update -u \
    && apt install caddy

RUN usermod -aG docker runner

# Switch back to the runner user
USER runner
