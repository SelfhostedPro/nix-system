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
        update = "sudo nixos-rebuild build --flake ~/system/#base";
        waybarr = "systemctl restart --user waybar";
      };
    };
  };
}
