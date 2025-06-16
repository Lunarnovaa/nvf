# Manual

## Preface {#ch-preface}

### What is nvf {#sec-what-is-it}

nvf is a highly modular, configurable, extensible and easy to use Neovim
configuration in Nix. Designed for flexibility and ease of use, nvf allows you
to easily configure your fully featured Neovim instance with a few lines of Nix.

### Bugs & Suggestions {#sec-bugs-suggestions}

[issue tracker]: https://github.com/notashelf/nvf/issues
[discussions tab]: https://github.com/notashelf/nvf/discussions
[pull requests tab]: https://github.com/notashelf/nvf/pulls

If you notice any issues with nvf, or this documentation, then please consider
reporting them over at the [issue tracker]. Issues tab, in addition to the
[discussions tab] is a good place as any to request new features.

You may also consider submitting bugfixes, feature additions and upstreamed
changes that you think are critical over at the [pull requests tab].

## Try it out {#ch-try-it-out}

Thanks to the portability of Nix, you can try out nvf without actually
installing it to your machine. Below are the commands you may run to try out
different configurations provided by this flake. As of v0.5, two specialized
configurations are provided:

- **Nix** - Nix language server + simple utility plugins
- **Maximal** - Variable language servers + utility and decorative plugins

You may try out any of the provided configurations using the `nix run` command
on a system where Nix is installed.

```bash
$ cachix use nvf                   # Optional: it'll save you CPU resources and time
$ nix run github:notashelf/nvf#nix # will run the default minimal configuration
```

Do keep in mind that this is **susceptible to garbage collection** meaning it
will be removed from your Nix store once you garbage collect.

### Using Prebuilt Configs {#sec-using-prebuilt-configs}

```bash
$ nix run github:notashelf/nvf#nix
$ nix run github:notashelf/nvf#maximal
```

#### Available Configurations {#sec-available-configs}

> [!IMPORTANT]
> The below configurations are provided for demonstration purposes, and are
> **not** designed to be installed as is. You may

##### Nix {#sec-configs-nix}

`Nix` configuration by default provides LSP/diagnostic support for Nix alongside
a set of visual and functional plugins. By running `nix run .#`, which is the
default package, you will build Neovim with this config.

```bash
$ nix run github:notashelf/nvf#nix test.nix
```

This command will start Neovim with some opinionated plugin configurations, and
is designed specifically for Nix. the `nix` configuration lets you see how a
fully configured Neovim setup _might_ look like without downloading too many
packages or shell utilities.

##### Maximal {#sec-configs-maximal}

`Maximal` is the ultimate configuration that will enable support for more
commonly used language as well as additional complementary plugins. Keep in
mind, however, that this will pull a lot of dependencies.

```bash
$ nix run github:notashelf/nvf#maximal -- test.nix
```

It uses the same configuration template with the [Nix](#sec-configs-nix)
configuration, but supports many more languages, and enables more utility,
companion or fun plugins.

> [!WARNING]
> Running the maximal config will download _a lot_ of packages as it is
> downloading language servers, formatters, and more.

## Installing nvf {#ch-installation}

[module installation section]: #ch-module-installation

There are multiple ways of installing nvf on your system. You may either choose
the standalone installation method, which does not depend on a module system and
may be done on any system that has the Nix package manager or the appropriate
modules for NixOS and home-manager as described in the
[module installation section].

```{=include=} chapters
installation/custom-configuration.md
installation/modules.md
```

### Standalone Installation {#ch-standalone-installation}

It is possible to install nvf without depending on NixOS or Home-Manager as the
parent module system, using the `neovimConfiguration` function exposed in the
extended library. This function will take `modules` and `extraSpecialArgs` as
arguments, and return the following schema as a result.

```nix
{
  options = "The options that were available to configure";
  config = "The outputted configuration";
  pkgs = "The package set used to evaluate the module";
  neovim = "The built neovim package";
}
```

An example flake that exposes your custom Neovim configuration might look like

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    packages.x86_64-linux = {
      # Set the default package to the wrapped instance of Neovim.
      # This will allow running your Neovim configuration with
      # `nix run` and in addition, sharing your configuration with
      # other users in case your repository is public.
      default =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            {
              config.vim = {
                # Enable custom theming options
                theme.enable = true;

                # Enable Treesitter
                treesitter.enable = true;

                # Other options will go here. Refer to the config
                # reference in Appendix B of the nvf manual.
                # ...
              };
            }
          ];
        })
        .neovim;
    };
  };
}
```

<!-- TODO: mention the built-in flake template here when it is added -->

The above setup will allow to set up nvf as a standalone flake, which you can
build independently from your system configuration while also possibly sharing
it with others. The next two chapters will detail specific usage of such a setup
for a package output in the context of NixOS or Home-Manager installation.

```{=include=} chapters
standalone/nixos.md
standalone/home-manager.md
```

#### Standalone Installation on NixOS {#ch-standalone-nixos}

Your built Neovim configuration can be exposed as a flake output to make it
easier to share across machines, repositories and so on. Or it can be added to
your system packages to make it available across your system.

The following is an example installation of `nvf` as a standalone package with
the default theme enabled. You may use other options inside `config.vim` in
`configModule`, but this example will not cover that extensively.

````nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    nixpkgs,
    nvf,
    self,
    ...
  }: {
    # This will make the package available as a flake output under 'packages'
    packages.x86_64-linux.my-neovim =
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          # Or move this to a separate file and add it's path here instead
          # IE: ./nvf_module.nix
          (
            {pkgs, ...}: {
              # Add any custom options (and do feel free to upstream them!)
              # options = { ... };
              config.vim = {
                theme.enable = true;
                # and more options as you see fit...
              };
            }
          )
        ];
      })
      .neovim;

    # Example nixosConfiguration using the configured Neovim package
    nixosConfigurations = {
      yourHostName = nixpkgs.lib.nixosSystem {
        # ...
        modules = [
          # This will make wrapped neovim available in your system packages
          # Can also move this to another config file if you pass inputs/self around with specialArgs
          ({pkgs, ...}: {
            environment.systemPackages = [self.packages.${pkgs.stdenv.system}.neovim];
          })
        ];
        # ...
      };
    };
  };
}```

#### Standalone Installation on Home-Manager {#ch-standalone-hm}

Your built Neovim configuration can be exposed as a flake output to make it
easier to share across machines, repositories and so on. Or it can be added to
your system packages to make it available across your system.

The following is an example installation of `nvf` as a standalone package with
the default theme enabled. You may use other options inside `config.vim` in
`configModule`, but this example will not cover that extensively.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {nixpkgs, home-manager, nvf, ...}: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    configModule = {
      # Add any custom options (and do feel free to upstream them!)
      # options = { ... };

      config.vim = {
        theme.enable = true;
        # and more options as you see fit...
      };
    };

    customNeovim = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = [configModule];
    };
  in {
    # This will make the package available as a flake output under 'packages'
    packages.${system}.my-neovim = customNeovim.neovim;

    # Example Home-Manager configuration using the configured Neovim package
    homeConfigurations = {
      "your-username@your-hostname" = home-manager.lib.homeManagerConfiguration {
        # ...
        modules = [
          # This will make Neovim available to users using the Home-Manager
          # configuration. To make the package available to all users, prefer
          # environment.systemPackages in your NixOS configuration.
          {home.packages = [customNeovim.neovim];}
        ];
        # ...
      };
    };
  };
}
````

### Module Installation {#ch-module-installation}

The below chapters will describe installing nvf as NixOS and Home-Manager
modules. Note that those methods are mutually exclusive, and will likely cause
path collisions if used simultaneously.

```{=include=} chapters
modules/nixos.md
modules/home-manager.md
```

#### NixOS Module {#ch-nixos-module}

The NixOS module allows us to customize the different `vim` options from inside
the NixOS configuration without having to call for the wrapper yourself. It is
the recommended way to use **nvf** alongside the home-manager module depending
on your needs.

To use it, we first add the input flake.

```nix
{
  inputs = {
    # Optional, if you intend to follow nvf's obsidian-nvim input
    # you must also add it as a flake input.
    obsidian-nvim.url = "github:epwalsh/obsidian.nvim";

    # Required, nvf works best and only directly supports flakes
    nvf = {
      url = "github:notashelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
      # Optionally, you can also override individual plugins
      # for example:
      inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };
  };
}
```

Followed by importing the NixOS module somewhere in your configuration.

```nix
{
  # assuming nvf is in your inputs and inputs is in the argset
  # see example below
  imports = [ inputs.nvf.nixosModules.default ];
}
```

##### Example Installation {#sec-example-installation-nixos}

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { nixpkgs, nvf, ... }: {
    # ↓ this is your host output in the flake schema
    nixosConfigurations."your-hostname" = nixpkgs.lib.nixosSystem {
      modules = [
        nvf.nixosModules.default # <- this imports the NixOS module that provides the options
        ./configuration.nix # <- your host entrypoint, `programs.nvf.*` may be defined here
      ];
    };
  };
}
```

Once the module is properly imported by your host, you will be able to use the
`programs.nvf` module option anywhere in your configuration in order to
configure **nvf**.

```nix{
  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.lsp = {
        enable = true;
      };
    };
  };
}
```

> [!NOTE]
> nvf exposes a lot of options, most of which are not referenced in the
> installation sections of the manual. You may find all available options in the
> [appendix](https://lunarnovaa.github.io/nvf/options)

#### Home-Manager Module {#ch-hm-module}

The home-manager module allows us to customize the different `vim` options from
inside the home-manager configuration without having to call for the wrapper
yourself. It is the recommended way to use **nvf** alongside the NixOS module
depending on your needs.

To use it, we first add the input flake.

```nix
{
  inputs = {
    # Optional, if you intend to follow nvf's obsidian-nvim input
    # you must also add it as a flake input.
    obsidian-nvim.url = "github:epwalsh/obsidian.nvim";

    # Required, nvf works best and only directly supports flakes
    nvf = {
      url = "github:notashelf/nvf";
      # You can override the input nixpkgs to follow your system's
      # instance of nixpkgs. This is safe to do as nvf does not depend
      # on a binary cache.
      inputs.nixpkgs.follows = "nixpkgs";
      # Optionally, you can also override individual plugins
      # for example:
      inputs.obsidian-nvim.follows = "obsidian-nvim"; # <- this will use the obsidian-nvim from your inputs
    };
  };
}
```

Followed by importing the home-manager module somewhere in your configuration.

```nix
{
  # Assuming "nvf" is in your inputs and inputs is in the argument set.
  # See example installation below
  imports = [ inputs.nvf.homeManagerModules.default ];
}
```

##### Example Installation {#sec-example-installation-hm}

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { nixpkgs, home-manager, nvf, ... }: {
    # ↓ this is your home output in the flake schema, expected by home-manager
    "your-username@your-hostname" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        nvf.homeManagerModules.default # <- this imports the home-manager module that provides the options
        ./home.nix # <- your home entrypoint, `programs.nvf.*` may be defined here
      ];
    };
  };
}
```

Once the module is properly imported by your host, you will be able to use the
`programs.nvf` module option anywhere in your configuration in order to
configure **nvf**.

```nix{
  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim.viAlias = false;
      vim.vimAlias = true;
      vim.lsp = {
        enable = true;
      };
    };
  };
}
```

> [!NOTE]
> **nvf** exposes a lot of options, most of which are not referenced in the
> installation sections of the manual. You may find all available options in the
> [appendix](https://lunarnovaa.github.io/nvf/options)

## Configuring nvf {#ch-configuring}

[helpful tips section]: #ch-helpful-tips

nvf allows for _very_ extensive configuration in Neovim through the Nix module
interface. The below chapters describe several of the options exposed in nvf for
your convenience. You might also be interested in the [helpful tips section] for
more advanced or unusual configuration options supported by nvf.

Note that this section does not cover module _options_. For an overview of all
module options provided by nvf, please visit the [appendix](/options.html)

```{=include=} chapters
configuring/custom-package.md
configuring/custom-plugins.md
configuring/overriding-plugins.md
configuring/languages.md
configuring/dags.md
configuring/dag-entries.md
configuring/autocmds.md
```

### Custom Neovim Package {#ch-custom-package}

As of v0.5, you may now specify the Neovim package that will be wrapped with
your configuration. This is done with the [](#opt-vim.package) option.

```nix
{inputs, pkgs, ...}: {
  # using the neovim-nightly overlay
  vim.package = inputs.neovim-overlay.packages.${pkgs.stdenv.system}.neovim;
}
```

The neovim-nightly-overlay always exposes an unwrapped package. If using a
different source, you are highly recommended to get an "unwrapped" version of
the neovim package, similar to `neovim-unwrapped` in nixpkgs.

```nix
{ pkgs, ...}: {
  # using the neovim-nightly overlay
  vim.package = pkgs.neovim-unwrapped;
}
```

### Custom Plugins {#ch-custom-plugins}

**nvf** exposes a very wide variety of plugins by default, which are consumed by
module options. This is done for your convenience, and to bundle all necessary
dependencies into **nvf**'s runtime with full control of versioning, testing and
dependencies. In the case a plugin you need is _not_ available, you may consider
making a pull request to add the package you're looking for, or you may add it
to your configuration locally. The below section describes how new plugins may
be added to the user's configuration.

#### Adding Plugins {#ch-adding-plugins}

Per **nvf**'s design choices, there are several ways of adding custom plugins to
your configuration as you need them. As we aim for extensive configuration, it
is possible to add custom plugins (from nixpkgs, pinning tools, flake inputs,
etc.) to your Neovim configuration before they are even implemented in **nvf**
as a module.

> [!IMPORTANT]
> To add a plugin to your runtime, you will need to add it to
> [](#opt-vim.startPlugins) list in your configuration. This is akin to cloning
> a plugin to `~/.config/nvim`, but they are only ever placed in the Nix store
> and never exposed to the outside world for purity and full isolation.

As you would configure a cloned plugin, you must configure the new plugins that
you've added to `startPlugins.` **nvf** provides multiple ways of configuring
any custom plugins that you might have added to your configuration.

```{=include=} sections
custom-plugins/configuring.md
custom-plugins/lazy-method.md
custom-plugins/non-lazy-method.md
custom-plugins/legacy-method.md
```

##### Configuring {#sec-configuring-plugins}

Just making the plugin to your Neovim configuration available might not always
be enough., for example, if the plugin requires a setup table. In that case, you
can write custom Lua configuration using one of

- `config.vim.lazy.plugins.*.setupOpts`
- `config.vim.extraPlugins.*.setup`
- `config.vim.luaConfigRC`.

###### Lazy Plugins {#ch-vim-lazy-plugins}

`config.vim.lazy.plugins.*.setupOpts` is useful for lazy-loading plugins, and
uses an extended version of `lz.n's` `PluginSpec` to expose a familiar
interface. `setupModule` and `setupOpt` can be used if the plugin uses a
`require('module').setup(...)` pattern. Otherwise, the `before` and `after`
hooks should do what you need.

```nix
{
  config.vim.lazy.plugins = {
    aerial.nvim = {
    # ^^^^^^^^^ this name should match the package.pname or package.name
      package = aerial-nvim;

      setupModule = "aerial";
      setupOpts = {option_name = false;};

      after = "print('aerial loaded')";
    };
  };
}
```

###### Standard API {#ch-vim-extra-plugins}

`vim.extraPlugins` uses an attribute set, which maps DAG section names to a
custom type, which has the fields `package`, `after`, `setup`. They allow you to
set the package of the plugin, the sections its setup code should be after (note
that the `extraPlugins` option has its own DAG scope), and the its setup code
respectively. For example:

```nix
{pkgs, ...}: {
  config.vim.extraPlugins = {
    aerial = {
      package = pkgs.vimPlugins.aerial-nvim;
      setup = "require('aerial').setup {}";
    };

    harpoon = {
      package = pkgs.vimPlugins.harpoon;
      setup = "require('harpoon').setup {}";
      after = ["aerial"]; # place harpoon configuration after aerial
    };
  };
}
```

###### Setup using luaConfigRC {#setup-using-luaconfigrc}

`vim.luaConfigRC` also uses an attribute set, but this one is resolved as a DAG
directly. The attribute names denote the section names, and the values lua code.
For example:

```nix
{
  # This will create a section called "aquarium" in the 'init.lua' with the
  # contents of your custom configuration. By default 'entryAnywhere' is implied
  # in DAGs, so this will be inserted to an arbitrary position. In the case you 
  # wish to control the position of this section with more precision, please
  # look into the DAGs section of the manual.
  config.vim.luaConfigRC.aquarium = "vim.cmd('colorscheme aquiarum')";
}
```

<!-- deno-fmt-ignore-start -->
[DAG system]: #ch-using-dags
[DAG section]: #ch-dag-entries

> [!NOTE]
> One of the **greatest strengths** of **nvf** is the ability to order
configuration snippets precisely using the [DAG system]. DAGs
are a very powerful mechanism that allows specifying positions
of individual sections of configuration as needed. We provide helper functions
in the extended library, usually under `inputs.nvf.lib.nvim.dag` that you may
use.
Please refer to the [DAG section] in the nvf manual
to find out more about the DAG system.

##### Lazy Method {#sec-lazy-method}

As of version **0.7**, an API is exposed to allow configuring lazy-loaded
plugins via `lz.n` and `lzn-auto-require`. Below is a comprehensive example of
how it may be loaded to lazy-load an arbitrary plugin.

```nix
{
  config.vim.lazy.plugins = {
    "aerial.nvim" = {
      package = pkgs.vimPlugins.aerial-nvim;
      setupModule = "aerial";
      setupOpts = {
        option_name = true;
      };
      after = ''
        -- custom lua code to run after plugin is loaded
        print('aerial loaded')
      '';

      # Explicitly mark plugin as lazy. You don't need this if you define one of
      # the trigger "events" below
      lazy = true;

      # load on command
      cmd = ["AerialOpen"];

      # load on event
      event = ["BufEnter"];

      # load on keymap
      keys = [
        {
          key = "<leader>a";
          action = ":AerialToggle<CR>";
        }
      ];
    };
  };
}
```

###### LazyFile event {#sec-lazyfile-event}

**nvf** re-implements `LazyFile` as a familiar user event to load a plugin when
a file is opened:

```nix
{
  config.vim.lazy.plugins = {
    "aerial.nvim" = {
      package = pkgs.vimPlugins.aerial-nvim;
      event = [{event = "User"; pattern = "LazyFile";}];
      # ...
    };
  };
}
```

You can consider the `LazyFile` event as an alias to the combination of
`"BufReadPost"`, `"BufNewFile"` and `"BufWritePre"`, i.e., a list containing all
three of those events: `["BufReadPost" "BufNewFile" "BufWritePre"]`

##### Non-lazy Method {#sec-non-lazy-method}

As of version **0.5**, we have a more extensive API for configuring plugins that
should be preferred over the legacy method. This API is available as
[](#opt-vim.extraPlugins). Instead of using DAGs exposed by the library
_directly_, you may use the extra plugin module as follows:

```nix
{pkgs, ...}: {
  config.vim.extraPlugins = {
    aerial = {
      package = pkgs.vimPlugins.aerial-nvim;
      setup = ''
        require('aerial').setup {
          -- some lua configuration here
        }
      '';
    };

    harpoon = {
      package = pkgs.vimPlugins.harpoon;
      setup = "require('harpoon').setup {}";
      after = ["aerial"];
    };
  };
}
```

This provides a level of abstraction over the DAG system for faster iteration.

##### Legacy Method {#sec-legacy-method}

Prior to version **0.5**, the method of adding new plugins was adding the plugin
package to [](#opt-vim.startPlugins) and adding its configuration as a DAG under
one of `vim.configRC` or [](#opt-vim.luaConfigRC). While `configRC` has been
deprecated, users who have not yet updated to 0.5 or those who prefer a more
hands-on approach may choose to use the old method where the load order of the
plugins is explicitly determined by DAGs without internal abstractions.

###### Adding New Plugins {#sec-adding-new-plugins}

To add a plugin not available in **nvf** as a module to your configuration using
the legacy method, you must add it to [](#opt-vim.startPlugins) in order to make
it available to Neovim at runtime.

```nix
{pkgs, ...}: {
  # Add a Neovim plugin from Nixpkgs to the runtime.
  # This does not need to come explicitly from packages. 'vim.startPlugins'
  # takes a list of *string* (to load internal plugins) or *package* to load
  # a Neovim package from any source.
  vim.startPlugins = [pkgs.vimPlugins.aerial-nvim];
}
```

Once the package is available in Neovim's runtime, you may use the `luaConfigRC`
option to provide configuration as a DAG using the **nvf** extended library in
order to configure the added plugin,

```nix
{inputs, ...}: let
  # This assumes you have an input called 'nvf' in your flake inputs
  # and 'inputs' in your specialArgs. In the case you have passed 'nvf'
  # to specialArgs, the 'inputs' prefix may be omitted.
  inherit (inputs.nvf.lib.nvim.dag) entryAnywhere;
in {
  # luaConfigRC takes Lua configuration verbatim and inserts it at an arbitrary
  # position by default or if 'entryAnywhere' is used.
  vim.luaConfigRC.aerial-nvim= entryAnywhere ''
    require('aerial').setup {
      -- your configuration here
    }
  '';
}
```

### Overriding plugins {#ch-overriding-plugins}

The [additional plugins section](#sec-additional-plugins) details the addition
of new plugins to nvf under regular circumstances, i.e. while making a pull
request to the project. You may _override_ those plugins in your config to
change source versions, e.g., to use newer versions of plugins that are not yet
updated in **nvf**.

```nix
vim.pluginOverrides = {
  lazydev-nvim = pkgs.fetchFromGitHub {
    owner = "folke";
    repo = "lazydev.nvim";
    rev = "";
    hash = "";
  };
 # It's also possible to use a flake input
 lazydev-nvim = inputs.lazydev-nvim;
 # Or a local path 
 lazydev-nvim = ./lazydev;
 # Or a npins pin... etc
};
```

This will override the source for the `neodev.nvim` plugin that is used in nvf
with your own plugin.

> [!WARNING]
While updating plugin inputs, make sure that any configuration that has been
deprecated in newer versions is changed in the plugin's `setupOpts`. If you
depend on a new version, requesting a version bump in the issues section is a
more reliable option.

### Language Support {#ch-languages}

Language specific support means there is a combination of language specific
plugins, `treesitter` support, `nvim-lspconfig` language servers, and `null-ls`
integration. This gets you capabilities ranging from autocompletion to
formatting to diagnostics. The following languages have sections under the
`vim.languages` attribute.

- Rust: [vim.languages.rust.enable](#opt-vim.languages.rust.enable)
- Nix: [vim.languages.nix.enable](#opt-vim.languages.nix.enable)
- SQL: [vim.languages.sql.enable](#opt-vim.languages.sql.enable)
- C/C++: [vim.languages.clang.enable](#opt-vim.languages.clang.enable)
- Typescript/Javascript: [vim.languages.ts.enable](#opt-vim.languages.ts.enable)
- Python: [vim.languages.python.enable](#opt-vim.languages.python.enable):
- Zig: [vim.languages.zig.enable](#opt-vim.languages.zig.enable)
- Markdown: [vim.languages.markdown.enable](#opt-vim.languages.markdown.enable)
- HTML: [vim.languages.html.enable](#opt-vim.languages.html.enable)
- Dart: [vim.languages.dart.enable](#opt-vim.languages.dart.enable)
- Go: [vim.languages.go.enable](#opt-vim.languages.go.enable)
- Lua: [vim.languages.lua.enable](#opt-vim.languages.lua.enable)
- PHP: [vim.languages.php.enable](#opt-vim.languages.php.enable)
- F#: [vim.languages.fsharp.enable](#opt-vim.languages.fsharp.enable)

Adding support for more languages, and improving support for existing ones are
great places where you can contribute with a PR.

```{=include=} sections
languages/lsp.md
```

#### LSP Custom Packages/Command {#sec-languages-custom-lsp-packages}

One of the strengths of **nvf** is convenient aliases to quickly configure LSP
servers through the Nix module system. By default the LSP packages for relevant
language modules will be pulled into the closure. If this is not desirable, you
may provide **a custom LSP package** (e.g., a Bash script that calls a command)
or **a list of strings** to be interpreted as the command to launch the language
server. By using a list of strings, you can use this to skip automatic
installation of a language server, and instead use the one found in your `$PATH`
during runtime, for example:

```nix
vim.languages.java = {
  lsp = {
    enable = true;

    # This expects 'jdt-language-server' to be in your PATH or in
    # 'vim.extraPackages.' There are no additional checks performed to see
    # if the command provided is valid.
    package = ["jdt-language-server" "-data" "~/.cache/jdtls/workspace"];
  };
}
```

### Using DAGs {#ch-using-dags}

We conform to the NixOS options types for the most part, however, a noteworthy
addition for certain options is the
[**DAG (Directed acyclic graph)**](https://en.wikipedia.org/wiki/Directed_acyclic_graph)
type which is borrowed from home-manager's extended library. This type is most
used for topologically sorting strings. The DAG type allows the attribute set
entries to express dependency relations among themselves. This can, for example,
be used to control the order of configuration sections in your `luaConfigRC`.

The below section, mostly taken from the
[home-manager manual](https://raw.githubusercontent.com/nix-community/home-manager/master/docs/manual/writing-modules/types.md)
explains in more detail the overall usage logic of the DAG type.

#### entryAnywhere {#sec-types-dag-entryAnywhere}

> `lib.dag.entryAnywhere (value: T) : DagEntry<T>`

Indicates that `value` can be placed anywhere within the DAG. This is also the
default for plain attribute set entries, that is

```nix
foo.bar = {
  a = lib.dag.entryAnywhere 0;
}
```

and

```nix
foo.bar = {
  a = 0;
}
```

are equivalent.

#### entryAfter {#ch-types-dag-entryAfter}

> `lib.dag.entryAfter (afters: list string) (value: T) : DagEntry<T>`

Indicates that `value` must be placed _after_ each of the attribute names in the
given list. For example

```nix
foo.bar = {
  a = 0;
  b = lib.dag.entryAfter [ "a" ] 1;
}
```

would place `b` after `a` in the graph.

#### entryBefore {#ch-types-dag-entryBefore}

> `lib.dag.entryBefore (befores: list string) (value: T) : DagEntry<T>`

Indicates that `value` must be placed _before_ each of the attribute names in
the given list. For example

```nix
foo.bar = {
  b = lib.dag.entryBefore [ "a" ] 1;
  a = 0;
}
```

would place `b` before `a` in the graph.

#### entryBetween {#sec-types-dag-entryBetween}

> `lib.dag.entryBetween (befores: list string) (afters: list string) (value: T) : DagEntry<T>`

Indicates that `value` must be placed _before_ the attribute names in the first
list and _after_ the attribute names in the second list. For example

```nix
foo.bar = {
  a = 0;
  c = lib.dag.entryBetween [ "b" ] [ "a" ] 2;
  b = 1;
}
```

would place `c` before `b` and after `a` in the graph.

There are also a set of functions that generate a DAG from a list. These are
convenient when you just want to have a linear list of DAG entries, without
having to manually enter the relationship between each entry. Each of these
functions take a `tag` as argument and the DAG entries will be named
`${tag}-${index}`.

#### entriesAnywhere {#sec-types-dag-entriesAnywhere}

> `lib.dag.entriesAnywhere (tag: string) (values: [T]) : Dag<T>`

Creates a DAG with the given values with each entry labeled using the given tag.
For example

```nix
foo.bar = lib.dag.entriesAnywhere "a" [ 0 1 ];
```

is equivalent to

```nix
foo.bar = {
  a-0 = 0;
  a-1 = lib.dag.entryAfter [ "a-0" ] 1;
}
```

#### entriesAfter {#sec-types-dag-entriesAfter}

> `lib.dag.entriesAfter (tag: string) (afters: list string) (values: [T]) : Dag<T>`

Creates a DAG with the given values with each entry labeled using the given tag.
The list of values are placed are placed _after_ each of the attribute names in
`afters`. For example

```nix
foo.bar =
  { b = 0; } // lib.dag.entriesAfter "a" [ "b" ] [ 1 2 ];
```

is equivalent to

```nix
foo.bar = {
  b = 0;
  a-0 = lib.dag.entryAfter [ "b" ] 1;
  a-1 = lib.dag.entryAfter [ "a-0" ] 2;
}
```

#### entriesBefore {#sec-types-dag-entriesBefore}

> `lib.dag.entriesBefore (tag: string) (befores: list string) (values: [T]) : Dag<T>`

Creates a DAG with the given values with each entry labeled using the given tag.
The list of values are placed _before_ each of the attribute names in `befores`.
For example

```nix
foo.bar =
  { b = 0; } // lib.dag.entriesBefore "a" [ "b" ] [ 1 2 ];
```

is equivalent to

```nix
foo.bar = {
  b = 0;
  a-0 = 1;
  a-1 = lib.dag.entryBetween [ "b" ] [ "a-0" ] 2;
}
```

#### entriesBetween {#sec-types-dag-entriesBetween}

> `lib.dag.entriesBetween (tag: string) (befores: list string) (afters: list string) (values: [T]) : Dag<T>`

Creates a DAG with the given values with each entry labeled using the given tag.
The list of values are placed _before_ each of the attribute names in `befores`
and _after_ each of the attribute names in `afters`. For example

```nix
foo.bar =
  { b = 0; c = 3; } // lib.dag.entriesBetween "a" [ "b" ] [ "c" ] [ 1 2 ];
```

is equivalent to

```nix
foo.bar = {
  b = 0;
  c = 3;
  a-0 = lib.dag.entryAfter [ "c" ] 1;
  a-1 = lib.dag.entryBetween [ "b" ] [ "a-0" ] 2;
}
```

### DAG entries in nvf {#ch-dag-entries}

From the previous chapter, it should be clear that DAGs are useful, because you
can add code that relies on other code. However, if you don't know what the
entries are called, it's hard to do that, so here is a list of the internal
entries in nvf:

#### `vim.luaConfigRC` (top-level DAG) {#ch-vim-luaconfigrc}

1. (`luaConfigPre`) - not a part of the actual DAG, instead, it's simply
   inserted before the rest of the DAG
2. `globalsScript` - used to set globals defined in `vim.globals`
3. `basic` - used to set basic configuration options
4. `optionsScript` - used to set options defined in `vim.o`
5. `theme` (this is simply placed before `pluginConfigs` and `lazyConfigs`,
   meaning that surrounding entries don't depend on it) - used to set up the
   theme, which has to be done before other plugins
6. `lazyConfigs` - `lz.n` and `lzn-auto-require` configs. If `vim.lazy.enable`
   is false, this will contain each plugin's config instead.
7. `pluginConfigs` - the result of the nested `vim.pluginRC` (internal option,
   see the [Custom Plugins](/index.xhtml#ch-custom-plugins) page for adding your
   own plugins) DAG, used to set up internal plugins
8. `extraPluginConfigs` - the result of `vim.extraPlugins`, which is not a
   direct DAG, but is converted to, and resolved as one internally
9. `mappings` - the result of `vim.maps`

### Autocommands and Autogroups {#ch-autocmds-augroups}

This module allows you to declaratively configure Neovim autocommands and
autogroups within your Nix configuration.

#### Autogroups (`vim.augroups`) {#sec-vim-augroups}

Autogroups (`augroup`) organize related autocommands. This allows them to be
managed collectively, such as clearing them all at once to prevent duplicates.
Each entry in the list is a submodule with the following options:

| Option   | Type   | Default | Description                                                                                          | Example           |
| :------- | :----- | :------ | :--------------------------------------------------------------------------------------------------- | :---------------- |
| `enable` | `bool` | `true`  | Enables or disables this autogroup definition.                                                       | `true`            |
| `name`   | `str`  | _None_  | **Required.** The unique name for the autogroup.                                                     | `"MyFormatGroup"` |
| `clear`  | `bool` | `true`  | Clears any existing autocommands within this group before adding new ones defined in `vim.autocmds`. | `true`            |

**Example:**

```nix
{
  vim.augroups = [
    {
      name = "MyCustomAuGroup";
      clear = true; # Clear previous autocommands in this group on reload
    }
    {
      name = "Formatting";
      # clear defaults to true
    }
  ];
}
```

#### Autocommands (`vim.autocmds`) {#sec-vim-autocmds}

Autocommands (`autocmd`) trigger actions based on events happening within Neovim
(e.g., saving a file, entering a buffer). Each entry in the list is a submodule
with the following options:

| Option     | Type                  | Default | Description                                                                                                                                                                      | Example                                                          |
| :--------- | :-------------------- | :------ | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------- |
| `enable`   | `bool`                | `true`  | Enables or disables this autocommand definition.                                                                                                                                 | `true`                                                           |
| `event`    | `nullOr (listOf str)` | `null`  | **Required.** List of Neovim events that trigger this autocommand (e.g., `BufWritePre`, `FileType`).                                                                             | `[ "BufWritePre" ]`                                              |
| `pattern`  | `nullOr (listOf str)` | `null`  | List of file patterns (globs) to match against (e.g., `*.py`, `*`). If `null`, matches all files for the given event.                                                            | `[ "*.lua", "*.nix" ]`                                           |
| `callback` | `nullOr luaInline`    | `null`  | A Lua function to execute when the event triggers. Use `lib.nvim.types.luaInline` or `lib.options.literalExpression "mkLuaInline '''...'''"`. **Cannot be used with `command`.** | `lib.nvim.types.luaInline "function() print('File saved!') end"` |
| `command`  | `nullOr str`          | `null`  | A Vimscript command to execute when the event triggers. **Cannot be used with `callback`.**                                                                                      | `"echo 'File saved!'"`                                           |
| `group`    | `nullOr str`          | `null`  | The name of an `augroup` (defined in `vim.augroups`) to associate this autocommand with.                                                                                         | `"MyCustomAuGroup"`                                              |
| `desc`     | `nullOr str`          | `null`  | A description for the autocommand (useful for introspection).                                                                                                                    | `"Format buffer on save"`                                        |
| `once`     | `bool`                | `false` | If `true`, the autocommand runs only once and then automatically removes itself.                                                                                                 | `false`                                                          |
| `nested`   | `bool`                | `false` | If `true`, allows this autocommand to trigger other autocommands.                                                                                                                | `false`                                                          |

> [!WARNING]
> You cannot define both `callback` (for Lua functions) and `command` (for
> Vimscript) for the same autocommand. Choose one.

**Examples:**

```nix
{ lib, ... }:
{
  vim.augroups = [ { name = "UserSetup"; } ];

  vim.autocmds = [
    # Example 1: Using a Lua callback
    {
      event = [ "BufWritePost" ];
      pattern = [ "*.lua" ];
      group = "UserSetup";
      desc = "Notify after saving Lua file";
      callback = lib.nvim.types.luaInline ''
        function()
          vim.notify("Lua file saved!", vim.log.levels.INFO)
        end
      '';
    }

    # Example 2: Using a Vim command
    {
      event = [ "FileType" ];
      pattern = [ "markdown" ];
      group = "UserSetup";
      desc = "Set spellcheck for Markdown";
      command = "setlocal spell";
    }

    # Example 3: Autocommand without a specific group
    {
      event = [ "BufEnter" ];
      pattern = [ "*.log" ];
      desc = "Disable line numbers in log files";
      command = "setlocal nonumber";
      # No 'group' specified
    }

    # Example 4: Using Lua for callback
    {
      event = [ "BufWinEnter" ];
      pattern = [ "*" ];
      desc = "Simple greeting on entering a buffer window";
      callback = lib.generators.mkLuaInline ''
        function(args)
          print("Entered buffer: " .. args.buf)
        end
      '';
      
      # Run only once per session trigger
      once = true; 
    }
  ];
}
```

These definitions are automatically translated into the necessary Lua code to
configure `vim.api.nvim_create_augroup` and `vim.api.nvim_create_autocmd` when
Neovim starts.

## Helpful Tips {#ch-helpful-tips}

This section provides helpful tips that may be considered "unorthodox" or "too
advanced" for some users. We will cover basic debugging steps, offline
documentation, configuring **nvf** with pure Lua and using custom plugin sources
in **nvf** in this section. For general configuration tips, please see previous
chapters.

```{=include=} chapters
tips/debugging-nvf.md
tips/offline-docs.md
tips/pure-lua-config.md
tips/plugin-sources.md
```

### Debugging nvf {#sec-debugging-nvf}

There may be instances where the your Nix configuration evaluates to invalid
Lua, or times when you will be asked to provide your built Lua configuration for
easier debugging by nvf maintainers. nvf provides two helpful utilities out of
the box.

**nvf-print-config** and **nvf-print-config-path** will be bundled with nvf as
lightweight utilities to help you view or share your built configuration when
necessary.

To view your configuration with syntax highlighting, you may use the
[bat pager](https://github.com/sharkdp/bat).

```bash
nvf-print-config | bat --language=lua
```

Alternatively, `cat` or `less` may also be used.

#### Accessing `neovimConfig` {#sec-accessing-config}

It is also possible to access the configuration for the wrapped package. The
_built_ Neovim package will contain a `neovimConfig` attribute in its
`passthru`.

### Offline Documentation {#sec-offline-documentation}

[https://notashelf.github.io/nvf/options.html]: https://notashelf.github.io/nvf/options.html

The manpages provided by nvf contains an offline version of the option search
normally available at [https://notashelf.github.io/nvf/options.html]. You may
use the `man 5 nvf` command to view option documentation from the comfort of
your terminal.

Note that this is only available for NixOS and Home-Manager module
installations.

### Pure Lua Configuration {#sec-pure-lua-config}

We recognize that you might not always want to configure your setup purely in
Nix, sometimes doing things in Lua is simply the "superior" option. In such a
case you might want to configure your Neovim instance using Lua, and nothing but
Lua. It is also possible to mix Lua and Nix configurations.

Pure Lua or hybrid Lua/Nix configurations can be achieved in two different ways.
_Purely_, by modifying Neovim's runtime directory or _impurely_ by placing Lua
configuration in a directory found in `$HOME`. For your convenience, this
section will document both methods as they can be used.

#### Pure Runtime Directory {#sec-pure-nvf-runtime}

As of 0.6, nvf allows you to modify Neovim's runtime path to suit your needs.
One of the ways the new runtime option is to add a configuration **located
relative to your `flake.nix`**, which must be version controlled in pure flakes
manner.

```nix
{
  # Let us assume we are in the repository root, i.e., the same directory as the
  # flake.nix. For the sake of the argument, we will assume that the Neovim lua
  # configuration is in a nvim/ directory relative to flake.nix.
  vim = {
    additionalRuntimeDirectories = [
      # This will be added to Neovim's runtime paths. Conceptually, this behaves
      # very similarly to ~/.config/nvim but you may not place a top-level
      # init.lua to be able to require it directly.
      ./nvim
    ];
  };
}
```

This will add the `nvim` directory, or rather, the _store path_ that will be
realised after your flake gets copied to the Nix store, to Neovim's runtime
directory. You may now create a `lua/myconfig` directory within this nvim
directory, and call it with [](#opt-vim.luaConfigRC).

```nix
{pkgs, ...}: {
  vim = {
    additionalRuntimeDirectories = [
      # You can list more than one file here.
      ./nvim-custom-1

      # To make sure list items are ordered, use lib.mkBefore or lib.mkAfter
      # Simply placing list items in a given order will **not** ensure that
      # this list  will be deterministic.
      ./nvim-custom-2
    ];

    startPlugins = [pkgs.vimPlugins.gitsigns];

    # Neovim supports in-line syntax highlighting for multi-line strings.
    # Simply place the filetype in a /* comment */ before the line.
    luaConfigRC.myconfig = /* lua */ ''
      -- Call the Lua module from ./nvim/lua/myconfig
      require("myconfig")

      -- Any additional Lua configuration that you might want *after* your own
      -- configuration. For example, a plugin setup call.
      require('gitsigns').setup({})
    '';
  };
}
```

#### Impure Absolute Directory {#sec-impure-absolute-dir}

[Neovim 0.9]: https://github.com/neovim/neovim/pull/22128

As of [Neovim 0.9], {var}`$NVIM_APPNAME` is a variable expected by Neovim to
decide on the configuration directory. nvf sets this variable as `"nvf"`,
meaning `~/.config/nvf` will be regarded as _the_ configuration directory by
Neovim, similar to how `~/.config/nvim` behaves in regular installations. This
allows some degree of Lua configuration, backed by our low-level wrapper
[mnw](https://github.com/Gerg-L/mnw). Creating a `lua/` directory located in
`$NVIM_APPNAME` ("nvf" by default) and placing your configuration in, e.g.,
`~/.config/nvf/lua/myconfig` will allow you to `require` it as a part of the Lua
module system through nvf's module system.

Let's assume your `~/.config/nvf/lua/myconfig/init.lua` consists of the
following:

```lua
-- init.lua
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "
```

The following Nix configuration via [](#opt-vim.luaConfigRC) will allow loading
this

```nix
{
  # The attribute name "myconfig-dir" here is arbitrary. It is required to be
  # a *named* attribute by the DAG system, but the name is entirely up to you.
  vim.luaConfigRC.myconfig-dir = ''
    require("myconfig")

    -- Any additional Lua
  '';
}
```

[DAG system]: https://notashelf.github.io/nvf/index.xhtml#ch-using-dags

After you load your custom configuration, you may use an `init.lua` located in
your custom configuration directory to configure Neovim exactly as you would
without a wrapper like nvf. If you want to place your `require` call in a
specific position (i.e., before or after options you set in nvf) the
[DAG system] will let you place your configuration in a location of your
choosing.

[top-level DAG system]: https://notashelf.github.io/nvf/index.xhtml#ch-vim-luaconfigrc

### Adding Plugins From Different Sources {#sec-plugin-sources}

**nvf** attempts to avoid depending on Nixpkgs for Neovim plugins. For the most
part, this is accomplished by defining each plugin's source and building them
from source.

[npins]: https://github.com/andir/npins

To define plugin sources, we use [npins] and pin each plugin source using
builtin fetchers. You are not bound by this restriction. In your own
configuration, any kind of fetcher or plugin source is fine.

#### Nixpkgs & Friends {#ch-plugins-from-nixpkgs}

`vim.startPlugins` and `vim.optPlugins` options take either a **string**, in
which case a plugin from nvf's internal plugins registry will be used, or a
**package**. If your plugin does not require any setup, or ordering for it s
configuration, then it is possible to add it to `vim.startPlugins` to load it on
startup.

```nix
{pkgs, ...}: {
  # Aerial does require some setup. In the case you pass a plugin that *does*
  # require manual setup, then you must also call the setup function.
  vim.startPlugins = [pkgs.vimPlugins.aerial-nvim];
}
```

[`vim.extraPlugins`]: https://notashelf.github.io/nvf/options.html#opt-vim.extraPlugins

This will fetch aerial.nvim from nixpkgs, and add it to Neovim's runtime path to
be loaded manually. Although for plugins that require manual setup, you are
encouraged to use [`vim.extraPlugins`].

```nix
{
  vim.extraPlugins = {
    aerial = {
      package = pkgs.vimPlugins.aerial-nvim;
      setup = "require('aerial').setup {}";
    };
  };
}
```

[custom plugins section]: https://notashelf.github.io/nvf/index.xhtml#ch-custom-plugins

More details on the extraPlugins API is documented in the
[custom plugins section].

#### Building Your Own Plugins {#ch-plugins-from-source}

In the case a plugin is not available in Nixpkgs, or the Nixpkgs package is
outdated (or, more likely, broken) it is possible to build the plugins from
source using a tool, such as [npins]. You may also use your _flake inputs_ as
sources.

Example using plugin inputs:

```nix
{
  # In your flake.nix
  inputs = {
    aerial-nvim = {
      url = "github:stevearc/aerial.nvim"
      flake = false;
    };
  };

  # Make sure that 'inputs' is properly propagated into Nvf, for example, through
  # specialArgs.
  outputs = { ... };
}
```

In the case, you may use the input directly for the plugin's source attribute in
`buildVimPlugin`.

```nix
# Make sure that 'inputs' is properly propagated! It will be missing otherwise
# and the resulting errors might be too obscure.
{inputs, ...}: let
  aerial-from-source = pkgs.vimUtils.buildVimPlugin {
      name = "aerial-nvim";
      src = inputs.aerial-nvim;
    };
in {
  vim.extraPlugins = {
    aerial = {
      package = aerial-from-source;
      setup = "require('aerial').setup {}";
    };
  };
}
```

Alternatively, if you do not want to keep track of the source using flake inputs
or npins, you may call `fetchFromGitHub` (or other fetchers) directly. An
example would look like this.

```nix
regexplainer = buildVimPlugin {
  name = "nvim-regexplainer";
  src = fetchFromGitHub {
    owner = "bennypowers";
    repo = "nvim-regexplainer";
    rev = "4250c8f3c1307876384e70eeedde5149249e154f";
    hash = "sha256-15DLbKtOgUPq4DcF71jFYu31faDn52k3P1x47GL3+b0=";
  };

  # The 'buildVimPlugin' imposes some "require checks" on all plugins build from
  # source. Failing tests, if they are not relevant, can be disabled using the
  # 'nvimSkipModule' argument to the 'buildVimPlugin' function.
  nvimSkipModule = [
    "regexplainer"
    "regexplainer.buffers.init"
    "regexplainer.buffers.popup"
    "regexplainer.buffers.register"
    "regexplainer.buffers.shared"
    "regexplainer.buffers.split"
    "regexplainer.component.descriptions"
    "regexplainer.component.init"
    "regexplainer.renderers.narrative.init"
    "regexplainer.renderers.narrative.narrative"
    "regexplainer.renderers.init"
    "regexplainer.utils.defer"
    "regexplainer.utils.init"
    "regexplainer.utils.treesitter"
  ];
}
```
