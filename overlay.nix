(self: super:
  let
  # we use these to avoid GPS output breaking boot in case
  # when GPS is connected to rPi UART (/dev/ttyACM0)
  ubootZeroBootDelay = x: x.overrideAttrs (old: {
    extraConfig = ''
      CONFIG_BOOTDELAY=0
      CONFIG_AUTOBOOT_KEYED=y
      CONFIG_AUTOBOOT_KEYED_CTRLC=y
      CONFIG_AUTOBOOT_PROMPT="Hit Ctrl-C to abort in %d\n"
    '';
  });
  in
  {
    ail_gpio = super.callPackage ./pkgs/ail_gpio {};
    lora_gateway  = super.callPackage ./pkgs/lora_gateway {};
    packet_forwarder  = super.callPackage ./pkgs/packet_forwarder {};

    gpsd  = super.gpsd.override { guiSupport = false; };

    ubootRaspberryPi2_zeroBootDelay = ubootZeroBootDelay super.ubootRaspberryPi2;
    ubootRaspberryPi3_32bit_zeroBootDelay = ubootZeroBootDelay super.ubootRaspberryPi3_32bit;
  }
)
