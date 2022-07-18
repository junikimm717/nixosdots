# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  brotherdriver = import ./brother.nix { 
    pkgsi686Linux = pkgs.pkgsi686Linux; 
    lib = lib;
    pkgs = pkgs;
  };
in
{

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.thermald.enable = true;
  services.nfs.server.enable = true;

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "US/Eastern";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";


  # use nix flakes
  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ brotherdriver.driver brotherdriver.cupswrapper ];
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;

  # Enable sound.
  hardware.bluetooth.enable = true;
  #services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.homeBinInPath = true;
  environment.variables = {
    "EDITOR" = "nvim";
  };

  services.gnome = {
    gnome-keyring.enable = true;
  };
  programs.seahorse.enable = true;
  programs.dconf.enable = true;
  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.mesa.drivers ];
  };

  fonts.fonts = with pkgs; [ 
    jetbrains-mono 
    dejavu_fonts 
    noto-fonts-emoji 
    noto-fonts-cjk
    noto-fonts
    iosevka
    font-awesome
    nerdfonts
  ];
  environment.systemPackages = with pkgs; [
    xorg.xbacklight pamixer brightnessctl blueberry
    vim neovim neofetch pfetch tmux kitty
    fff
    nodejs shellcheck
    bash dash git
    wget brave scrot
    nfs-utils gcc gnumake
    htop
    gnome.seahorse
    ranger
    virt-manager
    efibootmgr
    gnome.adwaita-icon-theme
    lm_sensors acpi
    rpcbind
    sshfs
    docker-compose
    vlc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    #enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
  #system.stateVersion = "unstable"; # Did you read the comment?
}

