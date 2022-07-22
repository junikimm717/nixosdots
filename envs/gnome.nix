{ config, pkgs, ... }: {
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome.geary
    gnome.gnome-contacts
    gnome.gnome-weather
    gnome.cheese
    gnome.gedit
    gnome.gnome-clocks
    gnome-connections
    gnome.yelp
    evince
  ];

  environment.systemPackages = with pkgs; [ gnomeExtensions.pop-shell ];

  hardware.pulseaudio.enable = pkgs.lib.mkForce false;
}
