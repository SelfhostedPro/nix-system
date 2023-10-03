{ pkgs, vars, ... }:

{
  users.users.${vars.user} = {
    shell = pkgs.zsh;
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      shellAliases = {
        update = "sudo nixos-rebuild switch --flake ~/system/#base";
        hupdate = "home-manager switch --flake ~/system/#user";
        waybarr = "systemctl restart --user waybar";
      };
    };
  };
}
