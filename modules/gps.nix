{ config, pkgs, lib, ... }:
with lib;

{
  options = {
    gw.gps = {
      enable = mkEnableOption "Enable GPS(D)";
      device = mkOption {
        type = types.str;
        example = "/dev/ttyUSB0";
        default = "/dev/ttyUSB0";
      };
    };
  };

  config = mkIf config.gw.gps.enable {

    environment.systemPackages = with pkgs; [
      gpsd
    ];

    services.gpsd = {
      enable = true;
      nowait = true;
      device = config.gw.gps.device;
    };
  };
}
