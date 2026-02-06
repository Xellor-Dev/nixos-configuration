{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./noctalia.nix
        ./configuration.nix
        ./hardware-configuration.nix
        ./modules/core/boot.nix
        ./modules/core/system.nix
        ./modules/core/users.nix
        ./modules/core/graphics.nix
        ./modules/desktop/plasma.nix
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
