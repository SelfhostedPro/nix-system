{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    unstable.grimblast
    # grim # Grab Images
    # slurp # Region Selector
    wayland-protocols
    libinput
    libnotify
    swappy # Snapshot Editor
    swaybg
    # hyprpaper
    wl-clipboard
    clipman
    xorg.xwininfo

    # Notifications
    libnotify
    fnott
    dunst

    # Remote Desktops https://github.com/bbusse/swayvnc/blob/main/Containerfile
    wayvnc
    neatvnc
  ];
  services = {
    fnott.enable = true;
    fnott.settings = {
      main = {
        font = "Noto Sans Mono:weight=500:size=7";
        pad = "12x12";
      };
      colors = {
        background = "0a0a0a";
        foreground = "b0b0b0";
        regular0 = "0a0a0a";
        regular1 = "ac4142";
        regular2 = "90a959";
        regular3 = "f4bf75";
        regular4 = "6a9fb5";
        regular5 = "aa759f";
        regular6 = "75b5aa";
        regular7 = "b0b0b0";
        bright0 = "4a4a4a";
        bright1 = "ac4142";
        bright2 = "90a959";
        bright3 = "f4bf75";
        bright4 = "6a9fb5";
        bright5 = "aa759f";
        bright6 = "75b5aa";
        bright7 = "f5f5f5";
      };
    };
  };
}
