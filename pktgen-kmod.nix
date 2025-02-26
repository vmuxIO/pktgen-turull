{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation rec {
  pname = "v4l2loopback-dc";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "aramg";
    repo = "droidcam";
    rev = "v${version}";
    hash = "sha256-3RmEmLNUbwIh+yr7vtYZnMwbzfmtW3mz5u4Ohau9OLU=";
  };

  sourceRoot = "source/linux/v4l2loopback";
  hardeningDisable = [ "pic" "format" ];                                             # 1
  nativeBuildInputs = kernel.moduleBuildDependencies;                       # 2

  makeFlags = [
    "KERNELRELEASE=${kernel.modDirVersion}"                                 # 3
    "KERNEL_DIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"    # 4
    "INSTALL_MOD_PATH=$(out)"                                               # 5
  ];

  meta = {
    description = "A kernel module to create V4L2 loopback devices";
    homepage = "https://github.com/aramg/droidcam";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.makefu ];
    platforms = lib.platforms.linux;
  };
}
