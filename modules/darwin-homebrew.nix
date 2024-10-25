{...}: {
  homebrew = {
    # Enables nix-darwin to manage installing/updating/upgrading Homebrew taps,
    # formulae, and casks, as well as Mac App Store apps using Homebrew Bundle (Brewfile).
    enable = true;

    # "zap" -> uninstalls all formulae not listed in the generated Brewfile,
    # and if the formula is a cask, removes all files associated with that cask
    onActivation.cleanup = "zap";

    # Enables Homebrew to auto-update itself and all formulae when you manually
    # invoke commands like brew install, brew upgrade.
    # When disabled, this option sets the HOMEBREW_NO_AUTO_UPDATE
    global.autoUpdate = true;

    # Enables Homebrew to auto-update itself and all formulae during nix-darwin system activation
    onActivation.autoUpdate = true;

    # Enables Homebrew to upgrade outdated formulae and Mac App Store apps during nix-darwin system activation
    onActivation.upgrade = true; #

    brews = [
      # "mas" is automatically added when masApps is present
      # "mas"
    ];
    casks = [
      "1password"
      "alfred"
      "firefox"
      "freetube"
      "monitorcontrol"
    ];
    masApps = {
      "Pages" = 409201541;
      "1Password for Safari" = 1569813296;
    };
  };
}
