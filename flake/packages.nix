{
  inputs,
  self,
  ...
} @ args: {
  perSystem = {
    config,
    pkgs,
    lib,
    inputs',
    ...
  }: let
    docs = import ../docs {inherit pkgs inputs lib inputs';};
    buildPkg = maximal:
      (args.config.flake.lib.nvim.neovimConfiguration {
        inherit pkgs;
        modules = [(import ../configuration.nix maximal)];
      }).neovim;
  in {
    packages = {
      blink-cmp = pkgs.callPackage ./blink {};
      avante-nvim = let
        pin = self.pins.avante-nvim;
      in
        pkgs.callPackage ./avante-nvim {
          version = pin.branch;
          src = pkgs.fetchFromGitHub {
            inherit (pin.repository) owner repo;
            rev = pin.revision;
            sha256 = pin.hash;
          };
          pins = self.pins;
        };

      docs = docs.nvfDocs;
      docs-manpages = docs.manPages;
      docs-json = docs.options.json;
      docs-linkcheck = let
        site = config.packages.docs;
      in
        pkgs.testers.lycheeLinkCheck {
          inherit site;
          remap = {
            "https://lunarnovaa.github.io/nvf/" = site;
          };
          extraConfig = {
            exclude = [];
            include_mail = true;
            include-verbatim = true;
          };
        };

      # Exposed neovim configurations
      nix = buildPkg false;
      maximal = buildPkg true;
      default = config.packages.nix;
    };
  };
}
