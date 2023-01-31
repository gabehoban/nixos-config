{
  description = "NixOS configuration";

  # All inputs for the system
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # All outputs for the system (configs)
  outputs = { home-manager, nixpkgs, agenix, nur, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      lib = nixpkgs.lib;

      mkSystem = pkgs: system: hostname:
        pkgs.lib.nixosSystem {
          system = system;
          modules = [
            {
              networking = {
                hostName = hostname;
                hostId = builtins.substring 0 8 (builtins.hashString "md5" hostname);
              };
            }
            (./. + "/hosts/${hostname}/hardware-configuration.nix")
            ./modules/system/configuration.nix
            home-manager.nixosModules.home-manager
            agenix.nixosModules.default
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = { inherit inputs; };
                users.gabehoban = (./. + "/hosts/${hostname}/user.nix");
              };
              nixpkgs.overlays = [
                nur.overlay
              ];
            }
          ];
          specialArgs = { inherit inputs; };
        };

    in
    {
      nixosConfigurations = {
        # Now, defining a new system is can be done in one line
        #                                Architecture   Hostname
        baymax = mkSystem inputs.nixpkgs "x86_64-linux" "baymax";
      };
    };
}
