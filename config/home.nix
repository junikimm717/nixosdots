{ config, pkgs, ... }:
let ownpkg = import ./personal-packages.nix { inherit config pkgs; };
in {
  home-manager.useGlobalPkgs = true;

  users.users.junikim = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "docker"
      "libvirtd"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };
  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };

  environment.systemPackages = with pkgs; [
    xclip
    neofetch
    pfetch
    file
    tree
    fff
    fzf
    wget
    brave
    firefox
    nfs-utils
    pulsemixer
    ranger
    ueberzug
    sxiv
    poppler_utils
    zathura
    mupdf
    libsecret
    flameshot
    # schoolwork dependencies
    pandoc
    ownpkg.tex
    asymptote
    zip
    unzip
    termdown
    bc
    ripgrep
    uxplay

    libreoffice-fresh
    transmission-gtk

    #geogebra

    yt-dlp
    ffmpeg
    parallel
    xfce.thunar

    imagemagick

    # meetings
    signal-desktop
    skypeforlinux
    zoom-us
    whatsapp-for-linux
    discord
    slack

    openvpn

    obs-studio
  ];

  xdg = {
    portal = {
      config.common.default = "*";
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };

  services.flatpak.enable = true;

  home-manager.users.junikim = {

    # Home Manager needs a bit of information about you and the
    # paths it should manage.
    home.username = "junikim";
    home.homeDirectory = "/home/junikim";
    home.stateVersion = "22.05";

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;

    services.syncthing.enable = true;
    services.dunst.enable = true;

    home.file = {
      # shell-related
      ".bashrc".source = ../dotfiles/bashrc;
      ".zshrc".source = ../dotfiles/home_zshrc;

      # LaTeX
      ".latexmkrc".source = ../dotfiles/latexmkrc;
      ".asy" = {
        source = ../dotfiles/asy;
        recursive = true;
      };

      # application configuration
      ".config/kitty/kitty.conf".source = ../dotfiles/kitty.conf;
      ".config/alacritty/alacritty.toml".source = ../dotfiles/alacritty.toml;
      ".config/ranger" = {
        source = ../dotfiles/ranger;
        recursive = true;
      };
      ".config/zathura/zathurarc".source = ../dotfiles/zathurarc;
      "bin" = {
        source = ../bin;
        recursive = true;
      };
      "wallpaper" = {
        source = ../dotfiles/wallpaper;
        recursive = true;
      };

      # music
      ".config/nvim/coc-settings.json".source = ../dotfiles/coc-settings.json;
      ".config/ncmpcpp/config".source = ../dotfiles/ncmpcpp.conf;
      ".local/share/applications/ncmpcpp.desktop".source =
        ../dotfiles/ncmpcpp.desktop;
    };
  };
}
