{ config, pkgs, lib, ... }:
with lib;

{
  options = {
    gw.customKernel = mkEnableOption "Enable customized kernel";
  };

  config = {

    hardware.deviceTree.kernelPackage = pkgs.linux_latest;
    hardware.deviceTree.filter = "*rpi*.dtb";
    hardware.deviceTree.overlays = [
      { name = "pps"; dtsFile = ./dts/pps.dts; }
      { name = "spi"; dtsFile = ./dts/spi.dts; }
      { name = "example"; dtsFile = ./dts/example.dts; }
    ];
  
    boot.consoleLogLevel = lib.mkDefault 7;
    boot.kernelPackages = pkgs.linuxPackages_latest;
    boot.kernelPatches = lib.optional config.gw.customKernel [
       { name = "We need spidev for now";
         patch = (pkgs.fetchpatch {
           url = "https://github.com/sorki/linux/compare/v5.5...dont_bug_on_spidev_v5.5.patch";
           sha256 = "0ym377nv0c1mf1fxx4d2wnmn8nan1h5mv7ic39icxdp97cg1i4lb";
         });
       }
       {
         name = "gpio-sysfs-config";
         patch = null;
         extraConfig = ''
           CONFIG_GPIO_SYSFS y
         '';
       }
       {
         name = "dontwastemytime-config";
         patch = null;
         extraConfig = ''
           DRM n
           SOUND n
           VIRTUALIZATION n
         '';
       } 
    ];
  };
}

# nix dts
  /*
      dtsText = ''
        /dts-v1/;
        /plugin/;
        
        / {
        	compatible = "raspberrypi";
        	fragment@0 {
        		target = <&spi>;
        		__overlay__ {
        			cs-gpios = <&gpio 8 1>, <&gpio 7 1>;
        			status = "okay";
        			pinctrl-names = "default";
        			pinctrl-0 = <&spi0_pins &spi0_cs_pins>;
        			#address-cells = <1>;
        			#size-cells = <0>;
        			spidev@0 {
        				reg = <0>;	// CE0
        				spi-max-frequency = <500000>;
        				compatible = "spidev";
        			};
        
        			spidev@1 {
        				reg = <1>;	// CE1
        				spi-max-frequency = <500000>;
        				compatible = "spidev";
        			};
        		};
        	};
                fragment@1 {
        		target = <&alt0>;
        		__overlay__ {
        			// Drop GPIO 7, SPI 8-11 
        			brcm,pins = <4 5>;
        		};
        	};
        
        	fragment@2 {
        		target = <&gpio>;
        		__overlay__ {
        			spi0_pins: spi0_pins {
        				brcm,pins = <9 10 11>;
        				brcm,function = <4>; // alt0
        			};
        			spi0_cs_pins: spi0_cs_pins {
        				brcm,pins = <8 7>;
        				brcm,function = <1>; // out
        			};
        		};
        	};
        };
      '';
    }
/*
    { name = "pps"; 
      dtsText = ''
	/dts-v1/;
	/plugin/;
	
	/ {
	        compatible = "raspberrypi";
	        fragment@0 {
	                target-path = "/soc";
	                __overlay__ {
	                        pps {
	                                compatible = "pps-gpio";
	                                status = "okay";
	                                pinctl-name = "default";
	                                pinctrl-0 = <&pps_pins>;
	                                gpios = <&gpio 18 0>;
	                                assert-falling-edge;
	                        };
	                };
	        };
	        fragment@1 {
	                target = <&gpio>;
	                __overlay__ {
	                        pps_pins: pps_pins {
	                                brcm,pins = <18>;
	                                brcm,function = <0>; // input
	                                brcm,pull = <0>;    // off
	                        };
	                };
	        };
        };
      '';
    }
*/

