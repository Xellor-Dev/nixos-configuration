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
    ];

    # TCP/IP stack optimization for performance
    boot.kernel.sysctl = {
      # TCP window scaling for better throughput
      "net.ipv4.tcp_window_scaling" = 1;

      # Enable SACK (selective ACK) for better packet loss handling
      "net.ipv4.tcp_sack" = 1;

      # Use BBR congestion control (better for WiFi)
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };

    # Enable wireless if needed (currently disabled)
    # networking.wireless.enable = true;

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}


