{ inputs, pkgs, config, ... }:

{
  home.stateVersion = "21.03";
  imports = [
    # desktop
    ./gnome

    # gui
    ./firefox
    ./alacritty
    ./vscode

    # cli
    ./zsh
    ./git
    ./gpg
    ./direnv

    # system
    ./packages
  ];
}
