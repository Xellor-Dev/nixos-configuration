{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Caelestia — single input that includes caelestia-shell internally.
    # 'follows' ensures all dependencies use the same nixpkgs version.
    caelestia-nix = {
      url = "github:Xellor-Dev/caelestia-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.caelestia-shell.inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hardware-configuration.nix
        home-manager.nixosModules.home-manager
        ({ pkgs, inputs, ... }: {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.xellor = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
          # Caelestia HM module is activated via imports in home.nix
        })
        # System modules
        ./modules/core/boot.nix
        ./modules/core/system.nix
        ./modules/core/users.nix
        ./modules/core/graphics.nix
        # ./modules/desktop/plasma.nix  # Disabled — using Hyprland instead
        ./modules/desktop/sddm.nix
        ./modules/services/networking.nix
        ./modules/services/sound.nix
        ./modules/packages/dev.nix
        ./modules/packages/system.nix
        ./modules/packages/gaming.nix
      ];
    };
  };
}
