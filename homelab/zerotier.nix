{ config, pkgs, ... }:
{

  age.secrets.zerotier.file = ../private/zerotier.age;

  services.zerotierone = {
    enable = true;
    joinNetworks = [ (builtins.readFile config.age.secrets.zerotier.path) ];
  };
  networking.nameservers = [ "5.161.194.92" ];
}
