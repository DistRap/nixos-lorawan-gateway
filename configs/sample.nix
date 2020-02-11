{ config, lib, pkgs, ... }:
{
  imports = [
    ./modules/gateway.nix
    ./profiles/raspberrypi.nix
  ];

  environment.systemPackages = with pkgs; [
    libgpiod
  ];

  gw = {
    enable = true;
    id = "B827EBFFFE517AAA";
    contactEmail = "gw@example.org";
    description = "Test gateway";
    gps.enable = true;
    mon.enable = true;
    ntp = {
      enable = true;
      public = true;
    };
    pps.enable = true;
    # tor.enable = true;
    wg = {
      enable = true;
      ip = "10.11.0.211/24";
    };

    customKernel = false;
    develMode = true;
  };

  system.stateVersion = "20.03"; 

  users.extraUsers.root.openssh.authorizedKeys.keys = with (import ./ssh-keys.nix); [ srk adluc ];
}
