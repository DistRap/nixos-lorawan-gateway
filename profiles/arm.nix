{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/profiles/base.nix"
  ];

  boot.supportedFilesystems = lib.mkForce [ "vfat" ];
  i18n.supportedLocales = lib.mkForce [ (config.i18n.defaultLocale + "/UTF-8") ];

  documentation.enable = false;
  documentation.nixos.enable = false;
  # this pulls too much graphical stuff
  services.udisks2.enable = lib.mkForce false;

  # this pulls spidermonkey and firefox
  security.polkit.enable = false;
}
