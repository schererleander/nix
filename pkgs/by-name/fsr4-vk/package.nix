{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  gitMinimal,
  python3,
  llvmPackages,
  vulkan-headers,
  vulkan-loader,
  zstd,
}:
let
  python = python3.withPackages (p: [ p.zstandard ]);
  # fsr4-vk verifies and translates the MIT-licensed SDK 2.3.0 shader/model
  # assets at build time. The Windows DLL is only an input, never installed.
  sdk = fetchurl {
    url = "https://raw.githubusercontent.com/GPUOpen-LibrariesAndSDKs/FidelityFX-SDK/60f4ea81909200d8542eca14dccb2628b763a9a3/Kits/FidelityFX/signedbin/amd_fidelityfx_upscaler_dx12.dll";
    hash = "sha256-0NzMx0pDxEukNbejabRW4JcNikRk5L1oMRmzdPLJ+0Y=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fsr4-vk";
  version = "0-unstable-2026-10-26";

  src = fetchFromGitHub {
    owner = "Astyyyyy";
    repo = "fsr4-vk";
    rev = "b0125ea9798633750f83ebabbc00279bcb49d8dd";
    fetchSubmodules = true;
    hash = "sha256-V9rwjTGt07bxGQz1wC0LLEOTdT/nF2xmTqUy5zblJVA=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    gitMinimal
    python
    llvmPackages.llvm
  ];
  buildInputs = [
    vulkan-headers
    vulkan-loader
    zstd
  ];

  # Keep the pinned shader tools: the asset catalog checks their exact output.
  patches = [ ./system-libraries.patch ];

  postPatch = ''
    substituteInPlace tools/convert/toolchain.py \
      --replace-fail '"--parallel", "4"' '"--parallel", os.environ["NIX_BUILD_CORES"]'
  '';

  preConfigure = ''
    # Build the pinned shader tools and verify the generated asset catalog.
    ${python.interpreter} tools/setup.py --dll ${sdk}
  '';
  cmakeFlags = [
    (lib.cmakeBool "FSR4_EMBEDDED_ASSETS" true)
    (lib.cmakeFeature "Vulkan_INCLUDE_DIR" "${lib.getDev vulkan-headers}/include")
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 amd_fidelityfx_upscaler_vk.so "$out/lib/amd_fidelityfx_upscaler_vk.so"
    mkdir -p "$out/share/doc/${finalAttrs.pname}"
    cp -r ../LICENSE ../LICENSES ../THIRD_PARTY_NOTICES.md ../README.md "$out/share/doc/${finalAttrs.pname}/"
    runHook postInstall
  '';

  meta = {
    description = "Vulkan implementation of AMD FidelityFX Super Resolution 4";
    homepage = "https://github.com/Astyyyyy/fsr4-vk";
    license = [
      lib.licenses.gpl3Only
      lib.licenses.mit
    ];
    # AMD's precompiled DXIL shaders are translated to SPIR-V during the build.
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    platforms = [ "x86_64-linux" ];
  };
})
