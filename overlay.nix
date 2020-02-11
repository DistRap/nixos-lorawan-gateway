(self: super:
  {
    ail_gpio = super.callPackage ./pkgs/ail_gpio {};
    lora_gateway  = super.callPackage ./pkgs/lora_gateway {};
    packet_forwarder  = super.callPackage ./pkgs/packet_forwarder {};

    gpsd  = super.gpsd.override { guiSupport = false; };
  }
)
