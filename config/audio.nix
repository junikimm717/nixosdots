{ config, pkgs, ... }: {
  sound.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };

  #services.pipewire.enable = true;
  #services.pipewire.alsa.enable = true;
  #services.pipewire.pulse.enable = true;

  environment.systemPackages = with pkgs; [ mpc_cli ncmpcpp ];

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
    XDG_RUNTIME_DIR =
      "/run/user/1000"; # User-id 1000 must match above user. MPD will look inside this directory for the PipeWire socket.
  };
}
