{
  config,
  pkgs,
  ...
}: {
  services = {
    openssh = {
      enable = true;
      allowSFTP = true; # SFTP
      openFirewall = true;
    };
  };
}
