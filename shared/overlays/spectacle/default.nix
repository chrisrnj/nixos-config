final: prev:
{
  kdePackages = prev.kdePackages.overrideScope (
    kdeFinal: kdePrev: {
      # https://github.com/NixOS/nixpkgs/issues/491913
      spectacle = kdePrev.spectacle.override {
        tesseractLanguages = [
          "eng"
          "jpn"
          "jpn_vert"
          "rus"
          "por"
          # UPD: you can also specify null, which seems to prevent rebuilds:
          # https://github.com/NixOS/nixpkgs/issues/315039#issuecomment-2598883311
        ];
      };
    }
  );
}
