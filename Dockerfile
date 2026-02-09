# Base image - Debian slim
FROM debian:bookworm-slim

LABEL maintainer="stripathi-infinitepi@protonmail.com"
LABEL description="Docker container for running Claude Code CLI"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    gosu \
    ripgrep \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash -u 1000 claude

# Setup directories
RUN mkdir -p /opt/claude-docker \
    && chown -R claude:claude /home/claude

# Copy files
COPY settings.json /opt/claude-docker/default-settings.json
COPY entrypoint.sh /opt/claude-docker/entrypoint.sh
RUN chmod +x /opt/claude-docker/entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/opt/claude-docker/entrypoint.sh"]
