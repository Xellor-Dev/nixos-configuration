{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./modules/desktop/noctalia.nix
        ./configuration.nix
        ./hardware-configuration.nix
        home-manager.nixosModules.home-manager
        ({ pkgs, inputs, ... }: {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.xellor = (import ./home.nix) { inherit pkgs inputs; };
        })
        ./modules/core/boot.nix
        ./modules/core/system.nix
        ./modules/core/users.nix
        ./modules/core/graphics.nix
        # ./modules/desktop/plasma.nix
        # ./modules/desktop/sddm.nix
        ./modules/services/networking.nix
        ./modules/services/sound.nix
        ./modules/packages/dev.nix
        ./modules/packages/system.nix
        ./modules/packages/gaming.nix
      ];
    };
  };
}
