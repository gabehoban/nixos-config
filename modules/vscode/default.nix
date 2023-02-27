{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.vscode;

in {
  options.modules.vscode = { enable = mkEnableOption "vscode"; };
  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        antfu.icons-carbon
        arrterian.nix-env-selector
        christian-kohler.path-intellisense
        dbaeumer.vscode-eslint
        eamodio.gitlens
        hashicorp.terraform
        jnoortheen.nix-ide
        mikestead.dotenv
        mkhl.direnv
        ms-azuretools.vscode-docker
        ms-kubernetes-tools.vscode-kubernetes-tools
        ms-vscode.makefile-tools
        pkief.material-icon-theme
        redhat.vscode-xml
        redhat.vscode-yaml
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vscode-theme-onedark";
          publisher = "akamud";
          version = "2.3.0";
          sha256 = "1km3hznw8k0jk9sp3r81c89fxa311lc6gw20fqikd899pvhayqgh";
        }
        {
          name = "ansible";
          publisher = "redhat";
          version = "1.2.44";
          sha256 = "0a89c5g70wzwryvv5kmjjvja42wh0gfibna003x8z47a7sqkzxri";
        }
        {
          name = "signageos-vscode-sops";
          publisher = "signageos";
          version = "0.7.1";
          sha256 = "0n4z3s6wkx6dkigiarcrq8vslax045lm53chsilsxrfdq0232g72";
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
