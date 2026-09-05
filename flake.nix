{
  description = "My NixOS desktop.";

  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can this to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    apple-silicon.url = "github:nix-community/nixos-apple-silicon";

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    nixcord.url = "github:4evy/nixcord";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher.url = "github:PrismLauncher/PrismLauncher";
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.Chris = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";
      modules = [
        ({
          networking.hostName = "Chris";
        })

        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
        inputs.chaotic.nixosModules.default

        ./shared
        ./desktop
      ];
    };
    nixosConfigurations.MacBook-Air-de-Christiano = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "aarch64-linux";
      modules = [
        ({
          networking.hostName = "MacBook-Air-de-Christiano";
        })

        inputs.apple-silicon.nixosModules.default
        inputs.nixpkgs-xr.nixosModules.nixpkgs-xr

        ./shared
        ./laptop
      ];
    };
  };
}

