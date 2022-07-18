{ config, pkgs, ... }:
let
  ownpkg = import ./personal-packages.nix {inherit config pkgs;};
in
{
  home-manager.useGlobalPkgs = true;

  users.users.junikim = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "input" "docker" "libvirtd" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    xclip
    neofetch pfetch tmux 
    file tree
    fff fzf
    wget brave
    nfs-utils pulsemixer
    ranger ueberzug sxiv poppler_utils
    zathura mupdf
    libsecret
    # schoolwork dependencies
    pandoc
    ownpkg.tex ownpkg.mt
    zip unzip
    termdown bc

    libreoffice-fresh
    transmission-gtk
    
    yt-dlp
    ffmpeg
    parallel

    imagemagick

    # meetings
    signal-desktop skypeforlinux zoom-us discord
  ];

  home-manager.users.junikim = {

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "junikim";
    home.homeDirectory = "/home/junikim";
    home.stateVersion = "22.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    services.syncthing.enable = true;

    home.file = {
      # shell-related
      ".tmux.conf".source = ../dotfiles/tmux.conf;
      ".bashrc".source = ../dotfiles/bashrc;
      ".zshrc".source = ../dotfiles/home_zshrc;

      # application configuration
      ".config/kitty/kitty.conf".source = ../dotfiles/kitty.conf;
      ".config/ranger" = {source = ../dotfiles/ranger; recursive = true;};
      "bin" = {source = ../bin; recursive = true;};
      "wallpaper" = {source = ../dotfiles/wallpaper; recursive = true;};

      # music
      ".config/nvim/coc-settings.json".source = ../dotfiles/coc-settings.json;
      ".config/ncmpcpp/config".source = ../dotfiles/ncmpcpp.conf;
      ".local/share/applications/ncmpcpp.desktop".source = ../dotfiles/ncmpcpp.desktop;
    };
  };
}
