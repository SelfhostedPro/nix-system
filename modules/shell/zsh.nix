{
  pkgs,
  vars,
  ...
}: {
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
          update = "noglob sudo nixos-rebuild build --flake ~/system/#base && ${pkgs.nvd}/bin/nvd diff /run/current-system ./result";
          upgrade = "noglob sudo nixos-rebuild switch --flake ~/system/#base";
          fupdate = "noglob nix flake update ~/system/";
          cleanboot = "sudo nix-collect-garbage --delete-older-than 5d && nix-env -p /nix/var/nix/profiles/system --delete-generations +2";
          waybarr = "pkill -SIGUSR2 waybar";
          nexplorer = "noglob nix repl ~/system/#nixosConfigurations.base";
          aterraform = "aws-vault exec devops -- terraform";
          skillall = "read \"appname?Appname: \"; ps aux | grep -i $appname | awk '{print $2}' | xargs kill -9";
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
