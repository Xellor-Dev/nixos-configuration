# NixOS Configuration

Personal NixOS system configuration using **Flakes** for reproducible declarative system management on i5-11400F + RTX 3060 Ti.

## 🏗️ Architecture

```
.
├── flake.nix                    # Flakes entry point & module composition
├── configuration.nix            # Main system configuration
├── hardware-configuration.nix   # Hardware-specific settings (auto-generated)
├── justfile                     # Automation recipes (build, switch, etc.)
└── modules/
    ├── core/                    # System core settings
    │   ├── boot.nix            # systemd-boot, GRUB configuration
    │   ├── graphics.nix        # X11, NVIDIA driver
    │   ├── system.nix          # Locale, timezone, hostname
    │   └── users.nix           # User management
    ├── desktop/                 # Desktop environment
    │   ├── plasma.nix          # KDE Plasma 6
    │   └── sddm.nix            # Display manager
    ├── packages/                # Package sets
    │   ├── dev.nix             # Development tools (git, vscode, etc.)
    │   ├── gaming.nix          # Gaming stack (Steam, GameMode, etc.)
    │   └── system.nix          # System utilities
    └── services/                # System services
        ├── networking.nix      # Network config, DNS, TCP tuning
        └── sound.nix           # PipeWire audio

```

## ⚙️ Features

- **Modular Configuration**: Split into logical core, desktop, packages, and services modules
- **KDE Plasma 6**: Modern desktop with hardware acceleration (NVIDIA)
- **Network Optimization**: DNS (Cloudflare), TCP tuning, BBR congestion control, FQ queue discipline
- **Gaming**: Steam, Proton, GameMode with custom CPU/GPU settings for i5-11400F + RTX 3060 Ti
- **Development**: VS Code, Git, Node.js, nixpkgs-fmt, nix-output-monitor
- **Automation**: `justfile` recipes for build, switch, rollback, git workflow

## 🚀 Quick Start

### Prerequisites

- NixOS with Flakes enabled
- Git (for flake tracking)
- `nh` tool (optional, for faster rebuilds with polkit)

### Build & Switch

```bash
# Build configuration (safe test)
just build

# Switch to new configuration
just switch

# Quick rebuild: clean + build + switch
just rebuild

# Test configuration without applying
just test

# Rollback to previous generation
just rollback
```

## 🔧 System Information

- **OS**: NixOS 25.11
- **Hardware**: Intel i5-11400F, RTX 3060 Ti, DDR4 RAM
- **Desktop**: KDE Plasma 6
- **Bootloader**: systemd-boot
- **Audio**: PipeWire
- **Display**: NVIDIA (open driver)


## 🔄 Workflow

1. **Edit Configuration**: Modify files in `modules/`
2. **Test**: `just test` to validate syntax
3. **Build**: `just build` to build new configuration
4. **Apply**: `just switch` to build and apply

### Example: Adding a Package

```nix
# modules/packages/system.nix
environment.systemPackages = with pkgs; [
  # existing packages...
  htop
];
```

Then apply:
```bash
just switch
```

## 🛠️ Troubleshooting

### "Path not tracked by Git"
All inputs must be tracked by git:
```bash
git add .
git commit -m "description"
```

### Rollback to Previous Generation
```bash
just rollback
```

### Check Errors
```bash
just test
```

## 📚 References

- [NixOS Manual](https://nixos.org/manual/nixos/stable)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [nix-helper (nh)](https://github.com/viperML/nh)

## 📝 License

MIT