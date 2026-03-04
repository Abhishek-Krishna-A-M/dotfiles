{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    thorium.url = "github:Rishabh5321/thorium_flake";
  };

  outputs = { self, nixpkgs, thorium }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./configuration.nix

        {
          environment.systemPackages = [
            thorium.packages.${system}.thorium-avx2
          ];
        }
      ];
    };
  };
}
