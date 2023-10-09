{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    gamescope
  ];

  programs.steam = {
    enable = true;
  };
}
