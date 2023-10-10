{
  config,
  pkgs,
  ...
}: {
  # Install Packages
  environment.systemPackages = with pkgs; [
    utm
  ];
  homebrew = {
    brews = ["whalebrew"];
    casks = ["docker"];
  };
}
