{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    sunshine # Moonlight Server
    avahi #mDNS
  ];

  # Allows sunshine to simulate input.
  boot.initrd.kernelModules = ["uinput"];

  # Avahi for mDNS and udev rules for input.
  services = {
    avahi = {
      enable = true;
      reflector = true;
      nssmdns = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
        workstation = true;
      };
    };
    udev.extraRules = ''
      Sunshine
      KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    '';
  };

  # Security wrapper for remote input permissions
  security.wrappers.sunshine = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+p";
    source = "${pkgs.sunshine}/bin/sunshine";
  };
  systemd.user.services.nm-applet.enable = false;
  systemd.user.services.sunshine = {
    enable = true;
    description = "sunshine";
    wantedBy = ["graphical-session.target"];
    serviceConfig = {
      ExecStart = "${config.security.wrapperDir}/sunshine";
      # ExecStartPre = "${lib.getExe pkgs.xorg.xset} dpms force on";
      Restart = "always";
    };
  };
}
