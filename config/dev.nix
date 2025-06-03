{ config, pkgs, ... }:
let
  ownpkg = import ./personal-packages.nix { inherit config pkgs; };
  customPython =
    pkgs.python3.withPackages (ps: with ps; [ requests numpy toml pytest ]);
  yuck-vim = pkgs.vimUtils.buildVimPlugin {
    name = "yuck.vim";
    src = pkgs.fetchFromGitHub {
      owner = "elkowar";
      repo = "yuck.vim";
      rev = "9b5e0370f70cc30383e1dabd6c215475915fe5c3";
      sha256 = "1mkf0vd8vvw1njlczlgai80djw1n1a7dl1k940l089d3vvqr5dhp";
    };
  };

in {
  environment.systemPackages = with pkgs; [
    customPython
    shellcheck
    clang-tools
    sublime4

    pylint
    black
  ];

  nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ];

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ../dotfiles/tmux.conf;
  };

  #programs.starship.enable = false;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    shellAliases = {
      "gac" = "git add . && git commit";
      "v" = "nvim";
      "c" = "clear";
      "s" = "ls";
      "e" = "exit";
      "sy" = "systemctl";
      "cp" = "cp -r";
      "vz" = "nvim /etc/nixos/dotfiles/zshrc";
      "vc" = "nvim /etc/nixos/dotfiles/init.vim";
      "vk" = "nvim /etc/nixos/dotfiles/kitty.conf";
      "vs" = "nvim /etc/nixos/dotfiles/bspwm/sxhkdrc";
      "vb" = "nvim /etc/nixos/dotfiles/bspwm/bspwmrc";
      "sz" = "source /etc/nixos/dotfiles/zshrc";
      "nrb" = "sudo nixos-rebuild switch";
      "mp" = "ncmpcpp";
      "open" = "rifle";
      "o" = "rifle";
      "timer" = "termdown";
      "nd" = "nix develop --command zsh";
      "ns" = "nix-shell --run zsh";
      "nb" = "nix build";
    };
    interactiveShellInit = builtins.readFile ../dotfiles/zshrc;
    syntaxHighlighting.enable = true;
  };

  home-manager.users.junikim = {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        coc-nvim
        # Coc Plugins
        coc-json
        coc-diagnostic
        coc-prettier
        coc-vimtex
        coc-pyright
        coc-tsserver
        coc-clangd
        coc-go

        vimtex
        vim-nix
        yuck-vim
        gitsigns-nvim
        vim-css-color
        nvim-tree-lua
        barbar-nvim
        nvim-web-devicons
        nvim-treesitter.withAllGrammars
        vim-toml
        ownpkg.autoclose
        emmet-vim
        zig-vim
        vim-asymptote

        vim-airline
        fcitx-vim
        vim-airline-themes
        catppuccin-nvim
        vim-fugitive
        nvim-ufo

        telescope-nvim
        plenary-nvim
      ];
      extraConfig = builtins.readFile ../dotfiles/init.vim;
    };

    programs.vscode = {
      enable = true;
      #package = pkgs.vscodium;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode-remote.remote-ssh
        vscodevim.vim
        esbenp.prettier-vscode
        file-icons.file-icons
        arrterian.nix-env-selector
        jnoortheen.nix-ide
        catppuccin.catppuccin-vsc
      ];
    };

    programs.git = {
      enable = true;
      userName = "Juni Kim";
      userEmail = "junikimm717@gmail.com";
      extraConfig = {
        credential.helper = "store";
        http.postBuffer = 157286400;
        pull.rebase = true;
      };
    };
    programs.git.lfs.enable = true;
  };
}
