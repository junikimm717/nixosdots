{config, pkgs, ...}:
let
  ownpkg = import ./personal-packages.nix{inherit config pkgs;};
in
{
  environment.systemPackages = with pkgs; [
    bspwm sxhkd polybarFull nitrogen dmenu rofi picom-next eww
  ];

  services.xserver.displayManager.startx.enable = true;
  services.physlock = {
    enable = true;
    lockMessage = "computer locked";
    allowAnyUser = true;
    lockOn = {
      suspend = true;
      hibernate = true;
    };
  };

  home-manager.users.junikim = {
    home.file = {
      # rice configuration
      ".xinitrc".source = ../dotfiles/bspwm/xinitrc;
      ".config/bspwm/bspwmrc".source = ../dotfiles/bspwm/bspwmrc;
      ".config/bspwm/kill.sh".source = ../dotfiles/bspwm/kill.sh;
      ".config/sxhkd/sxhkdrc".source = ../dotfiles/bspwm/sxhkdrc;
      ".config/polybar" = {source = ../dotfiles/bspwm/polybar; recursive = true;};
      ".config/picom/picom.conf".source = ../dotfiles/picom.conf;

      # application configuration
      ".config/rofi" = {source = ../dotfiles/rofi; recursive = true;};
      ".config/eww" = {source = ../dotfiles/eww; recursive = true;};
    };
  };
}
