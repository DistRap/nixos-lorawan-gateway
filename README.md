# NixOS LoRaWAN Gateway

## Build

```bash
NIX_PATH="$NIX_PATH:lorawan-gateway=$(pwd)" nix-build --cores 0 '<nixpkgs/nixos>' -I nixos-config=configs/testing.nix -A config.system.build.sdImage -o gw
```

## Flash

```bash
dd if=gw/sd-image/nixos-sd-image-*img of=/dev/mmcblkX bs=1M
```


