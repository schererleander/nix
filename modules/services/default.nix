{ ... }:

{
	imports = [
		./printer.nix
		./polkit.nix
		./pipewire.nix
		./mullvad.nix
	];

	config = {
		# Default services confguration, things that dont need their own module.
		services.openssh.enable = true;
	};
}
