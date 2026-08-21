{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchzip,
  autoPatchelfHook,
  autoAddDriverRunpath,
  makeWrapper,
  buildNpmPackage,
  nixosTests,
  cmake,
  avahi,
  libevdev,
  libpulseaudio,
  libxtst,
  libxrandr,
  libxi,
  libxfixes,
  libxdmcp,
  libx11,
  libxcb,
  openssl,
  libopus,
  boost,
  pkg-config,
  libdrm,
  wayland,
  wayland-scanner,
  libffi,
  libcap,
  libgbm,
  curl,
  pcre2,
  python3,
  libuuid,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxkbcommon,
  libepoxy,
  libva,
  libvdpau,
  libglvnd,
  numactl,
  amf-headers,
  svt-av1,
  shaderc,
  vulkan-loader,
  libappindicator,
  libnotify,
  pipewire,
  miniupnpc,
  nlohmann_json,
  config,
  coreutils,
  udevCheckHook,
  # Solar-Flare pins a newer LizardByte/tray submodule (8ea4c683) than
  # upstream Sunshine (563dee47). That newer tray switched its Linux
  # backend from libappindicator/libnotify to Qt6 (falling back to Qt5
  # if Qt6 isn't found) — see third-party/tray/CMakeLists.txt. Without
  # these, configure fails with "Could not find a package configuration
  # file provided by Qt6"/"Qt5".
  qt6,
  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}:
let
  inherit (stdenv.hostPlatform) isLinux;
  stdenv' = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  # Upstream's cmake fetches a pre-built ffmpeg from LizardByte/build-deps at
  # configure time. We can't do network I/O during the build, so fetch it via
  # a fixed-output derivation and point cmake at it via FFMPEG_PREPARED_BINARIES.
  # The tag must match the commit of the third-party/build-deps submodule pinned
  # in the release being built.
  buildDepsTag = "v2026.713.132551";
  ffmpegArch =
    {
      x86_64-linux = "Linux-x86_64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "sunshine: unsupported system ${stdenv.hostPlatform.system} for prebuilt ffmpeg");
  ffmpegPrebuilt = fetchzip {
    url = "https://github.com/LizardByte/build-deps/releases/download/${buildDepsTag}/${ffmpegArch}-ffmpeg.tar.gz";
    hash =
      {
        x86_64-linux = "sha256-nHL+JxxMbR5fva/w1tt0BqcDowSAojuV8504he/wbsg=";
      }
      .${stdenv.hostPlatform.system};
  };

in
stdenv'.mkDerivation (finalAttrs: {
  pname = "solarflare";
  version = "2026.809.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "vindeckyy";
    repo = "Solar-Flare";
    # IMPORTANT: use `tag`, not `rev`, when fetchSubmodules = true. fetchgit
    # resolves `tag` to the fully-qualified "refs/tags/<tag>" before fetching;
    # a bare `rev` string that isn't a 40-char commit SHA is passed through
    # unqualified, and in practice that made the submodule-update step of
    # the fetch come back empty (third-party/tray, moonlight-common-c,
    # Simple-Web-Server, libdisplaydevice, glad all ended up with no content,
    # even though the top-level repo files were fetched fine) — while still
    # being deterministic enough to pass hash verification on retries.
    # See pkgs/build-support/fetchgit/default.nix in nixpkgs.
    rev = "bcac0d42bb41dffd33aa76cd9f82d44248be824c";
    # TODO: recompute. The old hash was captured against the broken
    # (submodule-less) `rev`-based fetch and will NOT match this `tag`-based
    # fetch. Build once with lib.fakeHash and paste in the real value from
    # the mismatch error.
    hash = "sha256-2gbWXJqMthmbEsNu74M4aZ7+kQsnDfRLEmYT5s0RMp8=";
    fetchSubmodules = true;
  };

  # build webui
  ui = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "solarflare-ui";
    # Root-level files (incl. package-lock.json) were unaffected by the
    # rev/tag submodule bug above, so this hash should still be valid for
    # this tag -- but double check it if the build fails here too.
    npmDepsHash = "sha256-Thcak0RNB+4tvd2m1oMSP6zj92ioGLBfCbin839xfPk=";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out"
      cp -a . "$out"/

      runHook postInstall
    '';
  };

  postPatch = # don't look for npm since we build webui separately
  ''
    substituteInPlace cmake/targets/common.cmake \
      --replace-fail 'find_program(NPM npm REQUIRED)' ""
  ''
  # use system boost instead of FetchContent.
  # FETCH_CONTENT_BOOST_USED prevents Simple-Web-Server from re-finding boost
  + ''
    sed -i -E 's/set\(BOOST_VERSION "[^"]*"\)/set(BOOST_VERSION "${boost.version}")/' \
      cmake/dependencies/Boost_Sunshine.cmake
    echo 'set(FETCH_CONTENT_BOOST_USED TRUE)' >> cmake/dependencies/Boost_Sunshine.cmake
  ''
  # remove upstream dependency on systemd and udev
  + lib.optionalString isLinux ''
    substituteInPlace cmake/packaging/linux.cmake \
      --replace-fail 'find_package(Systemd)' "" \
      --replace-fail 'find_package(Udev)' ""

    substituteInPlace packaging/linux/dev.lizardbyte.app.Sunshine.desktop \
      --replace-fail '/usr/bin/env systemctl start --u app-@PROJECT_FQDN@' 'sunshine'

    substituteInPlace packaging/linux/app-dev.lizardbyte.app.Sunshine.service.in \
      --replace-fail '/bin/sleep' '${lib.getExe' coreutils "sleep"}'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    (python3.withPackages (ps: [
      ps.jinja2
      ps.setuptools
    ]))
    makeWrapper
  ]
  ++ lib.optionals isLinux [
    wayland-scanner
    shaderc
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
    cudaPackages.cuda_nvcc
    (lib.getDev cudaPackages.cuda_cudart)
  ];

  buildInputs = [
    boost
    curl
    miniupnpc
    nlohmann_json
    openssl
    libopus
  ]
  ++ lib.optionals isLinux [
    avahi
    libevdev
    libpulseaudio
    libx11
    libxcb
    libxfixes
    libxrandr
    libxtst
    libxi
    libdrm
    wayland
    libffi
    libevdev
    libcap
    libdrm
    pcre2
    libuuid
    libselinux
    libsepol
    libthai
    libdatrie
    libxdmcp
    libxkbcommon
    libepoxy
    libva
    libvdpau
    numactl
    libgbm
    amf-headers
    svt-av1
    vulkan-loader
    pipewire
    libappindicator
    libnotify
    qt6.qtbase
    qt6.qtsvg
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
  ];

  runtimeDependencies = lib.optionals isLinux [
    avahi
    libgbm
    libxrandr
    libxcb
    libglvnd
  ];

  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeBool "BOOST_USE_STATIC" false)
    (lib.cmakeBool "BUILD_DOCS" false)
    (lib.cmakeFeature "SUNSHINE_PUBLISHER_NAME" "nixpkgs")
    (lib.cmakeFeature "SUNSHINE_PUBLISHER_WEBSITE" "https://nixos.org")
    (lib.cmakeFeature "SUNSHINE_PUBLISHER_ISSUE_URL" "https://github.com/vindeckyy/Solar-Flare/issues")
    (lib.cmakeFeature "FFMPEG_PREPARED_BINARIES" "${ffmpegPrebuilt}")
    (lib.cmakeBool "GLAD_SKIP_PIP_INSTALL" true)
  ]
  ++ lib.optionals isLinux [
    (lib.cmakeBool "UDEV_FOUND" true)
    (lib.cmakeBool "SYSTEMD_FOUND" true)
    (lib.cmakeFeature "UDEV_RULES_INSTALL_DIR" "lib/udev/rules.d")
    (lib.cmakeFeature "SYSTEMD_USER_UNIT_INSTALL_DIR" "lib/systemd/user")
    (lib.cmakeFeature "SYSTEMD_MODULES_LOAD_DIR" "lib/modules-load.d")
    (lib.cmakeFeature "SUNSHINE_EXECUTABLE_PATH" "${placeholder "out"}/bin/sunshine")
  ]
  ++ lib.optionals (!cudaSupport) [
    (lib.cmakeBool "SUNSHINE_ENABLE_CUDA" false)
  ];

  env = {
    BUILD_VERSION = finalAttrs.version;
    BRANCH = "master";
    COMMIT = finalAttrs.src.rev;
  };

  preBuild = ''
    cp -r ${finalAttrs.ui}/build ../
  '';

  buildFlags = [
    "sunshine"
  ];

  installPhase = ''
    runHook preInstall

    cmake --install .

    runHook postInstall
  '';

  postFixup = lib.optionalString cudaSupport ''
    wrapProgram $out/bin/sunshine \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  doInstallCheck = isLinux;

  nativeInstallCheckInputs = lib.optionals isLinux [ udevCheckHook ];

  passthru = {
    tests = { inherit (nixosTests) sunshine; };
    updateScript = ./updater.sh;
  };

  meta = {
    description = "Game stream host for Moonlight, forked from Sunshine with AMD Ryzen/Linux-specific latency tuning (vindeckyy/Solar-Flare)";
    homepage = "https://github.com/vindeckyy/Solar-Flare";
    changelog = "https://github.com/vindeckyy/Solar-Flare/blob/master/docs/CHANGELOG-SolarFlare.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "sunshine";
    maintainers = with lib.maintainers; [
      devusb
      anish
    ];
    platforms = lib.platforms.linux;
  };
})
