{ config, pkgs, ... }:
let
  ownpkg = import ./personal-packages.nix { inherit config pkgs; };
  customPython =
    pkgs.python3.withPackages (ps: with ps; [ requests numpy toml ]);
in {
  environment.systemPackages = with pkgs; [ customPython shellcheck rnix-lsp ];

  programs.starship.enable = true;
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
      "z" = "zathura --fork";
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

        # Coc Plugins
        coc-json
        coc-diagnostic
        coc-prettier
        coc-vimtex
        coc-pyright
        coc-tsserver
      ];
      extraConfig = builtins.readFile ../dotfiles/init.vim;
    };

    programs.vscode = {
      enable = true;
      #package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode-remote.remote-ssh
        vscodevim.vim
        esbenp.prettier-vscode
        file-icons.file-icons
        arrterian.nix-env-selector
        jnoortheen.nix-ide
      ];
    };

    programs.git = {
      enable = true;
      userName = "Juni Kim";
      userEmail = "junikimm717@gmail.com";
      extraConfig = { credential.helper = "store"; };
    };
  };
}
