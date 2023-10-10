{
  config,
  pkgs,
  ...
}: {
  sound.enable = true;
  services = {
    # Gnome Remote Desktop Settings
    gnome.gnome-keyring.enable = true;
    gnome.gnome-remote-desktop.enable = true;
    # CUPS
    # printing = {
    #   enable = true;
    # };
    # Sound
    mpd = {
      enable = true;
      startWhenNeeded = true;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
    pcscd.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    # Flatpak
    flatpak.enable = true;
    # SSH
    openssh = {
      enable = true;
      allowSFTP = true; # SFTP
    };
  };
}
