{
  description = "A nix-flake for compiling legion; an alternative to VSCode";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    chapel.url = "github.com:twesterhout/nix-chapel"
  };
  
  outputs = 
    { self
    , nixpkgs
    , chapel
    }:
    
    # https://github.com/the-nix-way/dev-templates/blob/main/python/flake.nix
    flake-utils.lib.eachDefaultSystem (system:
    let
      
      pkgs = import nixpkgs { inherit system overlays; };

      packages = with pkgs; [
        chapel;
    ];
      allSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "armv5tel-linux"
        "armv6l-linux"
        "armv7a-linux"
        "armv7l-linux"
        "i686-linux"
        # "mipsel-linux" # Missing `busybox`.
        "powerpc64le-linux"
        "riscv64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    {
      default = pkgs.mkShell {
        packages = packages;
      }
    }
}