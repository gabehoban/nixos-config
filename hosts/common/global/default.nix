{

  imports = [
    ./env-vars.nix
    ./nix-settings.nix
    ./ssh.nix
    ./system-packages.nix
    ./user.nix
    ./sops.nix
    ./systemd-initrd.nix
    ./ephemeral-btrfs.nix
    ./impermanence.nix
  ];



}
