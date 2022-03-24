{ config, lib, pkgs, ... }:
{
  imports = [
    <lorawan-gateway>
    ../profiles/raspberrypi.nix
  ];

  environment.systemPackages = with pkgs; [
    libgpiod
  ];

  gw = {
    id = "B827EBFFFE517AAA";
    contactEmail = "srk@48.io";
    description = "Test gateway";
    gps.enable = true;
    pps.enable = true;
    tor.enable = true;
    ntp.public = true;
    wg = {
      enable = true;
      ips = [ "10.11.0.211/24" ];
    };
    develMode = true;
  };

  users.extraUsers.root.openssh.authorizedKeys.keys = with (import ./ssh-keys.nix); [ srk adluc ];
}
