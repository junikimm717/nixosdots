{
  description = "Juni's Nix Flake dotfiles";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.texbld.url = "github:texbld/texbld/release-0.3";

  outputs = { self, nixpkgs, home-manager, texbld, ... }: 
  let
    commonModules = [
      home-manager.nixosModule
      ./config/audio.nix
      ./config/common.nix
      ./config/dev.nix
      ./config/home.nix
      ({config, ...}: {
        environment.systemPackages = [
          texbld.defaultPackage.x86_64-linux
        ];
      })
    ];
  in
  {
    nixosConfigurations.nixos-lemp = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = commonModules ++ [
        ./config/lemp.nix
        ./envs/gnome.nix
      ];
    };
  };
}
