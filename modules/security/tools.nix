{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../virtualisation
  ];

  environment.systemPackages = with pkgs; [
    xorg.xhost
    nmap
    minder
  ];
}
