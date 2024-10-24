{
  description = "My Macbook Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    nix-homebrew,
  }: let
    configuration = {
      pkgs,
      config,
      nixpkgs,
      ...
    }: {
      # abilito anche i pacchetti non opensource (tipo obsidian)
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        alacritty
        alejandra # formatter di nix
        fzf
        mkalias
        nixd # language server per nix per vscode
        obsidian
        oh-my-posh
        rectangle
        stats
        stow
        tree
        utm
        vim
        vscode
      ];

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

      # Nerdfont
      # The nerdfonts repository is quite large and contains a large number of fonts
      # which take some time to install. If you only need a selection of fonts from
      # the package, you can overwrite the font selection
      fonts.packages = [
        (pkgs.nerdfonts.override {
          fonts = [
            "JetBrainsMono"
            "Meslo"
          ];
        })
      ];

      # Activation script to setup alias for GUI applications so that
      # spotlight can index them
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          # Set up applications.
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessario per far andare nixd in vscode
      nix.nixPath = ["nixpgks=${nixpkgs}"];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#macbook
    darwinConfigurations."macbook" = nix-darwin.lib.darwinSystem {
      modules = [
        {_module.args.nixpkgs = nixpkgs;} # add nixpkgs arg to args passed to each modules
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;
            # User owning the Homebrew prefix
            user = "enricomingardo";
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."macbook".pkgs;
  };
}
