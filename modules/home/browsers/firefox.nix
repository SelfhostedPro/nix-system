{
  pkgs,
  vars,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles.${vars.user} = {
      search.engines = {
        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages?channel=23.05&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };
        "Nix Options" = {
          urls = [
            {
              template = "https://search.nixos.org/options?channel=23.05&from=0&size=50&sort=relevance&type=options&query={searchTerms}";
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@no"];
        };
        "Nix Hub" = {
          urls = [{tempalte = "https://www.nixhub.io/search?q={searchTerms}";}];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@nh" "@nv"];
        };
        "NUR" = {
          urls = [
            {
              template = "https://github.com/search?q=repo%3Anix-community%2Fnur-combined%20{searchTerms}&type=code";
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@nur"];
        };
        "Home Manager" = {
          urls = [
            {
              template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@hm"];
        };
      };
      search.force = true;
      settings = {
        "browser.aboutConfig.showWarning" = false;
        "browser.startup.homepage" = "https://search.nixos.org";
        "browser.vpn_promo.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "media.ffmpeg.vaapi.enabled" = true; #https://github.com/elFarto/nvidia-vaapi-driver#firefox
        "media.rdd-ffmpeg.enabled" = true; # ^^
        "gfx.webrender.all" = true;
      };
    };
  };
}
