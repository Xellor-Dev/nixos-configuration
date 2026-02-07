<div align="center">

## NixOS Configuration

*Declarative, reproducible, Hyprland-first system config built with Flakes.*

[![NixOS](https://img.shields.io/badge/NixOS-unstable-5277C3?style=for-the-badge&logo=nixos&logoColor=white)](https://nixos.org)
[![Built with Flakes](https://img.shields.io/badge/Built_with-Flakes-blue?style=for-the-badge&logo=nixos)](https://nixos.wiki/wiki/Flakes)

This repo defines my full NixOS system with a Hyprland desktop, managed via
Home Manager and the Caelestia dots module.

[Quick Start](#quick-start) • [Structure](#structure) • [Workflow](#workflow) • [Troubleshooting](#troubleshooting)

---</div>

## Structure

```
.
├── flake.nix                    # Flake entry point and module wiring
├── hardware-configuration.nix   # Hardware-specific settings (do not edit manually)
├── home.nix                     # Home Manager config (Caelestia dots overrides)
├── justfile                     # Convenience tasks
├── modules/
│   ├── core/                    # System core settings (boot, users, system, graphics)
│   ├── desktop/                 # Display manager (SDDM)
│   ├── packages/                # System packages (dev, gaming, system)
│   └── services/                # Networking, audio
└── caelestia-nixos/             # Local clone of Caelestia module (ignored by git)
```

## Features

### Desktop
- **Hyprland** (Wayland compositor)
- **Caelestia shell + CLI** (AGS-based shell and theming)
- **SDDM** display manager
- **PipeWire** audio stack

### Developer tooling
- **Git**, **Node.js**, **nix-output-monitor**
- Editors managed by Caelestia (VS Code/VSCodium, Zed, Micro)
- Terminal stack managed by Caelestia (Foot, Fish, Starship, eza)

### Hardware
- NVIDIA GPU support (open driver)
- Intel i5-11400F workstation

## Quick Start

### Prerequisites

- NixOS with Flakes enabled:
   - `nix.settings.experimental-features = [ "nix-command" "flakes" ];`
- Git

### Install

1. Clone and enter the repo
2. Review and adjust `home.nix` and `modules/`
3. Test and apply

Recommended commands:

- Build without switching:
   - `just test`
- Apply changes:
   - `just switch`

## Workflow

1. Edit configuration
2. Build (`just test`)
3. Apply (`just switch`)
4. Commit and push

### Update inputs

- `just update` (updates `flake.lock`)

## Troubleshooting

### Flakes: “path not tracked by git”

Flakes only see committed files. If you add a new file, commit it before rebuild:

- `git add .`
- `git commit -m "chore: track config"`

### Rollback

- `just rollback`
- or `sudo nixos-rebuild switch --rollback`

### Build only

- `just build`

## References

- [NixOS Manual](https://nixos.org/manual/nixos/unstable)
- [Home Manager](https://github.com/nix-community/home-manager)
- [Flakes](https://nixos.wiki/wiki/Flakes)

## License

MIT. See [LICENSE](LICENSE).