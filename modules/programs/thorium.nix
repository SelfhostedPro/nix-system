{
  lib,
  pkgs,
  config,
  vars,
  ...
}: {
  home-manager.users.${vars.user}.programs.chromium = {
    enable = true;
    package = pkgs.thorium;
    commandLineArgs = [
      "--force-dark-mode"
    ];
    extensions = [
      {id = "nngceckbapebfimnlniiiahkandclblb";}
      {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";}
    ];
  };
}
