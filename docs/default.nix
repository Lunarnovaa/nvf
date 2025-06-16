{
  inputs,
  inputs',
  pkgs,
  lib,
}: let
  nvimModuleOptionsJSON =
    (pkgs.nixosOptionsDoc {
      variablelistId = "nvf-options";
      warningsAreErrors = true;

      inherit
        (
          (lib.evalModules {
            specialArgs = {inherit inputs;};
            modules =
              import ../modules/modules.nix {
                inherit lib pkgs;
              }
              ++ [
                (
                  let
                    # From nixpkgs:
                    #
                    # Recursively replace each derivation in the given attribute set
                    # with the same derivation but with the `outPath` attribute set to
                    # the string `"\${pkgs.attribute.path}"`. This allows the
                    # documentation to refer to derivations through their values without
                    # establishing an actual dependency on the derivation output.
                    #
                    # This is not perfect, but it seems to cover a vast majority of use
                    # cases.
                    #
                    # Caveat: even if the package is reached by a different means, the
                    # path above will be shown and not e.g.
                    # `${config.services.foo.package}`.
                    scrubDerivations = namePrefix: pkgSet:
                      builtins.mapAttrs (
                        name: value: let
                          wholeName = "${namePrefix}.${name}";
                        in
                          if builtins.isAttrs value
                          then
                            scrubDerivations wholeName value
                            // lib.optionalAttrs (lib.isDerivation value) {
                              inherit (value) drvPath;
                              outPath = "\${${wholeName}}";
                            }
                          else value
                      )
                      pkgSet;
                  in {
                    _module = {
                      check = false;
                      args.pkgs = lib.mkForce (scrubDerivations "pkgs" pkgs);
                    };
                  }
                )
              ];
          })
        )
        options
        ;

      transformOptions = opt:
        opt
        // {
          declarations =
            map (
              decl:
                if lib.hasPrefix (toString ../.) (toString decl)
                then
                  lib.pipe decl [
                    toString
                    (lib.removePrefix (toString ../.))
                    (lib.removePrefix "/")
                    (x: {
                      url = "https://github.com/NotAShelf/nvf/blob/main/${x}";
                      name = "<nvf/${x}>";
                    })
                  ]
                else if decl == "lib/modules.nix"
                then {
                  url = "https://github.com/NixOS/nixpkgs/blob/master/${decl}";
                  name = "<nixpkgs/lib/modules.nix>";
                }
                else decl
            )
            opt.declarations;
        };
    }).optionsJSON;

  nativeBuildInputs = [inputs'.ndg.packages.ndg];
in {
  "options.json" =
    pkgs.runCommand "options.json" {
      meta.description = "List of nvf options in JSON format";
    } ''
      mkdir -p $out/{share/doc,nix-support}
      cp -a ${nvimModuleOptionsJSON}/share/doc/nixos $out/share/doc/nvf
      substitute \
        ${nvimModuleOptionsJSON}/nix-support/hydra-build-products \
        $out/nix-support/hydra-build-products \
        --replace \
        '${nvimModuleOptionsJSON}/share/doc/nixos' \
        "$out/share/doc/nvf"
    '';

  nvfDocs = pkgs.runCommandLocal "nvf-docs" {inherit nativeBuildInputs;} ''
    mkdir -p $out

    ndg --verbose html \
      --title "nvf" \
      --jobs $NIX_BUILD_CORES \
      --module-options ${nvimModuleOptionsJSON}/share/doc/nixos/options.json \
      --options-depth 2 \
      --generate-search true \
      --highlight-code true \
      --input-dir ${./docs/manual/manual.md} \
      --output-dir "$out"
  '';

  manPages = pkgs.runCommandLocal "nvf-reference-manpage" {inherit nativeBuildInputs;} ''
    # Generate manpages.
    mkdir -p $out/share/man/{man5,man1}

    ndg --verbose manpage \
      --title "nvf" \
      --section 5 \
      --module-options ${nvimModuleOptionsJSON}/share/doc/nixos/options.json \
      #--header ${builtins.readFile ./man/header.5} \
      #--footer ${builtins.readFile ./man/footer.5} \
      --output-file "$out/share/man/man5/nvf.5"

    cp ${./man/nvf.1} $out/share/man/man1/nvf.1
  '';
}
