# Justfile for NixOS Configuration Management

help:
    echo "NixOS Configuration Management"
    echo "=============================="
    echo "just build       - Build configuration without switching"
    echo "just switch      - Build and apply configuration"
    echo "just update      - Update flake.lock"
    echo "just test        - Test configuration (build only)"
    echo "just clean       - Clean build artifacts"
    echo "just lint        - Check Nix syntax"
    echo "just fmt         - Format Nix files"
    echo "just push        - Git commit and push"
    echo "just status      - Show system status"

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
    echo "NixOS Version: $$(nixos-version)"
    echo "Flake: $$(git rev-parse --short HEAD)"
    echo "Generation: $$(sudo nix-env --list-generations -p /nix/var/nix/profiles/system | tail -1)"

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