{ configs, pkgs, vars, ... }: {


  home-manager.users.${vars.user} = {
    # vs-code-server fixes
    imports = [
      "${fetchTarball { url="https://github.com/msteen/nixos-vscode-server/tarball/master"; 
      sha256="0sz8njfxn5bw89n6xhlzsbxkafb6qmnszj4qxy2w0hw2mgmjp829";}
      }/modules/vscode-server/home.nix"
    ];
    services.vscode-server.enable = true;
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        tyriar.sort-lines
      ];
      userSettings = {
        "editor.fontFamily"= "SauceCodePro Nerd Font Mono";
      };
    };

    programs.git = {
      enable = true;
      userName = "SelfhostedPro";
      userEmail = "info@selfhosted.pro";
    };
  };
}
