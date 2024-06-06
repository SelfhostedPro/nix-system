{ inputs
, pkgs
, vars
, ...
}: {
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    vscode
    git
    mqttx
  ];
  home-manager.users.${vars.user} = {
    programs.git = {
      enable = true;
      userName = "SelfhostedPro";
      userEmail = "info@selfhosted.pro"
    }
  }
}
