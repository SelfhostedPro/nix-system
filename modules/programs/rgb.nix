{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
  ];
  boot.kernelModules = ["i2c-dev" "i2c-piix4"];
  services.udev.packages = [ pkgs.openrgb ];
  hardware.i2c.enable = true;
}
