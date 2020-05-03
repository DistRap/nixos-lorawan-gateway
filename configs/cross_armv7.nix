{ config, lib, pkgs, ... }:
{
  imports = [
    <lorawan-gateway>
    ../profiles/raspberrypi.nix
  ];

  nixpkgs = {
    crossSystem.system = "armv7l-linux";
    overlays = [
    ];
  };

  environment.systemPackages = with pkgs; [
    libgpiod
  ];

  gw = {
    enable = true;
    id = "B827EBFFFE517AAA";
    contactEmail = "gw@example.org";
    description = "Test gateway";
    # XXX: gpsd
    gps.enable = false;
    # XXX: node_exporter
    mon.enable = false;
    # XXX: chrony
    # OPT.OBJ/Linux_SINGLE_SHLIB/gcm.o: in function `gcmHash_Reset':
    # gcm.c:(.text.gcmHash_Reset+0x88): undefined reference to `gcm_HashZeroX_hw'
    ntp = {
      enable = false;
    #  public = true;
    };
    pps.enable = true;
    # not sure if needed
    # tor.enable = true;
    wg = {
      enable = false;
      ip = "10.11.0.211/24";
    };

    customKernel = false;
    # perl or git doesn't cc?
    # develMode = true;
  };

  system.stateVersion = "20.03";

  users.extraUsers.root.openssh.authorizedKeys.keys = with (import ./ssh-keys.nix); [ srk adluc ];
}
