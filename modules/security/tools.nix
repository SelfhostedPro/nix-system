{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../virtualisation
  ];

  environment.systemPackages = with pkgs; [
    # Security Tools
    xorg.xhost
    nmap
    minder
    # IOS Tools
    ideviceinstaller
    libimobiledevice
    libimobiledevice-glue
    ifuse
    usbmuxd
    usbmuxd2
    libusbmuxd
  ];
}
