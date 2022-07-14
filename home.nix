{config, pkgs, ...}:
with import <nixpkgs> {};
with builtins;
let
  ownpkg = import ./personal-packages.nix{inherit config pkgs;};
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "junikim";
  home.homeDirectory = "/home/junikim";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.starship.enable = true;

  home.packages = with pkgs; [
    xclip neofetch pfetch tmux 
    file tree cmatrix
    fff fzf
    python3Full
    shellcheck dash
    wget brave
    bspwm sxhkd polybarFull nitrogen dmenu rofi picom-next eww kitty
    nfs-utils gcc gnumake pulsemixer
    ncmpcpp
    ranger ueberzug sxiv poppler_utils
    zathura mupdf
    libsecret
    # schoolwork dependencies
    pandoc
    ownpkg.tex ownpkg.mt ownpkg.mktex ownpkg.texbld
    zip unzip
    termdown bc

    libreoffice-fresh
    transmission-gtk
    
    # yt-dl
    #youtube-dl
    yt-dlp
    ffmpeg
    parallel

    imagemagick
    gimp

    # meetings
    signal-desktop skypeforlinux zoom-us discord

    # web dev
    nodejs-16_x yarn hugo

    #geogebra
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      #neovim-sensible
      vim-airline
      vim-airline-themes
      vimtex
      vim-nix
      nerdtree
      barbar-nvim
      nvim-web-devicons
      nvim-treesitter
      vim-toml
      ownpkg.autoclose
      emmet-vim
      #gruvbox

      # Coc Plugins
      coc-json
      coc-diagnostic
      coc-prettier
      coc-vimtex
      coc-pyright
    ];
    extraConfig = builtins.readFile ./dotfiles/init.vim;
  };

  programs.vscode = {
    enable = true;
    #package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      ms-python.python ms-python.vscode-pylance
      ms-vscode-remote.remote-ssh
      vscodevim.vim
      esbenp.prettier-vscode
      file-icons.file-icons
    ];
  };

  programs.git = {
    enable = true;
    userName = "Juni Kim";
    userEmail = "junikimm717@gmail.com";
    extraConfig = {
      credential.helper = "store";
    };
  };

  #programs.command-not-found.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
      ];
    };
    shellAliases = {
      "gac" = "git add . && git commit";
      "v" = "nvim";
      "c" = "clear";
      "s" = "ls";
      "e" = "exit";
      "sy" = "systemctl";
      "cp" = "cp -r";
      "vz" = "nvim ~/.config/nixpkgs/dotfiles/zshrc";
      "vc" = "nvim ~/.config/nixpkgs/dotfiles/init.vim";
      "vk" = "nvim ~/.config/nixpkgs/dotfiles/kitty.conf";
      "vs" = "nvim ~/.config/nixpkgs/dotfiles/bspwm/sxhkdrc";
      "vb" = "nvim ~/.config/nixpkgs/dotfiles/bspwm/bspwmrc";
      "sz" = "source ~/.config/nixpkgs/dotfiles/zshrc";
      "vh" = "nvim ~/.config/nixpkgs/home.nix";
      "hs" = "home-manager switch";
      "mp" = "ncmpcpp";
      "dots" = "cd ~/.config/nixpkgs/dotfiles";
      "open" = "rifle";
      "o" = "rifle";
      "z" = "rifle";
      "timer" = "termdown";
    };
    initExtra = builtins.readFile ./dotfiles/zshrc;
    enableSyntaxHighlighting = true;
  };

  services.syncthing.enable = true;

  home.file = {
    # shell-related
    ".tmux.conf".source = ./dotfiles/tmux.conf;
    ".bashrc".source = ./dotfiles/bashrc;
    ".config/nixpkgs/config.nix".source = ./dotfiles/config.nix;

    # rice configuration
    ".xinitrc".source = ./dotfiles/bspwm/xinitrc;
    ".config/bspwm/bspwmrc".source = ./dotfiles/bspwm/bspwmrc;
    ".config/bspwm/kill.sh".source = ./dotfiles/bspwm/kill.sh;
    ".config/sxhkd/sxhkdrc".source = ./dotfiles/bspwm/sxhkdrc;
    ".config/polybar" = {source = ./dotfiles/bspwm/polybar; recursive = true;};
    ".config/picom/picom.conf".source = ./dotfiles/picom.conf;

    # application configuration
    ".config/kitty/kitty.conf".source = ./dotfiles/kitty.conf;
    ".config/ranger" = {source = ./dotfiles/ranger; recursive = true;};
    ".config/rofi" = {source = ./dotfiles/rofi; recursive = true;};
    ".config/eww" = {source = ./dotfiles/eww; recursive = true;};
    "bin" = {source = ./bin; recursive = true;};
    "wallpaper" = {source = ./dotfiles/wallpaper; recursive = true;};

    # music
    ".config/nvim/coc-settings.json".source = ./dotfiles/coc-settings.json;
    ".config/ncmpcpp/config".source = ./dotfiles/ncmpcpp.conf;
    ".local/share/applications/ncmpcpp.desktop".source = ./dotfiles/ncmpcpp.desktop;
  };
}
