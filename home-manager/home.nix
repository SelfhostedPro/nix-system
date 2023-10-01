# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{ inputs, outputs, ... }:
{
  # You can import other home-manager modules here
  imports = [
    ./global
    ./shell.nix
  ];
}
