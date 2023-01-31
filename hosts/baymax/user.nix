{ config, lib, inputs, ... }:

{
  imports = [ ../../modules/default.nix ];
  config.modules = {
    # desktop
    gnome.enable = true;

    # gui
    firefox.enable = true;
    alacritty.enable = true;
    vscode.enable = true;
    obs-studio.enable = true;

    # cli
    zsh.enable = true;
    git.enable = true;
    gpg.enable = true;
    direnv.enable = true;

    # system
    packages.enable = true;
  };
}
