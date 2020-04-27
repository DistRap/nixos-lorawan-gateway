{ config, pkgs, lib, ... }:
{
  imports = [
    ./arm-headless.nix
    <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  boot.loader.timeout = -1;
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.loader.generic-extlinux-compatible.configurationLimit = 4;

  boot.kernelParams = [
    "modprobe.blacklist=pps_ldisc"
  ] ++
      (if # use ttyAMA0 as console unless used by GPS
        (config.gw.gps.device != "/dev/ttyAMA0")
        then [ "console=ttyAMA0,115200n8" ]
        else [ "console=tty0" ]);

  services.journald = {
    extraConfig = ''
      Storage=volatile
    '';
  };

  sdImage =
  let
    extlinux-conf-builder =
      import <nixpkgs/nixos/modules/system/boot/loader/generic-extlinux-compatible/extlinux-conf-builder.nix> {
        inherit pkgs;
      };
  in
  {
    # causes bzip2 compression of image already compressed by zstd
    compressImage = false;

    populateFirmwareCommands = let
      configTxt = pkgs.writeText "config.txt" ''
        # Prevent the firmware from smashing the framebuffer setup done by the mainline kernel
        # when attempting to show low-voltage or overtemperature warnings.
        avoid_warnings=1

        [pi2]
        kernel=u-boot-rpi2.bin

        [pi3]
        kernel=u-boot-rpi3.bin

        # U-Boot used to need this to work, regardless of whether UART is actually used or not.
        # TODO: check when/if this can be removed.
        enable_uart=1
        # Don't vary core freq
        core_freq=250
      '';
      in ''
        (cd ${pkgs.raspberrypifw}/share/raspberrypi/boot && cp bootcode.bin fixup*.dat start*.elf $NIX_BUILD_TOP/firmware/)
        cp ${pkgs.ubootRaspberryPi2}/u-boot.bin firmware/u-boot-rpi2.bin
        cp ${pkgs.ubootRaspberryPi3_32bit}/u-boot.bin firmware/u-boot-rpi3.bin
        cp ${configTxt} firmware/config.txt
      '';
        # we used these before to avoid gps output breaking boot
        #cp ${pkgs.ubootRaspberryPi2_NoDelays}/u-boot.bin firmware/u-boot-rpi2.bin
        #cp ${pkgs.ubootRaspberryPi3_32bit_NoDelays}/u-boot.bin firmware/u-boot-rpi3.bin
    populateRootCommands = ''
        mkdir -p ./files/boot
        ${extlinux-conf-builder} -t 3 -c ${config.system.build.toplevel} -d ./files/boot
      '';
  };
}
