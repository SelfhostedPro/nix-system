{ pkgs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    zsh
  ];

  programs.zsh.enable = true;

  users.users.${vars.user} = {
    shell = pkgs.zsh;
  };

  home-manager.users.${vars.user} = {
    home.file.".config/.p10k.zsh" = {
      source = ./p10k.zsh;
    };
    programs = {
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        enableCompletion = true;
        shellAliases = {
          update = "noglob sudo nixos-rebuild switch --flake ~/system/#base";
          waybarr = "systemctl restart --user waybar";
        };
        prezto = {
          enable = true;
          pmodules = [
            "environment"
            "terminal"
            "editor"
            "history"
            "directory"
            "spectrum"
            "utility"
            "completion"
            "prompt"
            "ssh"
          ];
          # extraModules = { };
          prompt.theme = "powerlevel10k";
        };
        initExtra = builtins.readFile ./p10k.zsh;
      };
    };
  };
}
