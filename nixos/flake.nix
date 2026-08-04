{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    uwm.url = "path:/home/ak/projects/uwm";
  };

  outputs = { self, nixpkgs, uwm,...}:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./configuration.nix
	uwm.nixosModules.default

        {
          environment.systemPackages = [
          ];
        }
      ];
    };
  };
}
