{ config, pkgs, lib, modulesPath, ... }:
{
  imports = [
  ];

  disabledModules = [
    "${modulesPath}/profiles/all-hardware.nix"
    "${modulesPath}/profiles/base.nix"
  ];

  nixpkgs = {
    overlays = [
      # fix modules-shrunk fail
      # modprobe: FATAL: Module ahci not found in directory ...
      (final: super: {
         makeModulesClosure = x:
           super.makeModulesClosure (x // { allowMissing = true; });
      })
    ];
  };


  boot = {
    consoleLogLevel = lib.mkDefault 7;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    supportedFilesystems = [ "vfat" "ext4" ];

    initrd = {
      includeDefaultModules = lib.mkDefault false;
      kernelModules = [ "ext4" "mmc_block" ];
    };

    tmp.useTmpfs = true;
  };

  i18n.supportedLocales = lib.mkForce [ (config.i18n.defaultLocale + "/UTF-8") ];

  documentation = {
    enable = lib.mkDefault false;
    nixos.enable = lib.mkDefault false;
    info.enable = lib.mkDefault false;
    man.enable = lib.mkDefault false;
  };

  services.journald = {
    extraConfig = ''
      Storage=volatile
      FlushIntervalSec=0
    '';
  };

  # this pulls too much graphical stuff
  services.udisks2.enable = lib.mkForce false;

  # this pulls spidermonkey and firefox
  security.polkit.enable = lib.mkDefault false;

  # disable audit
  security.audit.enable = lib.mkDefault false;

  # disable containers
  boot.enableContainers = lib.mkDefault false;

  # don't include a 'command not found' helper
  programs.command-not-found.enable = lib.mkDefault false;
}

