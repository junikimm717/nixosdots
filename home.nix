{config, pkgs, ...}:
with import <nixpkgs> {};
with builtins;
let
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) scheme-medium
      collection-bibtexextra
      collection-latexextra
      collection-mathscience
      collection-pictures
      collection-formatsextra
      biblatex biblatex-mla
      pythontex pygmentex;
  });
  mt = stdenv.mkDerivation {
    name = "mt";
    src = fetchurl {
      url = "https://github.com/junikimm717/mt/releases/download/33627ab/mt";
      sha256 =
      "ec2362864527e215594b1c2279d9c50093dcaf5537a61342c2db2575406962f6";
    };
    phases = [ "installPhase" ];
    installPhase = ''
    mkdir -p $out/bin
    cp -r $src $out/bin/mt
    chmod +x $out/bin/mt
    '';
  };
  mktex = stdenv.mkDerivation {
    name = "mktex";
    src = fetchFromGitHub {
      owner = "junikimm717";
      repo = "mktex";
      rev = "29d14bf777596d62a5cae0b5e1b9aa696385a427";
      sha256 = "1ri6nw6053yipxfp6n6hin36md6dcz9yy502i2xkdsb6y7kdv6qp";
    };
    installPhase = ''
    mkdir -p $out
    cp -r $src $out/bin
    chmod +x $out/bin/mktex
    '';
  };
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
    xclip neofetch pfetch tmux file
    fff
    nodejs python3Full
    shellcheck dash
    wget brave
    bspwm sxhkd polybarFull kitty nitrogen dmenu rofi picom-next eww
    nfs-utils gcc gnumake pulsemixer
    ncmpcpp
    ranger ueberzug sxiv poppler_utils
    zathura mupdf
    libsecret
    # schoolwork dependencies
    pandoc
    tex mt mktex
    zip unzip
    fzf

    # meetings
    signal-desktop skypeforlinux zoom-us discord
  ];

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      coc-nvim
      neovim-sensible
      vim-airline
      vim-airline-themes
      vimtex
      vim-nix
      nerdtree
      barbar-nvim
      nvim-web-devicons
      vim-toml

      # Coc Plugins
      coc-json
      coc-diagnostic
      coc-prettier
    ];
    extraConfig = builtins.readFile ./dotfiles/init.vim;
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
      "sz" = "source ~/.config/nixpkgs/dotfiles/zshrc";
      "vh" = "nvim ~/.config/nixpkgs/home.nix";
      "hs" = "home-manager switch";
      "dots" = "cd ~/.config/nixpkgs/dotfiles";
    };
    initExtra = builtins.readFile ./dotfiles/zshrc;
    enableSyntaxHighlighting = true;
  };
  
  services.syncthing.enable = true;

  home.file = {
    # shell-related
    ".tmux.conf".source = ./dotfiles/tmux.conf;
    #".zshrc".source = ./dotfiles/zshrc;
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
    ".config/mktex_templates" = {source = ./mktex_templates; recursive = true;};
    "bin" = {source = ./bin; recursive = true;};
    "wallpaper" = {source = ./dotfiles/wallpaper; recursive = true;};

    # music
    ".config/nvim/coc-settings.json".source = ./dotfiles/coc-settings.json;
    ".config/ncmpcpp/config".source = ./dotfiles/ncmpcpp.conf;
    ".local/share/applications/ncmpcpp.desktop".source = ./dotfiles/ncmpcpp.desktop;
  };
}
