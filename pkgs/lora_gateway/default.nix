{ stdenv, lib, fetchFromGitHub
, gwPlatform ? "imst_rpi"
}:

stdenv.mkDerivation rec {
  name = "lora_gateway-${version}";
  version = "4.0.0-${gwPlatform}";

  src = fetchFromGitHub {
    owner = "TheThingsNetwork";
    repo = "lora_gateway";
    rev = "4e2d95646e3a34224b460e69b6b417796b83b4ce";
    sha256 = "0sgwis6izgcc3xdq8b8ghazasi47s4i4hwj3hxj54fn82ppbw1sc";
  };

  outputs = [ "out" "dev" ];

  preConfigure = ''
    sed -i 's~PLATFORM= .*~PLATFORM= ${gwPlatform}~' libloragw/library.cfg
    sed -i 's~CFG_SPI= .*~CFG_SPI= native~' libloragw/library.cfg
    sed -i 's~/dev/spidev1.0~/dev/spidev0.0~' libloragw/inc/lorank.h
    sed -i 's~-fPIC~~g' libloragw/Makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $dev/include
    cp -a libloragw $dev/include/
    cp */util_* $out/bin
  '';

  meta = with lib; {
    description = "Driver for SX1301 based gateways";
    homepage = https://github.com/Lora-net/lora_gateway;
    maintainers = with maintainers; [ sorki ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
