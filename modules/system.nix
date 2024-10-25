{
  self,
  nixpkgs,
  ...
}: {
  nix.nixPath = ["nixpgks=${nixpkgs}"];

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;

  system.stateVersion = 5;

  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = "x86_64-darwin";
}
