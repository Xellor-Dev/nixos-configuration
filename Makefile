.PHONY: help build switch update clean test fmt lint push

help:
    @echo "NixOS Configuration Management"
    @echo "=============================="
    @echo "make build       - Build configuration without switching"
    @echo "make switch      - Build and apply configuration"
    @echo "make update      - Update flake.lock"
    @echo "make test        - Test configuration (build only)"
    @echo "make clean       - Clean build artifacts"
    @echo "make lint        - Check Nix syntax"
    @echo "make fmt         - Format Nix files"
    @echo "make push        - Git commit and push"
    @echo "make status      - Show system status"

# Build configuration without applying
build:
    sudo nixos-rebuild build --flake .#nixos

# Build and apply configuration
switch: test
    sudo nixos-rebuild switch --flake .#nixos

# Just build (no sudo)
test:
    nixos-rebuild build --flake .#nixos 2>&1 | head -50

# Update nixpkgs version
update:
    nix flake update
    git add flake.lock
    git commit -m "chore: update flake.lock"

# Clean build artifacts
clean:
    rm -f result result-*
    git gc

# Check Nix syntax
lint:
    nix flake check

# Format Nix files (requires nixpkgs-fmt)
fmt:
    find . -name "*.nix" -type f ! -path "./.git/*" ! -path "./result*" \
        -exec nixpkgs-fmt {} +

# Git operations
push:
    git status
    git add .
    git commit -m "config: update nixos configuration" || true
    git push origin main

# Show current system info
status:
    @echo "NixOS Version: $$(nixos-version)"
    @echo "Flake: $$(git rev-parse --short HEAD)"
    @echo "Generation: $$(sudo nix-env --list-generations -p /nix/var/nix/profiles/system | tail -1)"

# Quick rebuild (build + switch)
rebuild: clean build switch

# Dev workflow: test, lint, commit, rebuild
dev: test lint push switch

# Rollback to previous generation
rollback:
    sudo nixos-rebuild switch --rollback

# List generations
generations:
    sudo nix-env --list-generations -p /nix/var/nix/profiles/system