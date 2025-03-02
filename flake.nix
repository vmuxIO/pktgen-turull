{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    # kernels to build against:
    dotfiles.url = "github:pogobanane/dotfiles";
    doctor-cluster-config.url = "github:TUM-DSE/doctor-cluster-config";
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      selfpkgs = self.packages.x86_64-linux;
    in {

    packages.x86_64-linux = {
      default = selfpkgs.pktgen-kmod;

      referenceKernel = inputs.dotfiles.nixosConfigurations.aenderpad.config.boot.kernelPackages.kernel;
      pktgen-kmod = pkgs.callPackage ./pktgen-kmod.nix {
        kernel = selfpkgs.referenceKernel;
      };

      referenceKernel2 = inputs.doctor-cluster-config.nixosConfigurations.amy.config.boot.kernelPackages.kernel;
      pktgen-kmod2 = pkgs.callPackage ./pktgen-kmod.nix {
        kernel = selfpkgs.referenceKernel2;
      };

      referenceKernel3 = inputs.doctor-cluster-config.nixosConfigurations.adelaide.config.boot.kernelPackages.kernel;
      pktgen-kmod3 = pkgs.callPackage ./pktgen-kmod.nix {
        kernel = selfpkgs.referenceKernel3;
      };
    };


    devShells.x86_64-linux = {
      default = selfpkgs.pktgen-kmod;
    };

    checks.x86_64-linux = let
        blacklistPackages = [  ];
        packages = pkgs.lib.mapAttrs' (n: pkgs.lib.nameValuePair "package-${n}") (pkgs.lib.filterAttrs (n: _v: !(builtins.elem n blacklistPackages)) self.packages.x86_64-linux);
      in packages;

  };
}
