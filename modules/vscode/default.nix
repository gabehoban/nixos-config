{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.vscode;

in {
  options.modules.vscode = { enable = mkEnableOption "vscode"; };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        jnoortheen.nix-ide
        arrterian.nix-env-selector
        mkhl.direnv
        mikestead.dotenv
        antfu.icons-carbon
        eamodio.gitlens
        dbaeumer.vscode-eslint
        redhat.vscode-yaml
        redhat.vscode-xml
        christian-kohler.path-intellisense
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-theme-onedark";
          publisher = "akamud";
          version = "2.3.0";
          sha256 = "1km3hznw8k0jk9sp3r81c89fxa311lc6gw20fqikd899pvhayqgh";
        }
        {
          name = "material-icon-theme";
          publisher = "PKief";
          version = "4.23.1";
          sha256 = "16z0c79gqvkdiwpijp5qg9xan2z3nhpw197jqh0g62gskpm95wh5";
        }
      ];
      userSettings = {
        "editor.fontFamily" = "'JetBrainsMono Nerd Font'";
        "editor.fontSize" = 14;
        "workbench.colorTheme" = "Atom One Dark";
        "workbench.productIconTheme" = "icons-carbon";
        "workbench.iconTheme" = "material-icon-theme";
        "editor.tabSize" = 2;
        "editor.formatOnSave" = true;
        "window.zoomLevel" = 1;
      };
    };
  };
}
