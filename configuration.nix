{ pkgs, config, nixpkgs, ... }: {
  imports = [
    ./modules/packages.nix
    ./modules/homebrew.nix
    ./modules/fonts.nix
    ./modules/system.nix
    ./modules/applications.nix
  ];
}