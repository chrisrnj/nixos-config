final: prev:
{
  kdePackages = prev.kdePackages.overrideScope (
    kdeFinal: kdePrev: {
      skanpage = kdePrev.skanpage.override {
        tesseractLanguages = [
          "por"
          "eng"
        ];
      };
    }
  );
}
