{ config, pkgs, ... }:
{
  programs.nm-applet.enable = true;

  environment = {
    systemPackages = with pkgs; [
      # System-Wide Packages
      discord # Messaging
      networkmanagerapplet
      spotify
      slack
    ];
  };


  nixpkgs.overlays = [
    # Overlay pulls latest version of Discord
    (self: super: {
      discord = super.discord.overrideAttrs (
        _: {
          src = builtins.fetchTarball {
            url = "https://discord.com/api/download?platform=linux&format=tar.gz";
            sha256 = "0yzgkzb0200w9qigigmb84q4icnpm2hj4jg400payz7igxk95kqk";
          };
        }
      );
    })
  ];
}
