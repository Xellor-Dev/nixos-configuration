# NixOS Configuration Management with Just

set dotenv-load

# Show help
help:
    @echo "NixOS Configuration Management"
    @echo "=============================="
    @just --list

# Build configuration without switching
build:
    sudo nixos-rebuild build --flake .#nixos

# Build and apply configuration
switch: test
    sudo nixos-rebuild switch --flake .#nixos

# Test configuration (build only, no sudo)
test:
    nixos-rebuild build --flake .#nixos 2>&1 | head -50

# Update flake.lock
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

# Git: add, commit, push
push:
    git status
    git add .
    git commit -m "config: update nixos configuration" || true
    git push origin main

# Show system info
status:
    @echo "NixOS Version: {{`nixos-version`}}"
    @echo "Flake: {{`git rev-parse --short HEAD`}}"
    @echo "Generation: {{`sudo nix-env --list-generations -p /nix/var/nix/profiles/system | tail -1`}}"

# Quick rebuild: clean + build + switch
rebuild: clean build switch

# Dev workflow: test + lint + push + switch
dev: test lint push switch

# Rollback to previous generation
rollback:
    sudo nixos-rebuild switch --rollback

# List all generations
generations:
    sudo nix-env --list-generations -p /nix/var/nix/profiles/system

# Add new package to dev.nix
add-package package:
    @echo "Adding {{package}} to modules/packages/dev.nix"
    # Manually add to dev.nix and run:
    @just test

# Show flake inputs
inputs:
    nix flake show

# Interactive rebuild with confirmation
rebuild-interactive:
    @echo "Building configuration..."
    @just test
    @echo "Ready to switch? (y/n)"
    @read -r REPLY; if [ "$$REPLY" = "y" ]; then just switch; fi