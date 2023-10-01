{ config, pkgs, ... }:
{
  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/43fd432d-2a9d-46a5-8367-52684163e64f";
      fsType = "ext4";
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.user = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
      screen
    ];
  };

  #home-manager.useUserPackages = true;
  #home-manager.users.user = { pkgs, ... }: {
  #  home.stateVersion = "22.11";
  #  programs.bash.enable = true;
  #  programs.zsh.enable = true;
  #};
}
