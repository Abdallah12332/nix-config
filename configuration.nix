# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # enable plymouth
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;
  boot.plymouth.theme = "bgrt";
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = ["quiet" "splash" ];
  
  #kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  #--enable nixos flakes--
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Cairo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ar_EG.UTF-8";
    LC_IDENTIFICATION = "ar_EG.UTF-8";
    LC_MEASUREMENT = "ar_EG.UTF-8";
    LC_MONETARY = "ar_EG.UTF-8";
    LC_NAME = "ar_EG.UTF-8";
    LC_NUMERIC = "ar_EG.UTF-8";
    LC_PAPER = "ar_EG.UTF-8";
    LC_TELEPHONE = "ar_EG.UTF-8";
    LC_TIME = "ar_EG.UTF-8";
  };

  # Configure keymap in X11
#  services.xserver.xkb = {
#    layout = "us";
#    variant = "";
#  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.omar = {
    isNormalUser = true;
    description = "omar";
    extraGroups = [ "networkmanager" "storage" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # enable niri
  programs.niri.enable = true;

  # enalbe gnome
  services.xserver.enable = true;
   
  services.desktopManager.gnome.enable = true;  
  services.displayManager.gdm.enable = true;
 
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      # potals for gnome
      gnome = {
        default = [ "gnome" ];
      };
      # protals for niri
      niri = {
        default = pkgs.lib.mkForce [ "wlr" "gtk"];
      };
      common.default = [ "gtk" ];
    };
  };

  #enable noctalia
  services.noctalia-shell.enable = true;
 
  #enable fish shell
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  programs.dconf.enable = true;
 
 #zram enable
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 80;
  };

  services.fwupd.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    
  };
  

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  # editors
  neovim
  helix

  # LSP & programming
  pyright
  python3
  ruff
  clang-tools
  rust-analyzer
  nil
  marksman
  nodejs
  nodePackages.prettier
  black
  nodePackages.typescript-language-server
  nodePackages.vscode-langservers-extracted
  wl-clipboard
  
  # fonts
  nerdfix
  nerd-fonts.fira-code
  nerd-fonts.jetbrains-mono
  nerd-fonts.jetbrains-mono

  # terminal tools
  fastfetch
  wget
  pipes
  cmatrix
  sl
  hollywood
  tmux
  nmap
  git
  
  # terminal
  kitty
   
  # browser
  librewolf

  # themes
  gnome-themes-extra
  kdePackages.breeze
  gruvbox-kvantum
  libsForQt5.qtstyleplugin-kvantum

  # file-manager
  ranger

  # file-manager extras
  udisks2
  gnome.gvfs
  polkit
  file
  udiskie

  # taskmanager
  btop
  
  # office
  libreoffice-qt-fresh

  # dockers  
  distrobox
  docker
  podman

  # niri & hyprland essentials
  xhost
  xwayland
  dbus
  dconf
  glib
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-wlr
  upower
  wireplumber
  xdg-utils
  wayland-utils
  pipewire
  wayland
  xwayland

  # gnome tools
  gnome-tweaks
  gnome-extension-manager
  gnome-control-center
  gnome-settings-daemon
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.udisks2.enable = true;
  security.polkit.enable = true;
  services.gvfs.enable = true;
  services.udisks2.mountOnMedia = true;
  services.dbus.enable = true;
  services.flatpak.enable = true;
  services.upower.enable = true;
  virtualisation.docker.enable = true;
  virtualisation.podman.enable = true;
  systemd.tmpfiles.rules = [
    "d /media 0775 root wheel -"
  ];
  services.dbus.packages = [ pkgs.gcr ];
  services.dbus.implementation = "broker";
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
