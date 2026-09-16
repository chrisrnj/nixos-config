{ pkgs, lib, ... }:

{
  programs.chromium = {
    enable = true;
    enablePlasmaBrowserIntegration = true;
#     extensions = [
#       "cjpalhdlnbpafiamejdnhcphjbkeiagm" #uBlock Origin
#       "enamippconapkdmgfgjchkhakpfinmaj" #DeArrow
#       "mnjggcdmjocbbbhaepdhchncahnbgone" #SponsorBlock
#       "jinjaccalgkegednnccohejagnlnfdag" #Violentmonkey
#       "fadndhdgpmmaapbmfcknlfgcflmmmieb" #FrankerFaceZ
#     ];
    extraOpts = {
      "BrowserSignin" = 0;
      "SyncDisabled" = true;
      "PasswordManagerEnabled" = false;
      "SpellcheckEnabled" = true;
      "SpellcheckLanguage" = [
        "pt-BR"
        "en-US"
      ];
      "DnsOverHttpsMode" = "auto";
    };
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
      "--enable-zero-copy"
      "--enable-features=AcceleratedVideoEncoder,VaapiVideoDecoder,VaapiIgnoreDriverChecks,Vulkan,DefaultANGLEVulkan,VulkanFromANGLE,EnableTabMuting"
#       "--enable-blink-features=MiddleClickAutoscroll"
    ];
  });
}
