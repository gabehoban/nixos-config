{ config, pkgs, inputs, ... }:

{
  # Remove unecessary preinstalled packages
  environment.defaultPackages = [ ];

  programs.zsh.enable = true;
  programs.dconf.enable = true;

  # Install fonts
  fonts = {
    fonts = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        emoji = [ "OpenMoji Color" ];
      };
    };
  };

  age = {
    identityPaths = [ "/var/keys/ssh/id_ed25519" ];
    secrets.password.file = ../../private/password.age;
  };

  xdg.portal.enable = true;

  # Nix settings, auto cleanup and enable flakes
  nix = {
    package = pkgs.nixUnstable;
    settings.auto-optimise-store = true;
    settings.allowed-users = [ "gabehoban" ];
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nixpkgs.config.allowUnfree = true;

  # Boot settings: clean /tmp/, latest kernel and enable bootloader
  boot = {
    cleanTmpDir = true;
    initrd = {
      systemd.enable = true;
      supportedFilesystems = [ "zfs" ];
    };
    loader = {
      systemd-boot.enable = true;
      systemd-boot.editor = false;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    zfs.enableUnstable = true;
    zfs.requestEncryptionCredentials = true;
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = [ "nohibernate" ];
    plymouth.enable = true;
  };

  # Set up locales (timezone and keyboard layout)
  time.timeZone = "America/Detroit";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Set up user and enable sudo
  virtualisation.libvirtd.enable = true;
  users.users.gabehoban = {
    isNormalUser = true;
    home = "/home/gabehoban";
    description = "Gabe Hoban";
    extraGroups = [ "input" "wheel" "libvirtd" ];
    passwordFile = config.age.secrets.password.path;
    shell = pkgs.zsh;
  };

  # Set up networking and secure it
  networking = {
    wireless.iwd.enable = true;
  };

  # Security 
  security = {
    sudo.enable = true;
    protectKernelImage = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
    udev.packages = with pkgs; [ yubikey-personalization ];
    pcscd.enable = true;
    zfs.autoScrub.enable = true;
    fstrim.enable = true;
    printing.enable = true;
  };

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
    };
    opengl = {
      enable = true;
      driSupport = true;
    };
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    video.hidpi.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment = {
    gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
    ]) ++ (with pkgs.gnome; [
      cheese
      gnome-music
      gnome-terminal
      gedit
      epiphany
      geary
      evince
      gnome-characters
      totem
      tali
      iagno
      hitori
      atomix
    ]);
    systemPackages = (with pkgs; [ gnome.adwaita-icon-theme virt-manager ]) ++ [ inputs.agenix.packages.x86_64-linux.default ];
  };

  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;

  documentation.enable = true;
  documentation.nixos.enable = false;
  documentation.man.enable = true;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  # Do not touch
  system.stateVersion = "23.05";
}
