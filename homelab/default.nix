{ config, pkgs, ... }:
{
  imports = [ ./tailscale.nix ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
