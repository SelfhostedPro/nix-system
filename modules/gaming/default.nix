{
  config,
  pkgs,
  vars,
  ...
}: {
  # Possible issues/fixes https://github.com/NixOS/nixpkgs/issues/238101#issuecomment-1607806376
  programs = {
    steam = {
      enable = true;
    };
    gamescope = {
      enable = true;
      capSysNice = true;
    };
  };
  environment.systemPackages = with pkgs; [
    mangohud
    unstable.godot_4
    obs-studio
  ];
  hardware.opengl = {
    extraPackages = with pkgs; [mangohud gamescope];
    extraPackages32 = with pkgs; [mangohud gamescope];
  };
  home-manager.users.${vars.user}.programs.mangohud = {
    enable = true;
    settings = {
      full = true;
      cpu_load_change = true;
    };
  };
}
