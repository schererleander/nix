{ config, lib, pkgs, ... }:

let
  cfg = config.firefox;
in {
  options.enable = lib.mkEnableOption = "Setup firefox";

  config = lib.mkIf cfg.enable {
    program.firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
	istilldontcareaboutcookies
	sponsorblock
	vimium-c
	startpage-private-search
      ];

      userProfile = {
        preferences = {
	  # Disable the Bookmarks Toolbar
	  "browser.toolbars.bookmarks.visibility" = "never";
	  
	  # Disable Pocket
	  "extensions.pocket.enabled" = false;

	  # Remove Firefox View
	  "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSearch" = false;
          "browser.newtabpage.activity-stream.showTopSites" = false;
          "browser.newtabpage.activity-stream.showHighlights" = false;

	  # privacy settings
	  "privacy.firstparty.isolate" = true;  # Isolate cookies per site
          "privacy.resistFingerprinting" = true;
          "privacy.trackingprotection.enabled" = true;
        };
      };
    };
  };
}

