{ config, pkgs, lib, ... }:
with lib;

{
  options = {
    gw.customKernel = mkEnableOption "Enable customized kernel";
  };

  config = {

    hardware.deviceTree.kernelPackage = pkgs.linux_latest;
    hardware.deviceTree.filter = "*rpi*.dtb";
    hardware.deviceTree.overlays = [
      { name = "pps"; dtsFile = ./dts/pps.dts; }
      { name = "spi"; dtsFile = ./dts/spi.dts; }
      { name = "example"; dtsFile = ./dts/example.dts; }
    ];

    boot.consoleLogLevel = lib.mkDefault 7;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelPatches = lib.optional config.gw.customKernel [
       { name = "We need spidev for now";
         patch = (pkgs.fetchpatch {
           url = "https://github.com/sorki/linux/compare/v5.5...dont_bug_on_spidev_v5.5.patch";
           sha256 = "0ym377nv0c1mf1fxx4d2wnmn8nan1h5mv7ic39icxdp97cg1i4lb";
         });
       }
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
