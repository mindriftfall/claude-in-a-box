#!/bin/bash
#
# Entrypoint script for Claude Code Docker container
#
# Why this script exists:
# -----------------------
# 1. Docker volumes may have wrong file ownership when mounted
# 2. We need root privileges to fix ownership (chown)
# 3. But running Claude as root is a security risk
# 4. Solution: Start as root, fix permissions, then drop to non-root user
#
# Why gosu?
# ---------
# gosu is like 'su' or 'sudo' but designed for Docker:
# - Properly forwards signals (SIGTERM, etc.) to the process
# - Doesn't create extra subprocess layers
# - No TTY issues like 'su' can have
# - Process runs directly, not as child of su/sudo
#
# Flow:
# -----
# 1. Container starts as ROOT
# 2. Fix ownership of /home/claude (mounted volume)
# 3. Install Claude Code if not present (first run)
# 4. Copy default settings.json if not present
# 5. Use gosu to DROP privileges to 'claude' user
# 6. Execute claude command as non-root user
#

set -e

USER=claude
HOME_DIR=/home/$USER
CLAUDE_BIN="$HOME_DIR/.local/bin/claude"

# Fix ownership of mounted volumes (runs as root)
chown -R "$USER:$USER" "$HOME_DIR" 2>/dev/null || true

# Install Claude if not present (first run)
if [[ ! -x "$CLAUDE_BIN" ]]; then
    echo "Installing Claude Code..."
    gosu "$USER" bash -c 'curl -fsSL https://claude.ai/install.sh | bash'
fi

# Copy default settings if not present
if [[ ! -f "$HOME_DIR/.claude/settings.json" ]]; then
    mkdir -p "$HOME_DIR/.claude"
    cp /opt/claude-docker/default-settings.json "$HOME_DIR/.claude/settings.json"
    chown -R "$USER:$USER" "$HOME_DIR/.claude"
fi

# Set PATH for gosu execution
export PATH="$HOME_DIR/.local/bin:$PATH"

# Run as claude user (drop privileges via gosu)
if [[ "$1" == "bash" ]] || [[ "$1" == "sh" ]]; then
    exec gosu "$USER" "$@"
else
    exec gosu "$USER" claude "$@"
fi
