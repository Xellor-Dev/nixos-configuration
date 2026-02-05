{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
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
      ];
    };
  };
}
