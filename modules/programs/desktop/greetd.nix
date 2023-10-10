{
  config,
  pkgs,
  lib,
  vars,
  inputs,
  ...
}: 
let
  gtkgreetCfg = pkgs.writeText "gtkgreet.conf" ''
    exec-once = GTK_THEME=Adwaita:dark ${pkgs.greetd.gtkgreet}/bin/gtkgreet --layer-shell; ${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/hyprctl dispatch exit
    bind = SUPER, T, exec, kitty
  '';
in 
{
  ## New
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${inputs.hyprland.packages.${pkgs.system}.hyprland}/bin/Hyprland --config ${gtkgreetCfg}";
      };
    };
  };

  ## Old
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session.command = ''
  #       ${pkgs.greetd.tuigreet}/bin/tuigreet \
  #         --time \
  #         --asterisks \
  #         --remember \
  #         --user-menu \
  #         --cmd Hyprland
  #     '';
  #   };
  # };
  ### Ensure greetd has a hyprland entry
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';
}
