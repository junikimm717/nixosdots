{config, pkgs, ...}:
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
    fff
    nodejs shellcheck
    dash
    wget brave
    bspwm sxhkd polybarFull kitty nitrogen dmenu rofi picom eww
    nfs-utils gcc gnumake pulsemixer
    ncmpcpp 
    ranger ueberzug sxiv poppler_utils
    zathura
    libsecret
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
      vim-nix
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

  programs.zsh = {
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
    };
    shellAliases = {
      "gac" = "git add . && git commit";
      "v" = "nvim";
      "c" = "clear";
      "s" = "ls";
      "e" = "exit";
      "sy" = "systemctl";
      "cp" = "cp -r";
      "ra" = "source ranger";
    };
  };

  home.file = {
    # shell-related
    ".tmux.conf".source = ./dotfiles/tmux.conf;
    ".zshrc".source = ./dotfiles/zshrc;
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

    # music
    ".config/mpd/mpd.conf".source = ./dotfiles/mpd.conf;
    ".config/ncmpcpp/config".source = ./dotfiles/ncmpcpp.conf;
    
  };
}
