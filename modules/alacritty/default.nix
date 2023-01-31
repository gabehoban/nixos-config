{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.alacritty;

in {
  options.modules.alacritty = { enable = mkEnableOption "alacritty"; };
  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        bell = {
          animation = "EaseOutExpo";
          duration = 5;
          color = "#ffffff";
        };
        colors = {
          primary = {
            background = "#040404";
            foreground = "#c5c8c6";
          };
        };
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Medium";
          };
          size = 14;
        };
        selection.save_to_clipboard = true;
        shell.program = "${pkgs.zsh}/bin/zsh";
        window = {
          decorations = "full";
          opacity = 0.85;
          padding = {
            x = 10;
            y = 10;
          };
        };
      };
    };
  };
}
