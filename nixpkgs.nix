# Update with
# $ nix-prefetch-git https://github.com/NixOS/nixpkgs --rev $REV --no-deepClone --leave-dotGit
let
  sysPkgs = import <nixpkgs> {};
  pinnedRepo = sysPkgs.fetchgit {
    url = "https://github.com/NixOS/nixpkgs";
    rev="2177c7f17b999133719c8de824f0caf31e991044";
    sha256="sha256-W0a+kyhdZdb3CdpqFcXk1GBtK0iuVchgtswgwCYwCLw=";
    leaveDotGit = true;
    deepClone = false;
  };
  withVersions = sysPkgs.runCommand "add-versions" {}
  ''
    mkdir $out
    shopt -s dotglob
    cp -a ${pinnedRepo}/* $out/
    chmod -R u+w $out/
    echo '25.05' > $out/.version
    rev="$( ${sysPkgs.git}/bin/git -C $out rev-parse --short HEAD )"
    echo ".git.$rev" > $out/.version-suffix
  '';
in
import ("${withVersions}/nixos")
