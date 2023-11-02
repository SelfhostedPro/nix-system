{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    unstable.nixd
    unstable.bun
    nodejs_18
  ];
  homebrew = {
    casks = [
      "visual-studio-code"
      "insomnia"
      "vlc"
    ];
  };
}
