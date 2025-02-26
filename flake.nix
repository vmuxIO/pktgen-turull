{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    dotfiles.url = "github:pogobanane/dotfiles";
  };

  outputs = { self, nixpkgs, ... } @ inputs: let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      selfpkgs = self.packages.x86_64-linux;
    in {

    packages.x86_64-linux = {
      hello = nixpkgs.legacyPackages.x86_64-linux.hello;
      default = self.packages.x86_64-linux.hello;
      referenceKernel = inputs.dotfiles.nixosConfigurations.aenderpad.config.boot.kernelPackages.kernel;
      pktgen-kmod = pkgs.callPackage ./pktgen-kmod.nix {
        kernel = selfpkgs.referenceKernel;
      };
    };


    devShells.x86_64-linux = {
      hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    };

  };
}
