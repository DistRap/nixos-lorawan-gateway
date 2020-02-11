{ config, pkgs, lib, ... }:
{
  imports = [
    ./arm.nix
  ];
  
  boot.kernelParams = [
    "modprobe.blacklist=vc4" 
  ];
  
  environment.noXlibs = true;
  services.xserver.enable = false;
  services.xserver.desktopManager.xterm.enable = lib.mkForce false;
}
