{ config, pkgs, lib, ... }:
with lib;

{
  options = {
    gw.pps = {
      enable = mkEnableOption "Enable PPS (Pulse Per Second) input";
      device = mkOption {
        type = types.str;
        default = "/dev/pps0";
        example = "/dev/pps0";
        description = "PPS device to use as a clock source";
      };
    };
  };

  config = mkIf config.gw.pps.enable {
    environment.systemPackages = with pkgs; [
      pps-tools
    ];
  };
}
