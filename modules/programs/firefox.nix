{
  flake.modules.nixos.firefox =
    { pkgs, ... }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox;
      };
    };

  flake.modules.homeManager.firefox =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      programs.firefox = {
        enable = true;
        profiles.default = {
          extensions = {
            packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
              ublock-origin
              istilldontcareaboutcookies
            ];

            force = true;
            settings."uBlock0@raymondhill.net".settings = {
              UserMessaging = {
                cloudStorageEnabled = false;
                contextMenuEnabled = false;
              };
              # Block annoying login with google banner
              userFilters = ''
                ||accounts.google.com/gsi/*
              '';
            };
          };

          search = {
            default = "DuckDuckGo";
            engines = {
              nix-packages = {
                name = "Nix Packages";
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];

                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              nixos-wiki = {
                name = "NixOS Wiki";
                urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
                iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
                definedAliases = [ "@nw" ];
              };

              bing.metaData.hidden = true;
              google.metaData.alias = "@g";
            };
            force = true;
          };

          policies = {
            DisableTelemetry = true;
            DisableFirefoxStudies = true;
            PasswordManagerEnabled = false;
            OfferToSaveLogins = false;
            DisplayBookmarksToolbar = "never";
            NoDefaultBookmarks = true;

            Homepage = {
              URL = "about:blank";
              Locked = true;
              StartPage = "homepage";
            };

            NewTabPage = false;

            EnableTrackingProtection = {
              Value = true;
              Locked = true;
              Cryptomining = true;
              Fingerprinting = true;
            };

            EncryptedMediaExtensions = {
              Enabled = true;
              Locked = true;
            };

            FirefoxHome = {
              Search = true;
              TopSites = true;
              SponsoredTopSites = false;
              Highlights = true;
              Locked = true;
            };

            UserMessaging = {
              ExtensionRecommendations = false;
              FeatureRecommendations = false;
              Locked = true;
              MoreFromMozilla = false;
              SkipOnboarding = true;
              UrlbarInterventions = false;
            };

            Preferences = {
              # Disable fullscreen notification
              "full-screen-api.warning.timeout" = "0";

              # Disable annoying translation popup
              "browser.translations.automaticallyPopup" = false;

              # Enable all extensions automatically
              "extensions.autoDisableScopes" = 0;

              # Hide ctr-tab tab preview menu
              "browser.ctrlTab.sortByRecentlyUsed" = false;
            };
          };
        };
      };
    };
}
