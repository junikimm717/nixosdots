{ config, pkgs, ... }: {
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  hardware.pulseaudio.enable = pkgs.lib.mkForce false;
}
