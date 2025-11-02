{ ... }:

{
  nix = {
    settings = {
      experimentalFeatures = [
        "nix-command"
        "flakes"
      ];
			auto-optimise-store = true;
    };
		gc = {
			automatic = true;
			dates = "daily";
			options = "--delete-older-than 15d";
		};
  };
}
