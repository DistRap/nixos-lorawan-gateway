{ stdenv, fetchFromGitHub }:

let
  rev = "7c5caed";
in
stdenv.mkDerivation {
  name = "ail_gpio-${rev}";
  src = fetchFromGitHub {
    owner = "sorki";
    repo = "ail_gpio";
    inherit rev;
    sha256 = "1lpnhmsnqwrzdc2jkjcw47xniiwcc0z2vxs2m6pci4qzd9lwa1w9";
  };

  installPhase = ''
    mkdir -p $out
    cp ail_gpio $out/
    cp README.rst $out/
  '';

  meta = with stdenv.lib; {
    description = "Small bash wrapper over kernels GPIO sysfs interface";
    homepage = "https://github.com/sorki/ail_gpio";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ sorki ];
    platforms = platforms.linux;
  };
}
