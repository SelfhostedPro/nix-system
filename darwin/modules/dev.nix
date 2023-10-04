{ config, pkgs, ... }:
{
  homebrew = {
    brews = [
      "node@18"
    ];
    casks = [
      "visual-studio-code"
      "insomnia"
    ];
  };
}
