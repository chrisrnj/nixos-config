{ inputs, pkgs, ... }:

{
  nix.settings = {
    trusted-substituters = [ "https://prismlauncher.cachix.org" ];

    trusted-public-keys = [
      "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c="
    ];
  };

  environment.systemPackages = [ inputs.prismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.prismlauncher ];
}
