{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.git;

in {
  options.modules.git = { enable = mkEnableOption "git"; };
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "gabehoban";
      userEmail = "gabehoban1@posteo.de";
      signing = {
        signByDefault = true;
        key = "0x760B6D73F873D579";
      };
      extraConfig = {
        init = { defaultBranch = "main"; };
      };
    };
  };
}
