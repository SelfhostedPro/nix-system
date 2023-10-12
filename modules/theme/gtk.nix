{
  config,
  pkgs,
}: {
  environment.systemPackages = with pkgs; [
    gtk4
    gtk3
    gtk2
  ];
}
