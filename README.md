# NixOS LoRaWAN Gateway

## Build

```bash
NIX_PATH="$NIX_PATH:lorawan-gateway=$(pwd)/modules" nix-build --cores 0 \
  -I nixos-config=configs/cross_armv7.nix -A config.system.build.sdImage -o gw
```

## Flash

```bash
dd if=gw/sd-image/nixos-sd-image-*img of=/dev/mmcblkX bs=1M
```


