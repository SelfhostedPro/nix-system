{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = mkIf config.security.sandboxing {
    programs.firejail.enable = true;
    security.chromiumSuidSandbox.enable = true;

    programs.firejail.wrappedBinaries = {
      firefox = {
        executable = "${pkgs.lib.getBin pkgs.firefox-wayland}/bin/firefox";
        profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      };
      chromium = {
        executable = "${pkgs.lib.getBin pkgs.thorium}/bin/thorium";
        profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
      };
    };
  };
}
