{ config, pkgs, lib, ... }:
with lib;

{
  imports = [
    ./gps.nix
    ./kernel.nix
    ./mon.nix
    ./ntp.nix
    ./packet_forwarder.nix
    ./pps.nix
    ./tor.nix
    ./wg.nix
  ];

  options = {
    gw = {
      enable = mkEnableOption "Enable LoRaWAN gateway";
      id = mkOption {
        type = types.str;
        example = "B827EBFFFE517AAA";
      };
      contactEmail = mkOption {
        type = types.str;
        example = "no@example.org";
      };
      description = mkOption {
        type = types.str;
        example = "Example gateway";
      };
      develMode = mkOption {
        type = types.bool;
        description = "Use for development only to e.g. autologin root";
        default = false;
      };
    };
  };

  config = mkMerge [
    (mkIf config.gw.enable {

      nixpkgs.overlays = [
        (import ../overlay.nix)
      ];

      gw.ntp.enable = mkDefault true;
      services.openssh.enable = true;

      environment.systemPackages = with pkgs; [
        packet_forwarder
        lora_gateway
      ];

      networking.packet_forwarder = {
        enable = true;
        gwid = config.gw.id;
        contact_email = config.gw.contactEmail;
        description = config.gw.description;
      };
    })

    (mkIf config.gw.develMode {
      services.openssh.permitRootLogin = "yes";
      services.mingetty.autologinUser = "root";

      users.extraUsers.root.initialHashedPassword = "";

      environment.systemPackages = with pkgs; [
        git
        vim
        stdenv
        stdenvNoCC
      ];

      warnings = lib.singleton ''
        Development mode enabled
      '';
    })
  ];
}
