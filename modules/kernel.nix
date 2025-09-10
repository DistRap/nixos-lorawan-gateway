{ config, pkgs, lib, ... }:
with lib;

{
  options = {
    gw.customKernel = mkEnableOption "Enable customized kernel";
  };

  config = {

    hardware.deviceTree.filter = "*rpi*.dtb";
    hardware.deviceTree.overlays = [
      { name = "pps"; dtsFile = ./dts/pps.dts; }
      { name = "spi"; dtsFile = ./dts/spi.dts; }
    ];

    boot.consoleLogLevel = lib.mkDefault 7;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelPatches = lib.optionals config.gw.customKernel [
       {
         name = "gpio-sysfs-config";
         patch = null;
         extraConfig = ''
           GPIO_SYSFS y
         '';
       }
       {
         name = "dontwastemytime-config";
         patch = null;
         extraConfig = ''
           DRM n
           SOUND n
           VIRTUALIZATION n
         '';
       }
    ];
  };
}
