{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    unstable.nixd
  ];
  homebrew = {
    brews = [
      "node@18"
    ];
    casks = [
      "visual-studio-code"
      "insomnia"
    ];
  };
}
