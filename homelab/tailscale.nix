{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ tailscale ];

  services.tailscale.enable = true;
  services.tailscale.port = 51280;

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
