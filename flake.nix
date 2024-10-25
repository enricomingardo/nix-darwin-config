{
  description = "Enrico's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = {
    self,
    nixpkgs,
    nix-darwin,
    nix-homebrew,
    ...
  }: {
    darwinConfigurations = {
      "enrico" = nix-darwin.lib.darwinSystem {
        modules = [
          # Pass self and nixpkgs to the modules
          {_module.args.self = self;}
          {_module.args.nixpkgs = nixpkgs;}

          # various settings
          ./modules/system.nix

          # packages installed via nixpkgs
          ./modules/packages.nix

          # fonts
          ./modules/fonts.nix

          # nix-homebrew options manage Homebrew itself (installation, ownership, etc.)
          nix-homebrew.darwinModules.nix-homebrew
          ./modules/nix-homebrew.nix

          # nix-darwin homebrew options manage what gets installed through Homebrew
          # brews, casks, mas apps
          ./modules/darwin-homebrew.nix

          # Activation script to setup alias for GUI applications
          ./modules/app-aliasing.nix
        ];
      };
    };
  };
}
