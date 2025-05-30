{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;
  networking.hostName = "my-vps";
  networking.domain = "";

  users.users.administrator = {
    isNormalUser = true;
    password = "admin";
    extraGroups = [ "wheel" ];
  };

  services.openssh = {
    enable = true;
    ports = [ 8693 ];
    settings = {
      PasswordAuthentication = false;
      X11Forwarding = false;
      PermitRootLogin = "yes";
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."schererleander.de" = {
      root = "/var/www/site";
    };
  };

  networking.firewall.allowedTCPPorts = [ 8693 ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.05";
}
