# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
in {

  boot.kernelParams = [ "i915.force_probe=9a49" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.thermald.enable = true;
  services.nfs.server.enable = true;

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  #time.timeZone = "US/Eastern";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "eurosign:e";

  # use nix flakes
  nix = {
    package = pkgs.nixVersions.stable; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish.enable = true;
    publish.addresses = true;
    publish.workstation = true;
    publish.userServices = true;
  };

  # Enable sound.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.tapping = false;
  services.libinput.touchpad.naturalScrolling = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  nixpkgs.config.allowUnfree = true;
  environment.homeBinInPath = true;
  environment.variables = { "EDITOR" = "nvim"; };

  programs.dconf.enable = true;
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
    ];
    #driSupport32Bit = true;
    #driSupport32Bit = true;
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    dejavu_fonts
    freefont_ttf
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts
    iosevka
    meslo-lg
    liberation_ttf
    font-awesome
    siji
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
  ];
  environment.systemPackages = with pkgs; [
    xorg.xbacklight
    pamixer
    brightnessctl
    blueberry
    vim
    neovim
    neofetch
    pfetch
    tmux
    kitty
    alacritty
    fff
    nodejs
    shellcheck
    bash
    dash
    git
    git-lfs
    wget
    brave
    scrot
    nfs-utils
    gcc
    gnumake
    htop
    seahorse
    ranger
    virt-manager
    efibootmgr
    adwaita-icon-theme
    lm_sensors
    acpi
    rpcbind
    sshfs
    docker-compose
    vlc
    libvlc
    mpv
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

