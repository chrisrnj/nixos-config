{ pkgs, lib, ... }:

{
  programs.chromium = {
    enable = true;
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://google.com/search?q={searchTerms}&{google:RLZ}{google:originalQueryForSuggestion}{google:assistedQueryStats}{google:searchFieldtrialParameter}{google:iOSSearchLanguage}{google:prefetchSource}{google:searchClient}{google:sourceId}{google:contextualSearchVersion}{google:instantExtendedEnabledParameter}ie={inputEncoding}";
    defaultSearchProviderSuggestURL = "https://www.google.com/complete/search?client=chrome&q=%s";
    extraOpts = {
      "ExtensionManifestV2Availability" = 2;
    };
  };

  environment.systemPackages = lib.singleton (pkgs.ungoogled-chromium.override {
    enableWideVine = true;
    commandLineArgs = [
      "--enable-features=AcceleratedVideoEncoder,AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE,VaapiVideoDecoder,VaapiVideoEncoder,PlatformHEVCDecoderSupport,UseMultiPlaneFormatForHardwareVideo,CanvasOopRasterization,UseOzonePlatform"
      "--ignore-gpu-blocklist"
      "--enable-zero-copy"
      "--use-vulkan"
      "--enable-gpu"
      "--enable-gpu-rasterization"
      "--canvas-oop-rasterization"
      "--enable-accelerated-mjpeg-decode"
      "--enable-global-vaapi-lock"
#       "--enable-blink-features=MiddleClickAutoscroll"
      "--use-gpu-scheduler-dfs"
      "--cast-streaming-hardware-h264"
    ];
  });
}
