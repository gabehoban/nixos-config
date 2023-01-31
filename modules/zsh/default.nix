{ pkgs, lib, config, ... }:
with lib;
let cfg = config.modules.zsh;
in {
  options.modules.zsh = { enable = mkEnableOption "zsh"; };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.zsh
    ];
    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = lib.concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_status"
          "$package"
          "$haskell"
          "$python"
          "$rust"
          "$nix_shell"
          "$line_break"
          "$jobs"
          "$character"
        ];
      };
    };
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";

      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;

      # Tweak settings for history
      history = {
        save = 1000;
        size = 1000;
        path = "$HOME/.cache/zsh_history";
      };

      # Set some aliases
      shellAliases = {
        c = "clear";
        mkdir = "mkdir -vp";
        rm = "rm -rifv";
        mv = "mv -iv";
        cp = "cp -riv";
        cat = "bat --paging=never --style=plain";
        ls = "exa -a --icons";
        tree = "exa --tree --icons";
        nd = "nix develop -c $SHELL";
        rebuild = "doas nixos-rebuild switch --flake $NIXOS_CONFIG_DIR --fast; notify-send 'Rebuild complete\!'";
      };

      # Source all plugins, nix-style
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-syntax-highlighting"; }
        ];
      };
    };
  };
}
