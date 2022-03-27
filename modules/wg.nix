/*
# gen key with
GWID="B827EBFFFE517AAA"
nix-shell -p wireguard
umask 077
cd secrets/wireguard-keys/
mkdir $GWID
pushd $GWID
wg genkey > private
wg pubkey < private > public
popd
*/
{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.gw.wg;
in
{
  options = {
    gw.wg = {
      enable = mkEnableOption "Enable my wireguard";
      ips = mkOption {
        type = types.listOf types.str;
      };
      endpoint = mkOption {
        type = types.str;
        default = "devzero.48.io:46666";
        example = "wireguard.example.org:45666";
      };
      pubkey = mkOption {
        type = types.str;
        default = "jzHK9nCUQ7lNiphj6s9zYisk4b/9TLDLJ0izi17pXT0=";
        example = "jzHK9nCUQ7lNiphj6s9zYisk4b/9TLDLJ0izi17pXT0=";
      };
      privkeyDir = mkOption {
        type = types.str;
        default = "../secrets/wireguard-keys";
      };
      allowedIPs = mkOption {
        type = types.listOf types.str;
        default = [ "10.11.0.0/24" ];
        example = [ "10.11.0.0/24" ];
      };
    };
  };

  config = mkIf cfg.enable {
    networking.wireguard.interfaces = {
      wg0 = {
        ips = cfg.ips;
        privateKey = builtins.readFile ./${cfg.privkeyDir}/${config.gw.id}/private;
        peers = [
          { publicKey  = cfg.pubkey;
            allowedIPs = cfg.allowedIPs;
            endpoint   = cfg.endpoint;
            persistentKeepalive = 25;
          }
        ];
      };
    };
  };
}

