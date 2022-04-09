{ config, lib, pkgs, ... }:
{
  imports = [
    ./gateway.nix
    ../profiles/raspberrypi.nix
  ];

  environment.systemPackages = with pkgs; [
    libgpiod
  ];

  gw = {
    enable = lib.mkDefault true;
    gps.enable = lib.mkDefault false;
    mon.enable = lib.mkDefault true;
    pps.enable = lib.mkDefault false;
    #tor.enable = true;
    #wg = {
    #  enable = true;
    #};

    #customKernel = false;
    #develMode = false;
  };

  system.stateVersion = "22.05";
}
