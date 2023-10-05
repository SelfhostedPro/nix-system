{ config, lib, pkgs, inputs, vars, nur, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox-wayland # Browser
  ];

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    policies = {
      # https://mozilla.github.io/policy-templates/
      AppAutoUpdate = true;
      Containers = {
        "Default" = [
          {
            "name" = "personal";
            "icon" = "fingerprint";
            "color" = "blue";
          }
          {
            "name" = "work";
            "icon" = "briefcase";
            "color" = "green";
          }
          {
            "name" = "work-legacy";
            "icon" = "briefcase";
            "color" = "red";
          }
        ];
      };
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisableMasterPasswordCreation = true;
      DisablePocket = true;
      DisableProfileImport = true;
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          "default_Area" = "navbar";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          "default_Area" = "navbar";
        };
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
        };
        "@testpilot-containers" = {
          "installation_mode" = "force_installed";
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
        };
        "bing@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "amazondotcom@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "ddg@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
        "ebay@search.mozilla.org" = {
          "installation_mode" = "blocked";
        };
      };
      FirefoxHome = {
        "Search" = true;
        "TopSites" = false;
        "SponsoredTopSites" = false;
        "Highlights" = false;
        "Pocket" = false;
        "SponsoredPocket" = false;
        "Snippets" = true;
        "Locked" = true;
      };
      FirefoxSuggest = {
        "SponsoredSuggestions" = false;
        "ImproveSuggest" = false;
        "WebSuggestions" = true;
        "Locked" = true;
      };
      ManagedBookmarks = [
        {
          "toplevel_name" = "synced";
        }
        {
          "name" = "NixOS";
          "children" = [
            {
              "name" = "NixOS";
              "url" = "https://nixos.org";
            }
          ];
        }
        {
          "name" = "Docs";
          "children" = [
            {
              "name" = "firefox-policies";
              "url" = "https://mozilla.github.io/policy-templates/";
            }
          ];
        }
      ];
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      # SearchEngines.Add = [
      #   {
      #     "Name" = "Nix Packages";
      #     "URLTemplate" = "https://search.nixos.org/packages?channel=23.05&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
      #     "Method" = "GET";
      #     "Alias" = "@np";
      #     "IconURL" = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      #   }
      # ];
    };
  };

  home-manager.users.${vars.user}.programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    profiles.${vars.user} = {
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages?channel=23.05&from=0&size=50&sort=relevance&type=packages&query={searchTerms}";
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
        "Nix Options" = {
          urls = [{
            template = "https://search.nixos.org/options?channel=23.05&from=0&size=50&sort=relevance&type=options&query={searchTerms}";
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@no" ];
        };
        "NUR" = {
          urls = [{
            template = "https://github.com/search?q=repo%3Anix-community%2Fnur-combined%20{searchTerms}&type=code";
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nur" ];
        };
        "Home Manager" = {
          urls = [{
            template = "https://mipmip.github.io/home-manager-option-search/?query={searchTerms}";
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@hm" ];
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
