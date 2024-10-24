{
  description = "My Macbook Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = {
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
  }: {
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [
        {_module.args.nixpkgs = nixpkgs;}
        {_module.args.self = self;}
        ./configuration.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = "enricomingardo";
          };
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."macbook".pkgs;
  };
}
