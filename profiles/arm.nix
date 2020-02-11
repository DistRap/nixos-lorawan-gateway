{ config, pkgs, lib, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/profiles/base.nix>
  ];

  boot.supportedFilesystems = lib.mkForce [ "vfat" ];
  i18n.supportedLocales = lib.mkForce [ (config.i18n.defaultLocale + "/UTF-8") ];

  documentation.enable = false;
  documentation.nixos.enable = false;
  services.udisks2.enable = lib.mkForce false;
}
