{
  description = "NixOS configuration flake (scalable multi-app)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # App
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # ex
    # anotherApp = {
    #   url = "git+https://github.com/user/anotherApp";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, ... }: 
    let
      apps = {
        inherit (self.inputs) quickshell;
        # inherit anotherApp;  
      };
    in
    {
      nixosConfigurations.Tutturuu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];

        # export
        specialArgs = { inherit apps; };
      };
    };
}
