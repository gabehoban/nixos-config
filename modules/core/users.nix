{
  pkgs,
  user,
  ...
}:
{
  programs.zsh.enable = true;

  users.users = {
    root.hashedPassword = "!";
    ${user} = {
      isNormalUser = true;
      shell = pkgs.zsh;
      hashedPassword = "$7$CU..../....FZUZLOKbz7BuZigqQOVxq/$j2v.ltJRXmiTlwZYrfnS6mF.YwuEMu.wlStVgcqhll0";
      extraGroups = [
        "networkmanager"
        "wheel"
        "disk"
        "video"
        "input"
        "media"
      ];
    };
  };
}
