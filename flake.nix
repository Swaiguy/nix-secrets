{
  inputs = {
    # ......

    # secrets management, lock with git commit at 2023/5/15
    ragenix.url = "github:yaxitech/ragenix";

    # my private secrets, it's a private repository, you need to replace it with your own.
    mysecrets = { url = "github:Swaiguy/nix-secrets"; flake = false; };
  };

  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {
      nixos-test = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        # Set all input parameters as specialArgs of all sub-modules
        # so that we can use the `agenix` & `mysecrets` in sub-modules
        specialArgs = inputs;
        modules = [
          # ......

          # import & decrypt secrets in `mysecrets` in this module
          ./secrets/default.nix
        ];
      };
    };
  };
}