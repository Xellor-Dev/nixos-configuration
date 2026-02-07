{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Caelestia — единственный input, внутри себя тянет caelestia-shell.
    # follows гарантирует, что все используют один nixpkgs.
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
          home-manager.users.xellor = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
          # Caelestia HM-модуль активируется через imports в home.nix
        })
        # Ваши остальные модули...
        ./modules/core/boot.nix
        ./modules/core/system.nix
        ./modules/core/users.nix
        ./modules/core/graphics.nix
        # ./modules/desktop/plasma.nix  # Отключено — используем Hyprland
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
