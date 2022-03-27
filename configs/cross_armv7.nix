{ config, lib, pkgs, ... }:
{
  imports = [
    <lorawan-gateway>
    ../profiles/raspberrypi.nix
  ];

  nixpkgs = {
    crossSystem.system = "armv7l-linux";
    overlays = [
    ];
  };

  environment.systemPackages = with pkgs; [
    libgpiod
  ];

  gw = {
    enable = true;
    id = "B827EBFFFE517AAA";
    contactEmail = "gw@example.org";
    description = "Test gateway";
    # XXX: gpsd won't crosscompile
    gps.enable = false;
    mon.enable = true;
    ntp = {
      enable = true;
    #  public = true;
    };
    pps.enable = true;
    tor.enable = true;
    wg = {
      enable = !true;
      ips = [ "10.11.0.211/24" ];
    };

    customKernel = false;
    develMode = true;
  };

  system.stateVersion = "22.05";

  users.extraUsers.root.openssh.authorizedKeys.keys = with (import ./ssh-keys.nix); [ srk adluc ];
}
