{ inputs
, pkgs
, vars
, lib
, config
, ...
}:
# let
#   orca-beta =
#     pkgs.orca-slicer.overrideAttrs (finalAttrs: previousAttrs: {
#       version = "2.1.0-beta";
#       src = pkgs.fetchFromGitHub {
#         owner = "SoftFever";
#         repo = "OrcaSlicer";
#         rev = "v2.1.0-beta";
#         hash = "sha256-fR1tUNe79X5WY6lfUvrQ2HUbQ9AY+/03PL4U2GlWHL4=";
#       };
#     });
# in
{
  imports = [ ./firefox.nix ];

  services.flatpak.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    cachix
    openscad-unstable
    firefox
    discord
    wget
    unzip
    alacritty
    alacritty-theme
    mission-center
    appimage-run
     orca-slicer
    #orca-slicer-beta
    talosctl
    rpi-imager
    nmapsi4
  ]; 
  # ++ [ orca-beta ];

  home-manager.users.${vars.user}.xdg.desktopEntries = {
    OrcaSlicer = {
      name = "OrcaSlicer";
      icon = "OrcaSlicer";
      type = "Application";
      genericName = "3D Printing Software";
      exec = "env WEBKIT_DISABLE_COMPOSITING_MODE=1 orca-slicer %U";
      terminal = false;
      categories = [ "Graphics" "3DGraphics" "Engineering" ];
      mimeType = [ "model/stl" "model/3mf" "application/vnd.ms-3mfdocument" "application/prs.wavefront-obj" "application/x-amf" ];
      startupNotify = false;
      settings = {
        Keywords = "3D;Printing;Slicer;slice;3D;printer;convert;gcode;stl;obj;amf;SLA";
        StartupWMClass = "orca-slicer";
      };
    };
  };

}
