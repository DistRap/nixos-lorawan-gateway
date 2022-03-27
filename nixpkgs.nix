# Update with
# $ nix-prefetch-git https://github.com/sorki/nixpkgs --rev $REV --no-deepClone --leave-dotGit
# # TODO: drop when upstreamed
# $ nix-prefetch-git https://github.com/NixOS/nixpkgs --rev $REV --no-deepClone --leave-dotGit
let
  sysPkgs = import <nixpkgs> {};
  pinnedRepo = sysPkgs.fetchgit {
    url = "https://github.com/sorki/nixpkgs"; # extlinux-menu
    rev="9403d66b9002c5ca361251643b16fba741d53540";
    sha256 = "018fcn1qws1g8svqqd4d12dprz3rdnjngx0xk7gv62nz30dhlsb4";
    leaveDotGit = true;
    deepClone = false;
  };
  withVersions = sysPkgs.runCommand "add-versions" {}
  ''
    mkdir $out
    shopt -s dotglob
    cp -a ${pinnedRepo}/* $out/
    chmod -R u+w $out/
    echo '22.05' > $out/.version
    rev="$( ${sysPkgs.git}/bin/git -C $out rev-parse --short HEAD )"
    echo ".git.$rev" > $out/.version-suffix
  '';
in
import ("${withVersions}/nixos")
