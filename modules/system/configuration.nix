{ config, pkgs, inputs, ... }:
let
  patchDriver = import ./nvenc-unlock.nix;
in
{
  # Remove unecessary preinstalled packages
  environment.defaultPackages = [ ];

  programs.zsh.enable = true;
  programs.dconf.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  age = {
    identityPaths = [ "/var/keys/ssh/id_ed25519" ];
    secrets.password.file = ../../private/password.age;
  };

  # Boot settings: clean /tmp/, latest kernel and enable bootloader
  boot = {
    tmpOnTmpfs = true;
    tmpOnTmpfsSize = "100%";
    cleanTmpDir = true;
    enableContainers = false;
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
  users.users.gabehoban = {
    isNormalUser = true;
    uid = 1001;
    home = "/home/gabehoban";
    description = "Gabe Hoban";
    extraGroups = [ "input" "wheel" "homelab" ];
    passwordFile = config.age.secrets.password.path;
    shell = pkgs.zsh;
  };
  users.groups.homelab = {
    gid = 2000;
    members = [ "gabehoban" "jellyfin" ];
  };
  users.groups.docker = {
    members = [ "gabehoban" ];
  };

  # Set up networking and secure it
  networking = {
    wireless.iwd.enable = true;
    enableIPv6 = false;
  };

  # Security 
  security = {
    sudo.enable = true;
    protectKernelImage = true;
    rtkit.enable = true;
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      media-session.enable = false;
      systemWide = false;
      wireplumber.enable = true;
    };
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
      displayManager.gdm.enable = true;
      displayManager.gdm.autoSuspend = false;
      desktopManager.gnome.enable = true;
    };
    udev.packages = with pkgs; [ yubikey-personalization ];
    pcscd.enable = true;
    zfs.autoScrub.enable = true;
    nfs.server = {
      enable = true;
      lockdPort = 4001;
      mountdPort = 4002;
      statdPort = 4000;
    };
    fstrim.enable = true;
    printing.enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [ 111 2049 4000 4001 4002 20048 ];
    allowedUDPPorts = [ 111 2049 4000 4001 4002 20048 ];
  };

  xdg.portal.enable = true;

  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
    };
    nvidia = {
      open = false;
      package = patchDriver config.boot.kernelPackages.nvidiaPackages.stable;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        nvidia-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    pulseaudio.enable = false;
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
    video.hidpi.enable = true;
  };

  # Nix settings, auto cleanup and enable flakes
  nix = {
    package = pkgs.nixUnstable;
    settings.auto-optimise-store = true;
    settings.allowed-users = [ "root" "gabehoban" ];
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

  fonts = {
    fonts = with pkgs; [
      jetbrains-mono
      roboto
      openmoji-color
      borg-sans-mono
      cantarell-fonts
      fira
      fira-code
      fira-code-symbols
      font-awesome_4
      font-awesome_5
      noto-fonts
      noto-fonts-cjk
      open-fonts
      roboto
      ubuntu_font_family
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    fontconfig = {
      hinting.autohint = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "JetBrainsMono" ];
        emoji = [ "OpenMoji Color" ];
      };
    };
  };

  environment = {
    variables = {
      AE_SINK = "ALSA";
      SDL_AUDIODRIVER = "pipewire";
      ALSOFT_DRIVERS = "pipewire";
      GAMEMODERUNEXEC = "WINEFSYNC=1 PROTON_WINEDBG_DISABLE=1 DXVK_LOG_PATH=none DXVK_HUD=compiler WINEDEBUG=-all DXVK_LOG_LEVEL=none RADV_PERFTEST=rt,gpl,ngg_streamout";
    };
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
    systemPackages = (with pkgs; [
      gnome.adwaita-icon-theme
      podman
      libva
      libva-utils
      glxinfo
      _1password-gui-beta
      yubico-piv-tool
    ]) ++ [ inputs.agenix.packages.x86_64-linux.default ];
  };

  documentation.enable = true;
  documentation.nixos.enable = false;
  documentation.man.enable = true;
  documentation.info.enable = false;
  documentation.doc.enable = false;

  # Do not touch
  system.stateVersion = "23.05";
}
