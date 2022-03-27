{ config, pkgs, lib, ... }:
with lib;

{
  options = {
    gw.tor = {
      enable = mkEnableOption "Enable TOR client";
    };
  };

  config = mkIf config.gw.tor.enable {
    services.tor = {
      enable = true;
      relay.onionServices."lorawangw".map = [
        { port = 22; }
      ];
    };
  };
}
