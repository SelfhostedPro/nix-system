{config, pkgs, ...}: {
  networking.firewall.enable = false;
  systemd.coredump.enable = false;
  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
}