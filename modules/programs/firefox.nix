{
  flake.modules.homeManager.firefox =
    {
      pkgs,
      inputs,
      ...
    }:
    {
      programs.firefox = {
        enable = true;
        package = pkgs.firefox;

        policies = {
          DisableTelemetry = true;
          DisableFirefoxStudies = true;

          PasswordManagerEnabled = false;
          OfferToSaveLogins = false;

          DisplayBookmarksToolbar = "never";
          NoDefaultBookmarks = true;

          DisableAccounts = true;

          Homepage = {
            URL = "about:blank";
            Locked = true;
            StartPage = "previous-session";
          };

          NewTabPage = false;

          EncryptedMediaExtensions = {
            Enabled = true;
            Locked = true;
          };

          AIControls = {
            Default = {
              Value = "blocked";
              Locked = true;
            };

            Translations = {
              Value = "available";
              Locked = false;
            };
          };

          UserMessaging = {
            ExtensionRecommendations = false;
            FeatureRecommendations = false;
            Locked = true;
            MoreFromMozilla = false;
            SkipOnboarding = true;
            UrlbarInterventions = false;
          };
        };

        profiles.default = {
          settings = {
            # HDR on Linux/Wayland.
            "gfx.color_management.hdr" = true;

            # Work around broken AMD AV1 hardware decoding with recent firmware.
            "media.av1.enabled" = false;

            # Disable fullscreen notification.
            "full-screen-api.warning.timeout" = 0;

            # Disable automatic translation popup.
            "browser.translations.automaticallyPopup" = false;

            # Automatically enable declaratively installed extensions.
            "extensions.autoDisableScopes" = 0;

            # Disable Ctrl-Tab recently-used sorting/preview behaviour.
            "browser.ctrlTab.sortByRecentlyUsed" = false;

            # Do not open the downloads panel when a download completes.
            "browser.download.alwaysOpenPanel" = false;

            # Disable Firefox View.
            "browser.tabs.firefox-view" = false;
          };

          extensions = {
            packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
              ublock-origin
              istilldontcareaboutcookies
              adaptive-tab-bar-colour
            ];

            force = true;

            settings."uBlock0@raymondhill.net".settings = {
              UserMessaging = {
                cloudStorageEnabled = false;
                contextMenuEnabled = false;
              };

              userFilters = ''
                ||accounts.google.com/gsi/*
              '';
            };
          };

          search = {
            default = "google";

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

              mynixos = {
                name = "MyNixOS";
                urls = [
                  {
                    template = "https://mynixos.com/search?q={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://mynixos.com/favicon.ico";
                definedAliases = [ "@mn" ];
              };

              nixos-wiki = {
                name = "NixOS Wiki";
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
                  }
                ];
                iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
                definedAliases = [ "@nw" ];
              };

              bing.metaData.hidden = true;
              google.metaData.alias = "@g";
            };

            force = true;
          };
        };
      };
    };
}
