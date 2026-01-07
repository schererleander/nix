{ ... }:

{
  imports = [
    ./printer.nix
    ./polkit.nix
    ./pipewire.nix
    ./mullvad.nix
    ./nextcloud-client.nix
    ./wooting.nix
    ./openssh.nix
    ./keyring.nix
  ];
}
