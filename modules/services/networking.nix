{ config, pkgs, lib, ... }:

{
  # This module configures networking settings for NixOS.

  config = {
    # Hostname and basic networking
    networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    # DNS configuration for faster resolution
    networking.nameservers = [
      "1.1.1.1"      # Cloudflare (fast, privacy-focused)
      "1.0.0.1"      # Cloudflare secondary
      "8.8.8.8"      # Google DNS fallback
      "8.8.4.4"      # Google DNS secondary
    ];
    # networking.dhcpcd.extraConfig = "nohook resolv.conf";

    # TCP/IP stack optimization for performance
    # boot.kernel.sysctl = {
    #   # Increase buffer sizes for high-speed networks
    #   "net.core.rmem_max" = 134217728;           # 128MB
    #   "net.core.wmem_max" = 134217728;           # 128MB
    #   "net.ipv4.tcp_rmem" = "4096 87380 67108864";
    #   "net.ipv4.tcp_wmem" = "4096 65536 67108864";

    #   # Increase TCP backlog for better connection handling
    #   "net.core.somaxconn" = 4096;
    #   "net.ipv4.tcp_max_syn_backlog" = 4096;

    #   # Enable fast TCP open (speeds up connections)
    #   "net.ipv4.tcp_fastopen" = 3;

    #   # TCP window scaling
    #   "net.ipv4.tcp_window_scaling" = 1;

    #   # Enable SACK (selective ACK) for better performance
    #   "net.ipv4.tcp_sack" = 1;

    #   # Reduce TIME_WAIT timeout
    #   "net.ipv4.tcp_fin_timeout" = 30;

    #   # Enable TCP keepalive for stability
    #   "net.ipv4.tcp_keepalives_intvl" = 30;
    #   "net.ipv4.tcp_keepalives_probes" = 5;

    #   # Disable TCP timestamps if latency-sensitive (optional)
    #   "net.ipv4.tcp_timestamps" = 1;

    #   # MTU size optimization (usually 1500 for Ethernet)
    #   # Uncomment if you know your optimal MTU
    #   # "net.ipv4.tcp_mtu_probing" = 1;
    # };

    # # NetworkManager optimization
    # networking.networkmanager.settings = {
    #   main = {
    #     # Use systemd resolver
    #     dns = "systemd-resolved";
    #   };
    };

    # Enable wireless if needed (currently disabled)
    # networking.wireless.enable = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}


