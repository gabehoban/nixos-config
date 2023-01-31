{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.packages;
in {
  options.modules.packages = { enable = mkEnableOption "packages"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      age
      ansible
      asciinema
      bat
      bc
      curl
      e2fsprogs
      exa
      ffmpeg
      fzf
      git
      gnupg
      htop
      imagemagick
      imagemagick
      jq
      libnotify
      lutris
      mpv
      nano
      neofetch
      nixpkgs-fmt
      nmap
      perl
      python3
      ripgrep
      rsync
      tree
      unzip
      wget
      whois
      zip
    ];
  };
}
