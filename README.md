# NixOS Configuration

Personal NixOS setup with Hyprland desktop, managed via Flakes and Home Manager.

## Structure

```
├── flake.nix              # Flake entry point
├── home.nix               # Home Manager configuration
├── hardware-configuration.nix
├── justfile               # Task automation
└── modules/
    ├── core/              # boot, system, users, graphics
    ├── desktop/           # sddm
    ├── packages/          # dev, gaming, system
    └── services/          # networking, sound
```

## Features

- **Hyprland** with [caelestia-nixos](https://github.com/Xellor-Dev/caelestia-nixos) module
- **NVIDIA** open driver (RTX 3060 Ti)
- **PipeWire** audio stack
- **Gaming** setup (Steam, GameMode, MangoHud)
- **Terminal** stack: Foot, Fish, Starship

## Hardware

| Component | Model |
|-----------|-------|
| CPU | Intel i5-11400F |
| GPU | NVIDIA RTX 3060 Ti |
| OS | NixOS unstable |

## Usage

```bash
just test      # Build without applying
just switch    # Build and apply
just update    # Update flake inputs
just clean     # Remove build artifacts
just status    # Show system info
just fmt       # Format nix files
```

## Quick Start

```bash
# Clone
git clone https://github.com/Xellor-Dev/nixos-config
cd nixos-config

# Review and adjust home.nix and modules/

# Test build
just test

# Apply
just switch
```

## Troubleshooting

**"path not tracked by git"** — Commit new files before rebuild:
```bash
git add . && git commit -m "add files"
```

**Rollback** — Revert to previous generation:
```bash
just rollback
# or: sudo nixos-rebuild switch --rollback
```

## License

MIT