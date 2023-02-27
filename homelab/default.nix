{ config, pkgs, ... }:
{
  imports = [ ./zerotier.nix ];

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
