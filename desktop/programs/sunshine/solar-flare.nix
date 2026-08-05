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
  #
  # NOTE: verified against vindeckyy/Solar-Flare tag v2026.708.3-solarflare —
  # its third-party/build-deps submodule is still pinned to commit fce763bb,
  # i.e. the same "v2026.516.30821" tag used upstream, so this block is
  # unchanged from the LizardByte/Sunshine derivation. Re-check this any time
  # you bump to a newer Solar-Flare tag.
  buildDepsTag = "v2026.713.132551";
  ffmpegArch =
    {
      x86_64-linux = "Linux-x86_64";
    }
    .${stdenv.hostPlatform.system}
      or (throw "sunshine: unsupported system ${stdenv.hostPlatform.system} for prebuilt ffmpeg");
  ffmpegPrebuilt = fetchzip {
    url = "https://github.com/LizardByte/build-deps/releases/download/${buildDepsTag}/${ffmpegArch}-ffmpeg.tar.gz";
    # stripRoot defaults to true; the hash here matches what
    # `nix-prefetch-url --unpack` produces, so the updater can refresh it
    # with the built-in command (which also caches downloads by URL,
    # unlike the empty-hash trick).
    hash =
      {
        x86_64-linux = "sha256-nHL+JxxMbR5fva/w1tt0BqcDowSAojuV8504he/wbsg=";
      }
      .${stdenv.hostPlatform.system};
  };

in
stdenv'.mkDerivation (finalAttrs: {
  pname = "solarflare";
  version = "acc943036f264a80dd0b374cca3c0f293e2ff605";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "vindeckyy";
    repo = "Solar-Flare";
    rev = finalAttrs.version;
    # TODO: replace with the real hash. Run the build once with this
    # placeholder; nix will fail with a hash mismatch error that prints
    # the correct sha256-... value to paste in here. (No `nix` binary was
    # available in the environment this was drafted in, so it couldn't be
    # precomputed.)
    hash = "sha256-nW1o4dGj/j06MwvTbO9yGnoi4MyEq5LWa5jlP02uWyQ=";
    fetchSubmodules = true;
  };

  # build webui
  ui = buildNpmPackage {
    inherit (finalAttrs) src version;
    pname = "solarflare-ui";
    # TODO: the fork's package-lock.json pins different versions than
    # upstream (vue, vite, marked, date-fns, vite-plugin-ejs, and adds
    # @lucide/vue), so this MUST be recomputed — it will not match
    # upstream Sunshine's npmDepsHash. Same trick as above: build once
    # with lib.fakeHash and copy the reported hash in.
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

    # The remaining @VAR@ placeholders in the .desktop file (PROJECT_NAME,
    # PROJECT_DESCRIPTION, PROJECT_FQDN, SUNSHINE_DESKTOP_ICON,
    # CMAKE_INSTALL_FULL_DATAROOTDIR) are substituted by cmake's
    # configure_file(... @ONLY) during the build.
    substituteInPlace packaging/linux/dev.lizardbyte.app.Sunshine.desktop \
      --replace-fail '/usr/bin/env systemctl start --u app-@PROJECT_FQDN@' 'sunshine'

    substituteInPlace packaging/linux/app-dev.lizardbyte.app.Sunshine.service.in \
      --replace-fail '/bin/sleep' '${lib.getExe' coreutils "sleep"}'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    # glad's generator needs Jinja2 + setuptools at configure time;
    # GLAD_SKIP_PIP_INSTALL=ON tells cmake not to pip-install them.
    (python3.withPackages (ps: [
      ps.jinja2
      ps.setuptools
    ]))
    makeWrapper
  ]
  ++ lib.optionals isLinux [
    wayland-scanner
    shaderc # provides glslc, needed at configure time for shader compilation
    # Avoid fighting upstream's usage of vendored ffmpeg libraries
    autoPatchelfHook
    # wraps $out/bin/sunshine with QT_PLUGIN_PATH etc. so the Qt-based tray
    # icon (svg icon engine, platform plugin) can find its plugins at runtime
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
    # required by third-party/tray's Qt-based Linux backend (see qt6 note above)
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
    # avoid cmake's network download of the LizardByte/build-deps ffmpeg tarball
    (lib.cmakeFeature "FFMPEG_PREPARED_BINARIES" "${ffmpegPrebuilt}")
    # we provide Jinja2/setuptools via python3.withPackages; don't pip-install
    (lib.cmakeBool "GLAD_SKIP_PIP_INSTALL" true)
  ]
  # upstream tries to use systemd and udev packages to find these directories in FHS; set the paths explicitly instead
  ++ lib.optionals isLinux [
    (lib.cmakeBool "UDEV_FOUND" true)
    (lib.cmakeBool "SYSTEMD_FOUND" true)
    (lib.cmakeFeature "UDEV_RULES_INSTALL_DIR" "lib/udev/rules.d")
    (lib.cmakeFeature "SYSTEMD_USER_UNIT_INSTALL_DIR" "lib/systemd/user")
    (lib.cmakeFeature "SYSTEMD_MODULES_LOAD_DIR" "lib/modules-load.d")
    # used in the generated systemd unit's ExecStart= line
    (lib.cmakeFeature "SUNSHINE_EXECUTABLE_PATH" "${placeholder "out"}/bin/sunshine")
  ]
  ++ lib.optionals (!cudaSupport) [
    (lib.cmakeBool "SUNSHINE_ENABLE_CUDA" false)
  ];

  env = {
    # needed to trigger CMake version configuration
    BUILD_VERSION = finalAttrs.version;
    BRANCH = "master";
    COMMIT = finalAttrs.src.rev;
  };

  # copy webui where it can be picked up by build
  preBuild = ''
    cp -r ${finalAttrs.ui}/build ../
  '';

  buildFlags = [
    "sunshine"
  ];

  # redefine installPhase to avoid attempt to build webui
  installPhase = ''
    runHook preInstall

    cmake --install .

    runHook postInstall
  '';

  # allow Sunshine to find libvulkan
  postFixup = lib.optionalString cudaSupport ''
    wrapProgram $out/bin/sunshine \
      --set LD_LIBRARY_PATH ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  doInstallCheck = isLinux;

  nativeInstallCheckInputs = lib.optionals isLinux [ udevCheckHook ];

  passthru = {
    tests = { inherit (nixosTests) sunshine; };
    # NOTE: upstream's updater.sh is written for LizardByte/Sunshine's
    # release cadence and tag naming ("v<version>"). Solar-Flare tags look
    # like "v<version>-solarflare" and there's no equivalent update
    # automation for the fork yet, so this will need a bespoke script (or
    # manual bumps) rather than reusing the inherited one as-is.
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
    # Upstream builds on Linux and Darwin; Solar-Flare's docs explicitly say
    # Windows/macOS/Intel/ARM are unsupported and its compiler flags target
    # AMD Zen (-march=znverN). Restricting to Linux here rather than leaving
    # isDarwin branches that the fork doesn't claim to support.
    platforms = lib.platforms.linux;
  };
})
