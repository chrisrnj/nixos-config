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

    proton-cachyos.url = "github:powerofthe69/proton-cachyos-nix";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher.url = "github:PrismLauncher/PrismLauncher";

#     librepods = {
#       url = "github:kavishdevar/librepods/linux/rust";
#       inputs.nixpkgs.follows = "nixpkgs";
#     };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations.Chris = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "x86_64-linux";
      modules = [
        ({
          networking.hostName = "Chris";

          services.xserver.xkb.layout = "br";

          console.keyMap = "br-abnt2";

          system.stateVersion = "25.11";
        })

        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nixpkgs-xr.nixosModules.nixpkgs-xr

        ./amdgpu
        ./secureboot
        ./kernels/cachyos-kernel.nix
        ./configuration.nix
      ];
    };
    nixosConfigurations.MacBook-Air-de-Christiano = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      system = "aarch64-linux";
      modules = [
        ({
          networking.hostName = "MacBook-Air-de-Christiano";

          services.xserver.xkb = {
            layout = "us";
            model = "apple";
            variant = "alt-intl";
          };

          console.keyMap = "us";

          system.stateVersion = "26.11";
        })

        inputs.apple-silicon.nixosModules.default

        ./asahi
        ./configuration.nix
      ];
    };
  };
}

