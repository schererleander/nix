{ pkgs, ... }:

{
  services.udev.extraRules = ''
    		# Wooting One Legacy
    		SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"
    		SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff01", TAG+="uaccess"

    		# Wooting One update mode
    		SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2402", TAG+="uaccess"

    		# Wooting Two Legacy
    		SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"
    		SUBSYSTEM=="usb", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="ff02", TAG+="uaccess"

    		# Wooting Two update mode
    		SUBSYSTEM=="hidraw", ATTRS{idVendor}=="03eb", ATTRS{idProduct}=="2403", TAG+="uaccess"

    		# Generic Wootings
    		SUBSYSTEM=="hidraw", ATTRS{idVendor}=="31e3", TAG+="uaccess"
    		SUBSYSTEM=="usb", ATTRS{idVendor}=="31e3", TAG+="uaccess"
    	'';

  environment.systemPackages = with pkgs; [
    wootility
  ];
}
