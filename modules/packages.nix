{pkgs, ...}: {
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
}
