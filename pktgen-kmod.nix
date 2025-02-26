{ stdenv, lib, kernel }:

stdenv.mkDerivation rec {
  pname = "pktgen-kmod";
  version = "4.6";

  src = ./.;
  sourceRoot = ".";
  hardeningDisable = [ "pic" "format" ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    # "KERNELRELEASE=${kernel.modDirVersion}"
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KERNELDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  preBuild = ''
    cd *-source
  '';

  meta = {
    description = "Another version of the Linux pktgen kernel module";
    homepage = "https://people.kth.se/~danieltt/pktgen/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.pogobanane ];
    platforms = lib.platforms.linux;
  };
}
