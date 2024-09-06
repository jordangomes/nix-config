# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];

  boot.kernel = {
    sysctl = {
      "net.ipv4.conf.all.forwarding" = true;
    };
  };
  boot.kernelModules = [
    "v4l2loopback"
  ];

  networking.hostName = "jordans-desktop"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Enable Flake
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
    # useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.zerotierone.enable = true;
  services.zerotierone.joinNetworks = [
    "60ee7c034a77331b"
  ];

  # enable GVFS for trash
  services.gvfs.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jordan = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel" 
      "wireshark"
    ]; # Enable ‘sudo’ for the user.

    shell = pkgs.zsh;
    packages = with pkgs; [
      atlauncher
      feh
      firefox
      gcc
      gimp
      grimblast
      gnome.nautilus
      gnome.gnome-disk-utility
      jdk8
      mpv
      neofetch
      nmap
      obs-studio
      pavucontrol
      piper
      remmina
      rustup
      nodejs_22
      spotify
      signal-desktop
      tree
      ueberzugpp
      vscode
      wireshark
      wl-clipboard
      wofi-emoji
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "jordan" = import ./home.nix;
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    ansible
    btop
    gptfdisk
    gh
    git
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    waybar
    dunst
    libnotify
    hyprpaper
    hyprlock
    killall
    openssl
    powershell
    protonup
    qemu
    quickemu
    rofi-wayland
    sshpass
    unzip
    vesktop
    yazi
    zerotierone
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    google-fonts
    hack-font
    fira-code
    fira-code-symbols
    font-awesome
  ];

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
#    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-wlr
    pkgs.xdg-desktop-portal-hyprland
  ];

  programs.wireshark.enable = true;
  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.noisetorch.enable = true;
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.hyprland = {
    enable = true;
    #enableNvidiaPatches = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";

    ELECTRON_OZONE_PLATFORM_HINT = "x11";

    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/user/.steam/root/compatibilitytools.d";
  };

  hardware = {
    graphics.enable = true;
    nvidia.modesetting.enable = true;
    nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # List services that you want to enable:
  
  services.ratbagd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 ];
  networking.firewall.allowedUDPPorts = [ 
    67
    68
    69 
  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

