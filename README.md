# 📦 Claude in a Box

Run Claude Code CLI in an isolated Docker container.

## 📁 Project Structure

```
.
├── Makefile              # Easy commands
├── docker-compose.yml    # Container config
├── README.md
└── claude-code/
    ├── Dockerfile        # Image definition
    ├── entrypoint.sh     # Startup script
    └── settings.json     # Default settings
```

## 🚀 Quick Start

```bash
make build    # Build the image
make login    # Login to Claude (one-time)
make run      # Run Claude Code
```

## 📋 Commands

| Command | Description |
|---------|-------------|
| `make build` | Build the Docker image |
| `make run` | Run Claude Code interactively |
| `make login` | Login to Claude (one-time) |
| `make shell` | Drop into bash shell |
| `make clean` | Remove volume and credentials |

## 🔐 Authentication

**First time only:**
```bash
make login
```

Opens a URL + code. Authenticate with your Claude.ai account in the browser. Credentials persist in a Docker volume.

## 🔒 Security

- Runs as non-root `claude` user (UID 1000)
- Uses `gosu` for proper privilege dropping
- Isolated from host system
- Only mounted workspace is accessible

## ⚙️ Default Settings

Edit `claude-code/settings.json` before building:

- `DISABLE_AUTOUPDATER=1` — No auto-updates in container
- `alwaysThinkingEnabled: true` — Extended thinking enabled

## 🧹 Cleanup

Remove volume (deletes credentials):
```bash
make clean
```

## 🔑 API Key Alternative

Skip login, use API key instead:
```bash
docker compose run --rm -e ANTHROPIC_API_KEY="sk-ant-..." claude
```
