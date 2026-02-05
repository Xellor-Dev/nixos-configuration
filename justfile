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
    @echo "🔨 Testing NixOS configuration build..."
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

# 🔄 Quick rebuild: clean + build + switch
rebuild: clean
    @just build
    @just switch

# 🚀 Full dev workflow: test + check + commit + switch
dev:
    @echo "🚀 Starting development workflow..."
    @just test
    @just check
    @just push
    @just switch

# ⏮️  Rollback to previous generation
rollback:
    @echo "⏮️  Rolling back to previous generation..."
    @nh os info | tail -5
    @echo ""
    @read -p "Confirm rollback? [y/N]: " REPLY; \
    if [ "$${REPLY,,}" = "y" ]; then \
        nh os rollback && \
        echo "✅ Rolled back successfully!"; \
    else \
        echo "❌ Cancelled."; \
    fi

# 📜 List all system generations
generations:
    @echo "📜 System generations:"
    @nh os info

# 🗑️  Delete old generations (keep last N)
gc keep="5":
    @echo "🗑️  Deleting old generations (keeping last {{keep}})..."
    @sudo nix-env --delete-generations +{{keep}} -p /nix/var/nix/profiles/system
    @sudo nix-collect-garbage
    @echo "✅ Garbage collection complete!"

# 🔍 Show flake inputs and outputs
info:
    @echo "🔍 Flake information:"
    @nix flake show
    @echo ""
    @echo "📦 Inputs:"
    @nix flake metadata

# 🔎 Search for package in nixpkgs
search query:
    @echo "🔎 Searching for '{{query}}'..."
    @nix search nixpkgs {{query}}

# 📝 Edit module interactively
edit:
    @echo "📝 Select module to edit:"
    @MODULE=$(find modules -name "*.nix" -type f | fzf --preview 'bat --color=always {}'); \
    if [ -n "$$MODULE" ]; then \
        ${EDITOR:-code} "$$MODULE"; \
    fi

# 🔧 Diff current vs new configuration
diff:
    @echo "🔧 Configuration diff:"
    @nh os build .
    @nix store diff-closures /run/current-system ./result

# 🎬 Build with detailed output 
build-verbose:
    @echo "🔨 Building with verbose output..."
    @nh os build . -- --show-trace -v
