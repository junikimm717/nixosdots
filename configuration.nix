# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
  brotherdriver = import ./brother.nix { 
    pkgsi686Linux = pkgs.pkgsi686Linux; 
    lib = lib;
    pkgs = pkgs;
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  services.xserver.displayManager.startx.enable = true;
  fileSystems."/home/junikim/docs" = {
      device = "/dev/disk/by-label/docs";
      fsType = "ext4";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  services.thermald.enable = true;

  networking.hostName = "nixos-lemp"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "US/Eastern";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  #networking.useDHCP = true;
  #networking.interfaces.enp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.physlock = {
    enable = true;
    lockMessage = "NixOS-lemp locked";
    allowAnyUser = true;
    lockOn = {
      suspend = true;
      hibernate = true;
    };
  };
  #programs.xss-lock.enable = true;

  # use nix flakes
  nix = {
    package = pkgs.nixFlakes; # or versioned attributes like nix_2_7
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  #programs.command-not-found.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ brotherdriver.driver brotherdriver.cupswrapper ];
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;


  # Enable sound.
  sound.enable = true;
  hardware.bluetooth.enable = true;
  #services.blueman.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.pulse.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.junikim = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "input" "docker" "libvirtd" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
  };

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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  fonts.fonts = with pkgs; [ 
    jetbrains-mono 
    dejavu_fonts 
    noto-fonts-emoji 
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
    mpd mpc_cli htop
    gnome.seahorse
    ranger
    virt-manager
    efibootmgr
    gnome.adwaita-icon-theme
    lm_sensors acpi
  ];
  
  services.mpd = {
    enable = true;
    musicDirectory = "/home/junikim/docs/music";
    dataDir = "/home/junikim/docs/music/mpd";
    user = "junikim";
    extraConfig = ''
audio_output {
        type            "pipewire"
        name            "MPD Pipewire"
}
# adds fifo
audio_output {
    type                    "fifo"
    name                    "my_fifo"
    path                    "/tmp/mpd.fifo"
    format                  "44100:16:2"
}
'';
  };
systemd.services.mpd.environment = {
    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/609
    XDG_RUNTIME_DIR = "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
};

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
  #system.stateVersion = "21.11"; # Did you read the comment?
  system.stateVersion = "unstable"; # Did you read the comment?
}

