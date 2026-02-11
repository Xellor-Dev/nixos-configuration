# NixOS Configuration Management with Just
# Docs: https://github.com/casey/just

set dotenv-load := true
set shell := ["bash", "-uc"]

# Default recipe (runs when you type 'just')
default:
    @just --choose

# Show help with descriptions
help:
    @echo "╔════════════════════════════════════════╗"
    @echo "║  NixOS Configuration Management        ║"
    @echo "╚════════════════════════════════════════╝"
    @echo ""
    @just --list --unsorted
    @echo ""
    @echo "💡 Tip: Run 'just' to select command interactively"

# 🔨 Build configuration without switching (safe test)
test:
    @just check
    @echo "🔨 Building NixOS configuration..."
    @nh os build .
    @echo "✅ Build successful! Use 'just switch' to apply."

# 🚀 Build and apply configuration (with confirmation)
switch:
    @echo "🔍 Testing configuration first..."
    @just test
    @echo ""
    @echo "🚀 Ready to switch NixOS configuration."
    @nh os switch . -v
    @echo "✅ System switched successfully!"

# 📦 Update flake.lock and show changes
update:
    @echo "📦 Updating flake inputs..."
    @nix flake update
    @echo ""
    @echo "📊 Changes:"
    @git diff flake.lock | grep -E '^\+|^\-' | head -20
    @echo ""
    @read -p "Commit changes? [y/N]: " REPLY; \
    if [ "$${REPLY,,}" = "y" ]; then \
        git add flake.lock; \
        git commit -m "chore: update flake.lock"; \
        echo "✅ Changes committed!"; \
    fi

# 📦 Update only nixpkgs (safe, doesn't break caelestia-nix compatibility)
update-nixpkgs:
    @echo "📦 Updating only nixpkgs (keeping caelestia-nix stable)..."
    @nix flake lock --update-input nixpkgs
    @echo ""
    @echo "📊 Changes in nixpkgs:"
    @git diff flake.lock | grep -A 5 -B 5 'nixpkgs' | head -20
    @echo ""
    @just test
    @echo ""
    @read -p "Commit changes? [y/N]: " REPLY; \
    if [ "$${REPLY,,}" = "y" ]; then \
        git add flake.lock; \
        git commit -m "chore: update nixpkgs"; \
        echo "✅ Changes committed!"; \
    fi

# 🧹 Clean build artifacts
clean:
    @echo "🧹 Cleaning build artifacts..."
    @rm -f result result-*
    @git gc --quiet
    @echo "✅ Cleanup complete!"

# ✅ Check Nix syntax and flake structure
check:
    @echo "✅ Checking flake structure..."
    @nix flake check

# 📝 Format all Nix files (requires nixpkgs-fmt)
fmt:
    @echo "📝 Formatting Nix files..."
    @find . -name "*.nix" -type f ! -path "./.git/*" ! -path "./result*" \
        -exec nixpkgs-fmt {} + && \
    echo "✅ Formatting complete!"

# 📊 Show detailed system info
status:
    @echo "╔════════════════════════════════════════╗"
    @echo "║  System Status                         ║"
    @echo "╚════════════════════════════════════════╝"
    @echo ""
    @echo "🖥️  NixOS:      {{`nixos-version`}}"
    @echo "🔗 Flake:      {{`git rev-parse --short HEAD`}} ({{`git branch --show-current`}})"
    @echo "📦 Generation: {{`sudo nix-env --list-generations -p /nix/var/nix/profiles/system | tail -1 | awk '{print $1}'`}}"
    @echo "💾 Store:      {{`du -sh /nix/store 2>/dev/null | awk '{print $1}'`}}"
    @echo ""
    @echo "📝 Uncommitted changes:"
    @git status --short || echo "  (none)"

# 📜 List all system generations
generations:
    @echo "📜 System generations:"
    @nh os info

# 🔍 Show flake inputs and outputs
info:
    @echo "🔍 Flake information:"
    @nix flake show
    @echo ""
    @echo "📦 Inputs:"
    @nix flake metadata

# 🔧 Diff current vs new configuration
diff:
    @echo "🔧 Configuration diff:"
    @nh os build .
    @nix store diff-closures /run/current-system ./result
