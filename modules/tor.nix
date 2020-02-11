{ config, pkgs, lib, ... }:
with lib;

{
  options = {
    gw.tor = {
      enable = mkEnableOption "Enable TOR client";
    };
  };

  config = mkIf config.gw.tor.enable {
    services.tor.enable = true;
    services.tor.extraConfig = ''
      HiddenServiceDir /var/lib/tor/hidden_ssh/
      HiddenServicePort 22 127.0.0.1:22
    '';
  };
}
