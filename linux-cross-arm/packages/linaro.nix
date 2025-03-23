{ stdenv
,...
}:
let
  # Version specific settings
  version = "14.0-2023.06-1";
  url = arch: let
    url = "https://snapshots.linaro.org/gnu-toolchain/14.0-2023.06-1/arm-linux-gnueabihf/";
    filename = "gcc-linaro-14.0.0-2023.06-${arch}_arm-linux-gnueabihf.tar.xz";
  in
    "${url}${filename}";

  # Build the URL
  sources = {
    x86_64-linux = {
      url = url "x86_64";
      sha256 = "1gy2j5hd7nsycr0g7yci654a51czd9jqmi73a5r2is4vrjym1brb";
    };
    aarch64-linux = {
      url = url "aarch64";
      sha256 = "1gy2j5hd7nsycr0g7yci654a51czd9jqmi73a5r2is4vrjym1brb";
    };
  };

  source = sources.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  name = "gcc-linaro-14";
  inherit version;
  
  src = builtins.fetchTarball source;

  # We don't need to build because we're downloading prebuilt binaries
  dontBuild = true;
  
  # TODO check to see if these hooks work
  installPhase = ''
    # runHook preInstall
    mkdir -p $out
    cp -r . $out
    # runHook postInstall
  '';
}
