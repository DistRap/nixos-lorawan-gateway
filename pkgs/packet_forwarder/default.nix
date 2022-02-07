{ stdenv, lib, fetchFromGitHub, lora_gateway }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "packet_forwarder-${version}";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "TheThingsNetwork";
    repo = "packet_forwarder";
    rev = "90a1d7e1d2101689e4ec9b7d6bcd80f311fe9e25";
    sha256 = "0n77d9y8bkpk4pz66m24258zx8937qz1jv4cfll90sgvz093a2kh";
  };

  makeFlags = [ "CFG_SPI=native"
                "LGW_PATH=${lora_gateway.dev}/include/libloragw/" ];

  NIX_LDFLAGS = "-lm";

  installPhase = ''
    mkdir -p $out/bin
    cp *_pkt_fwd/*_pkt_fwd $out/bin/
    cp util_*/util_* $out/bin/
  '';

  meta = with lib; {
    description = "A LoRa packet forwarder";
    homepage = https://github.com/Lora-net/packet_forwarder;
    maintainers = with maintainers; [ sorki ];
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
