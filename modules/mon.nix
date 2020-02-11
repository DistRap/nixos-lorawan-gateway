{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.gw.mon;
in
{
  options = {
    gw.mon = {
      enable = mkEnableOption "Enable gateway monitoring";
      /*
      public = mkOption {
        type = types.bool;
        default = false;
        description = "Expose as public NTP server";
      };
      */
    };
  };

  config = mkIf cfg.enable {
    services.prometheus.exporters = {
      node = {
        enable = true;
      };
    };
    #networking.firewall.allowedUDPPorts = optional cfg.public [ 123 ];
  };
}
