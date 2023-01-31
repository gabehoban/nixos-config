{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.gnome;

in {
  options.modules.gnome = { enable = mkEnableOption "gnome"; };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gnomeExtensions.dash-to-dock
      gnomeExtensions.blur-my-shell
    ];
    dconf.settings = {
      "org/gnome/shell" = {
        favorite-apps = [
          "org.gnome.Nautilus.desktop"
          "firefox.desktop"
          "Alacritty.desktop"
          "code.desktop"
        ];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///var/keys/wallpaper/cat.jpg";
        picture-uri-dark = "file:///var/keys/wallpaper/cat.jpg";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "user-theme@gnome-shell-extensions.gcampax.github.com"
          "dash-to-dock@micxgx.gmail.com"
          "blur-my-shell@aunetx"
        ];
      };
      "org/gnome/shell/extensions/blur-my-shell" = {
        hacks-level = 3;
      };
      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        enable-all = true;
        blacklist = [ "Team Fortress 2 - OpenGL" "hl2_linux" ];
      };
      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = true;
        customize = true;
        override-background = true;
        style-dash-to-dock = 2;
      };
      "org/gnome/settings-daemon/plugins/power" = {
        sleep-inactive-ac-timeout = 0;
        sleep-inactive-battery-timeout = 0;
      };
    };
  };
}
