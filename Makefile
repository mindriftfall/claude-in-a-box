.PHONY: help build run login shell clean

help:
	@echo ""
	@echo "📦 Claude in a Box"
	@echo ""
	@echo "Commands:"
	@echo "  make build   Build the Docker image"
	@echo "  make run     Run Claude Code interactively"
	@echo "  make login   Login to Claude (one-time)"
	@echo "  make shell   Drop into bash shell"
	@echo "  make clean   Remove volume and credentials"
	@echo ""

build:
	docker compose build

run: build
	docker compose run --rm claude

login: build
	docker compose run --rm claude login

shell: build
	docker compose run --rm claude bash

clean:
	docker compose down -v 2>/dev/null || true
	@echo "✅ Volume removed"
