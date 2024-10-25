{...}: {
  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;
    # User owning the Homebrew prefix
    user = "enricomingardo";
  };
}
