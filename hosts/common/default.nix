{ pkgs
, inputs
, ...
}: {
  fonts.packages = with pkgs; [
    nerdfonts
  ];
}
