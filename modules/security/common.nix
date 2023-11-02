{
  config,
  pkgs,
  ...
}: {
  systemd.coredump.enable = false;

  services.clamav.daemon.enable = true;
  services.clamav.updater.enable = true;
}
