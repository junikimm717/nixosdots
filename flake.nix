{
  description = "Juni's Nix Flake dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager";
    texbld.url = "github:texbld/texbld/release-0.3";
    system76-keyboard-configurator.url =
      "github:junikimm717/system76-keyboard-configurator";
  };

  outputs = { self, nixpkgs, home-manager, texbld
    , system76-keyboard-configurator, ... }:
    let
      commonModules = [
        home-manager.nixosModule
        ./config/audio.nix
        ./config/common.nix
        ./config/dev.nix
        ./config/home.nix
        ({ config, ... }: {
          environment.systemPackages = [
            texbld.defaultPackage.x86_64-linux
            system76-keyboard-configurator.defaultPackage.x86_64-linux
          ];
        })
      ];
    in {
      nixosConfigurations.nixos-lemp = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = commonModules ++ [ ./systems/lemp.nix ./envs/bspwm.nix ];
      };
      formatter.x86_64-linux = nixpkgs.legacyPackages."x86_64-linux".nixfmt;
    };
}
