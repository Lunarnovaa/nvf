# Release Notes {#ch-release-notes}

This section lists the release notes for tagged version of **nvf** and the
current main current main branch

## Release 0.8 {#sec-release-0.8}

### Breaking changes

[Lspsaga documentation]: https://nvimdev.github.io/lspsaga/

- `git-conflict` keybinds are now prefixed with `<leader>` to avoid conflicting
  with builtins.

- `alpha` is now configured with nix, default config removed.

- Lspsaga module no longer ships default keybindings. The keybind format has
  been changed by upstream, and old keybindings do not have equivalents under
  the new API they provide. Please manually set your keybinds according to
  [Lspsaga documentation] following the new API.

- none-ls has been updated to the latest version. If you have been using raw Lua
  configuration to _manually_ configure it, some of the formats may become
  unavailable as they have been refactored out of the main none-ls repository
  upstream.

- `vim.useSystemClipboard` has been deprecated as a part of removing most
  top-level convenience options, and should instead be configured in the new
  module interface. You may set [](#opt-vim.clipboard.registers) appropriately
  to configure Neovim to use the system clipboard.

[NotAShelf](https://github.com/notashelf):

[typst-preview.nvim]: https://github.com/chomosuke/typst-preview.nvim
[render-markdown.nvim]: https://github.com/MeanderingProgrammer/render-markdown.nvim
[yanky.nvim]: https://github.com/gbprod/yanky.nvim
[yazi.nvim]: https://github.com/mikavilpas/yazi.nvim
[snacks.nvim]: https://github.com/folke/snacks.nvim
[oil.nvim]: https://github.com/stevearc/oil.nvim

- Add [typst-preview.nvim] under
  `languages.typst.extensions.typst-preview-nvim`.

- Add a search widget to the options page in the nvf manual.

- Add [render-markdown.nvim] under
  `languages.markdown.extensions.render-markdown-nvim`.

- Implement [](#opt-vim.git.gitsigns.setupOpts) for user-specified setup table
  in gitsigns configuration.

- [](#opt-vim.options.mouse) no longer compares values to an enum of available
  mouse modes. This means you can provide any string without the module system
  warning you that it is invalid. Do keep in mind that this value is no longer
  checked, so you will be responsible for ensuring its validity.

- Deprecate `vim.enableEditorconfig` in favor of
  [](#opt-vim.globals.editorconfig).

- Deprecate rnix-lsp as it has been abandoned and archived upstream.

- Hardcoded indentation values for the Nix language module have been removed. To
  replicate previous behaviour, you must either consolidate Nix indentation in
  your Editorconfig configuration, or use an autocommand to set indentation
  values for buffers with the Nix filetype.

- Add [](#opt-vim.lsp.lightbulb.autocmd.enable) for manually managing the
  previously managed lightbulb autocommand.

  - A warning will occur if [](#opt-vim.lsp.lightbulb.autocmd.enable) and
    `vim.lsp.lightbulb.setupOpts.autocmd.enabled` are both set at the same time.
    Pick only one.

- Add [yanky.nvim] to available plugins, under `vim.utility.yanky-nvim`.

- Fix plugin `setupOpts` for yanky.nvim and assert if shada is configured as a
  backend while shada is disabled in Neovim options.

- Add [yazi.nvim] as a companion plugin for Yazi, the terminal file manager.

- Add [](#opt-vim.autocmds) and [](#opt-vim.augroups) to allow declaring
  autocommands via Nix.

- Fix plugin `setupOpts` for yanky.nvim and assert if shada is configured as a
  backend while shada is disabled in Neovim options.

- Add [yazi.nvim] as a companion plugin for Yazi, the terminal file manager.

- Add [snacks.nvim] under `vim.utility.snacks-nvim` as a general-purpose utility
  plugin.

- Move LSPSaga to `setupOpts` format, allowing freeform configuration in
  `vim.lsp.lspsaga.setupOpts`.

- Lazyload Lspsaga and remove default keybindings for it.

- Add [oil.nvim] as an alternative file explorer. It will be available under
  `vim.utility.oil-nvim`.

- Add `vim.diagnostics` to interact with Neovim's diagnostics module. Available
  options for `vim.diagnostic.config()` can now be customized through the
  [](#opt-vim.diagnostics.config) in nvf.

- Add `vim.clipboard` module for easily managing Neovim clipboard providers and
  relevant packages in a simple UI.
  - This deprecates `vim.useSystemClipboard` as well, see breaking changes
    section above for migration options.

[amadaluzia](https://github.com/amadaluzia):

[haskell-tools.nvim]: https://github.com/MrcJkb/haskell-tools.nvim

- Add Haskell support under `vim.languages.haskell` using [haskell-tools.nvim].

[horriblename](https://github.com/horriblename):

[blink.cmp]: https://github.com/saghen/blink.cmp

- Add [aerial.nvim].
- Add [nvim-ufo].
- Add [blink.cmp] support.
- Add `LazyFile` user event.
- Migrate language modules from none-ls to conform/nvim-lint
- Add tsx support in conform and lint
- Moved code setting `additionalRuntimePaths` and `enableLuaLoader` out of
  `luaConfigPre`'s default to prevent being overridden
- Use conform over custom autocmds for LSP format on save

[diniamo](https://github.com/diniamo):

- Add Odin support under `vim.languages.odin`.

- Disable the built-in format-on-save feature of zls. Use `vim.lsp.formatOnSave`
  instead.

[LilleAila](https://github.com/LilleAila):

- Remove `vim.notes.obsidian.setupOpts.dir`, which was set by default. Fixes
  issue with setting the workspace directory.
- Add `vim.snippets.luasnip.setupOpts`, which was previously missing.
- Add `"prettierd"` as a formatter option in
  `vim.languages.markdown.format.type`.
- Add the following plugins from
  [mini.nvim](https://github.com/echasnovski/mini.nvim)
  - `mini.ai`
  - `mini.align`
  - `mini.animate`
  - `mini.base16`
  - `mini.basics`
  - `mini.bracketed`
  - `mini.bufremove`
  - `mini.clue`
  - `mini.colors`
  - `mini.comment`
  - `mini.completion`
  - `mini.deps`
  - `mini.diff`
  - `mini.doc`
  - `mini.extra`
  - `mini.files`
  - `mini.fuzzy`
  - `mini.git`
  - `mini.hipatterns`
  - `mini.hues`
  - `mini.icons`
  - `mini.indentscope`
  - `mini.jump`
  - `mini.jump2d`
  - `mini.map`
  - `mini.misc`
  - `mini.move`
  - `mini.notify`
  - `mini.operators`
  - `mini.pairs`
  - `mini.pick`
  - `mini.sessions`
  - `mini.snippets`
  - `mini.splitjoin`
  - `mini.starter`
  - `mini.statusline`
  - `mini.surround`
  - `mini.tabline`
  - `mini.test`
  - `mini.trailspace`
  - `mini.visits`
- Add [fzf-lua](https://github.com/ibhagwan/fzf-lua) in `vim.fzf-lua`
- Add [rainbow-delimiters](https://github.com/HiPhish/rainbow-delimiters.nvim)
  in `vim.visuals.rainbow-delimiters`
- Add options to define highlights under [](#opt-vim.highlight)

[kaktu5](https://github.com/kaktu5):

- Add WGSL support under `vim.languages.wgsl`.

[tomasguinzburg](https://github.com/tomasguinzburg):

[solargraph]: https://github.com/castwide/solargraph
[gbprod/nord.nvim]: https://github.com/gbprod/nord.nvim

- Add Ruby support under `vim.languages.ruby` using [solargraph].
- Add `nord` theme from [gbprod/nord.nvim].

[thamenato](https://github.com/thamenato):

[ruff]: (https://github.com/astral-sh/ruff)
[cue]: (https://cuelang.org/)

- Add [ruff] as a formatter option in `vim.languages.python.format.type`.
- Add [cue] support under `vim.languages.cue`.

[ARCIII](https://github.com/ArmandoCIII):

[leetcode.nvim]: https://github.com/kawre/leetcode.nvim
[codecompanion-nvim]: https://github.com/olimorris/codecompanion.nvim

- Add `vim.languages.zig.dap` support through pkgs.lldb dap adapter. Code
  Inspiration from `vim.languages.clang.dap` implementation.
- Add [leetcode.nvim] plugin under `vim.utility.leetcode-nvim`.
- Add [codecompanion.nvim] plugin under `vim.assistant.codecompanion-nvim`.
- Fix [codecompanion-nvim] plugin: nvim-cmp error and setupOpts defaults.

[nezia1](https://github.com/nezia1):

- Add support for [nixd](https://github.com/nix-community/nixd) language server.

[jahanson](https://github.com/jahanson):

- Add [multicursors.nvim](https://github.com/smoka7/multicursors.nvim) to
  available plugins, under `vim.utility.multicursors`.
- Add [hydra.nvim](https://github.com/nvimtools/hydra.nvim) as dependency for
  `multicursors.nvim` and lazy loads by default.

[folospior](https://github.com/folospior):

- Fix plugin name for lsp/lspkind.

- Move `vim-illuminate` to `setupOpts format`

[iynaix](https://github.com/iynaix):

- Add lsp options support for [nixd](https://github.com/nix-community/nixd)
  language server.

[Mr-Helpful](https://github.com/Mr-Helpful):

- Corrects pin names used for nvim themes.

[Libadoxon](https://github.com/Libadoxon):

- Add [git-conflict](https://github.com/akinsho/git-conflict.nvim) plugin for
  resolving git conflicts.
- Add formatters for go: [gofmt](https://go.dev/blog/gofmt),
  [golines](https://github.com/segmentio/golines) and
  [gofumpt](https://github.com/mvdan/gofumpt).

[UltraGhostie](https://github.com/UltraGhostie)

- Add [harpoon](https://github.com/ThePrimeagen/harpoon) plugin for navigation

[MaxMur](https://github.com/TheMaxMur):

- Add YAML support under `vim.languages.yaml`.

[alfarel](https://github.com/alfarelcynthesis):

[conform.nvim]: https://github.com/stevearc/conform.nvim

- Add missing `yazi.nvim` dependency (`snacks.nvim`).
- Add [mkdir.nvim](https://github.com/jghauser/mkdir.nvim) plugin for automatic
  creation of parent directories when editing a nested file.
- Add [nix-develop.nvim](https://github.com/figsoda/nix-develop.nvim) plugin for
  in-neovim `nix develop`, `nix shell` and more.
- Add [direnv.vim](https://github.com/direnv/direnv.vim) plugin for automatic
  syncing of nvim shell environment with direnv's.
- Add [blink.cmp] source options and some default-disabled sources.
- Add [blink.cmp] option to add
  [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) so
  blink.cmp can source snippets from it.
- Fix [blink.cmp] breaking when built-in sources were modified.
- Fix [conform.nvim] not allowing disabling formatting on and after save. Use
  `null` value to disable them if conform is enabled.

[TheColorman](https://github.com/TheColorman):

- Fix plugin `setupOpts` for `neovim-session-manager` having an invalid value
  for `autoload_mode`.

[esdevries](https://github.com/esdevries):

[projekt0n/github-nvim-theme]: https://github.com/projekt0n/github-nvim-theme

- Add `github-nvim-theme` theme from [projekt0n/github-nvim-theme].

[BANanaD3V](https://github.com/BANanaD3V):

- `alpha` is now configured with nix.
- Add `markview-nvim` markdown renderer.

[viicslen](https://github.com/viicslen):

- Add `intelephense` language server support under
  `vim.languages.php.lsp.server`

[Butzist](https://github.com/butzist):

- Add Helm chart support under `vim.languages.helm`.

[rice-cracker-dev](https://github.com/rice-cracker-dev):

- `eslint_d` now checks for configuration files to load.
- Fix an error where `eslint_d` fails to load.
- Add required files support for linters under
  `vim.diagnostics.nvim-lint.linters.*.required_files`.
- Add global function `nvf_lint` under
  `vim.diagnostics.nvim-lint.lint_function`.
- Deprecate `vim.scrollOffset` in favor of `vim.options.scrolloff`.

[Sc3l3t0n](https://github.com/Sc3l3t0n):

- Add F# support under `vim.languages.fsharp`.

[venkyr77](https://github.com/venkyr77):

- Add lint (luacheck) and formatting (stylua) support for Lua.
- Add lint (markdownlint-cli2) support for Markdown.
- Add catppuccin integration for Bufferline, Lspsaga.
- Add `neo-tree`, `snacks.explorer` integrations to `bufferline`.
- Add more applicable filetypes to illuminate denylist.
- Disable mini.indentscope for applicable filetypes.
- Fix fzf-lua having a hard dependency on fzf.
- Enable inlay hints support - `config.vim.lsp.inlayHints`.
- Add `neo-tree`, `snacks.picker` extensions to `lualine`.
- Add support for `vim.lsp.formatOnSave` and
  `vim.lsp.mappings.toggleFormatOnSave`

[tebuevd](https://github.com/tebuevd):

- Fix `pickers` configuration for `telescope` by nesting it under `setupOpts`
- Fix `find_command` configuration for `telescope` by nesting it under
  `setupOpts.pickers.find_files`
- Update default `telescope.setupOpts.pickers.find_files.find_command` to only
  include files (and therefore exclude directories from results)

[ckoehler](https://github.com/ckoehler):

[flash.nvim]: https://github.com/folke/flash.nvim
[gitlinker.nvim]: https://github.com/linrongbin16/gitlinker.nvim
[nvim-treesitter-textobjects]: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

- Fix oil config referencing snacks
- Add [flash.nvim] plugin to `vim.utility.motion.flash-nvim`
- Fix default telescope ignore list entry for '.git/' to properly match
- Add [gitlinker.nvim] plugin to `vim.git.gitlinker-nvim`
- Add [nvim-treesitter-textobjects] plugin to `vim.treesitter.textobjects`
- Default to disabling Conform for Rust if rust-analyzer is used
  - To force using Conform, set `languages.rust.format.enable = true`.

[rrvsh](https://github.com/rrvsh):

- Fix namespace of python-lsp-server by changing it to python3Packages

[Noah765](https://github.com/Noah765):

[vim-sleuth]: https://github.com/tpope/vim-sleuth

- Add missing `flutter-tools.nvim` dependency `plenary.nvim`.
- Add necessary dependency of `flutter-tools.nvim` on lsp.
- Add the `vim.languages.dart.flutter-tools.flutterPackage` option.
- Fix the type of the `highlight` color options.
- Add [vim-sleuth] plugin under `vim.utility.sleuth`.

[howird](https://github.com/howird):

- Change python dap adapter name from `python` to commonly expected `debugpy`.

[aionoid](https://github.com/aionoid):

[avante-nvim]: https://github.com/yetone/avante.nvim

- Fix [render-markdown.nvim] file_types option type to list, to accept merging.
- Add [avante.nvim] plugin under `vim.assistant.avante-nvim`.

[poz](https://poz.pet):

- Fix gitsigns null-ls issue.

[Haskex](https://github.com/haskex):

[Hardtime.nvim]: https://github.com/m4xshen/hardtime.nvim

- Add Plugin [Hardtime.nvim] under `vim.binds.hardtime-nvim` with `enable` and
  `setupOpts` options

[taylrfnt](https://github.com/taylrfnt):

[nvim-tree](https://github.com/nvim-tree/nvim-tree.lua):

- Add missing `right_align` option for existing `renderer.icons` options.
- Add missing `render.icons` options (`hidden_placement`,
  `diagnostics_placement`, and `bookmarks_placement`).

[cramt](https://github.com/cramt):

- Add `rubylsp` option in `vim.languages.ruby.lsp.server` to use shopify's
  ruby-lsp language server

[Haskex](https://github.com/haskex):

[solarized-osaka.nvim]: https://github.com/craftzdog/solarized-osaka.nvim

- Add [solarized-osaka.nvim] theme

[img-clip.nvim]: https://github.com/hakonharnes/img-clip.nvim

- Add [img-clip.nvim] plugin in `vim.utility.images.img-clip` with `enable` and
  `setupOpts`
- Add `vim.utility.images.img-clip.enable = isMaximal` in configuration.nix

[anil9](https://github.com/anil9):

[clojure-lsp]: https://github.com/clojure-lsp/clojure-lsp
[conjure]: https://github.com/Olical/conjure

- Add Clojure support under `vim.languages.clojure` using [clojure-lsp]
- Add code evaluation environment [conjure] under `vim.repl.conjure`

[CallumGilly](https://github.com/CallumGilly):

- Add missing `transparent` option for existing
  [onedark.nvim](https://github.com/navarasu/onedark.nvim) theme.

[theutz](https://github.com/theutz):

- Added "auto" flavour for catppuccin theme

[lackac](https://github.com/lackac):

[solarized.nvim]: https://github.com/maxmx03/solarized.nvim

- Add [solarized.nvim] theme with support for multiple variants

## Release 0.7 {#sec-release-0.7}

Release notes for release 0.7

### Breaking Changes and Migration Guide {#sec-breaking-changes-and-migration-guide-0-7}

#### `vim.configRC` removed {#sec-vim-configrc-removed}

In v0.7 we are removing `vim.configRC` in favor of making `vim.luaConfigRC` the
top-level DAG, and thereby making the entire configuration Lua based. This
change introduces a few breaking changes:

[DAG entries in nvf manual]: /index.xhtml#ch-dag-entries

- `vim.configRC` has been removed, which means that you have to convert all of
  your custom vimscript-based configuration to Lua. As for how to do that, you
  will have to consult the Neovim documentation and your search engine.
- After migrating your Vimscript-based configuration to Lua, you might not be
  able to use the same entry names in `vim.luaConfigRC`, because those have also
  slightly changed. See the new [DAG entries in nvf manual] for more details.

**Why?**

Neovim being an aggressive refactor of Vim, is designed to be mainly Lua based;
making good use of its extensive Lua API. Additionally, Vimscript is slow and
brings unnecessary performance overhead while working with different
configuration formats.

#### `vim.maps` rewrite {#sec-vim-maps-rewrite}

Instead of specifying map modes using submodules (e.g., `vim.maps.normal`), a
new `vim.keymaps` submodule with support for a `mode` option has been
introduced. It can be either a string, or a list of strings, where a string
represents the short-name of the map mode(s), that the mapping should be set
for. See `:help map-modes` for more information.

For example:

```nix
vim.maps.normal."<leader>m" = { ... };
```

has to be replaced by

```nix
vim.keymaps = [
  {
    key = "<leader>m";
    mode = "n";
  }
  ...
];
```

#### `vim.lsp.nvimCodeActionMenu` removed in favor of `vim.ui.fastaction` {#sec-nvim-code-action-menu-deprecation}

The nvim-code-action-menu plugin has been archived and broken for a long time,
so it's being replaced with a young, but better alternative called
fastaction.nvim. Simply remove everything set under
`vim.lsp.nvimCodeActionMenu`, and set `vim.ui.fastaction.enable` to `true`.

Note that we are looking to add more alternatives in the future like
dressing.nvim and actions-preview.nvim, in case fastaction doesn't work for
everyone.

#### `type` based modules removed {#sec-type-based-modules-removed}

As part of the autocompletion rewrite, modules that used to use a `type` option
have been replaced by per-plugin modules instead. Since both modules only had
one type, you can simply change

- `vim.autocomplete.*` -> `vim.autocomplete.nvim-cmp.*`
- `vim.autopairs.enable` -> `vim.autopairs.nvim-autopairs.enable`

#### `nixpkgs-fmt` removed in favor of `nixfmt` {#sec-nixpkgs-fmt-deprecation}

`nixpkgs-fmt` has been archived for a while, and it's finally being removed in
favor of nixfmt (more information can be found
[here](https://github.com/nix-community/nixpkgs-fmt?tab=readme-ov-file#nixpkgs-fmt---nix-code-formatter-for-nixpkgs).

To migrate to `nixfmt`, simply change `vim.languages.nix.format.type` to
`nixfmt`.

#### leader changes {#sec-leader-changes}

This has been deprecated in favor of using the more generic `vim.globals` (you
can use `vim.globals.mapleader` to change this instead).

Rust specific keymaps now use `maplocalleader` instead of `localleader` by
default. This is to avoid conflicts with other modules. You can change
`maplocalleader` with `vim.globals.maplocalleader`, but it's recommended to set
it to something other than `mapleader` to avoid conflicts.

#### `vim.*` changes {#sec-vim-opt-changes}

Inline with the [leader changes](#sec-leader-changes), we have removed some
options that were under `vim` as convenient shorthands for `vim.o.*` options.

> [!WARNING]
> As v0.7 features the addition of [](#opt-vim.options), those options are now
> considered as deprecated. You should migrate to the appropriate options in the
> `vim.options` submodule.

The changes are, in no particular order:

- `colourTerm`, `mouseSupport`, `cmdHeight`, `updateTime`, `mapTime`,
  `cursorlineOpt`, `splitBelow`, `splitRight`, `autoIndent` and `wordWrap` have
  been mapped to their [](#opt-vim.options) equivalents. Please see the module
  definition for the updated options.

- `tabWidth` has been **removed** as it lead to confusing behaviour. You can
  replicate the same functionality by setting `shiftwidth`, `tabstop` and
  `softtabstop` under `vim.options` as you see fit.

### Changelog {#sec-release-0.7-changelog}

[ItsSorae](https://github.com/ItsSorae):

- Add support for [typst](https://typst.app/) under `vim.languages.typst` This
  will enable the `typst-lsp` language server, and the `typstfmt` formatter

[frothymarrow](https://github.com/frothymarrow):

- Modified type for
  [](#opt-vim.visuals.fidget-nvim.setupOpts.progress.display.overrides) from
  `anything` to a `submodule` for better type checking.

- Fix null `vim.lsp.mappings` generating an error and not being filtered out.

- Add basic transparency support for `oxocarbon` theme by setting the highlight
  group for `Normal`, `NormalFloat`, `LineNr`, `SignColumn` and optionally
  `NvimTreeNormal` to `none`.

- Fix [](#opt-vim.ui.smartcolumn.setupOpts.custom_colorcolumn) using the wrong
  type `int` instead of the expected type `string`.

[horriblename](https://github.com/horriblename):

- Fix broken treesitter-context keybinds in visual mode
- Deprecate use of `__empty` to define empty tables in Lua. Empty attrset are no
  longer filtered and thus should be used instead.
- Add dap-go for better dap configurations
- Make noice.nvim customizable
- Standardize border style options and add custom borders
- Remove `vim.disableDefaultRuntimePaths` in wrapper options.
  - As nvf uses `$NVIM_APP_NAME` as of recent changes, we can safely assume any
    configuration in `$XDG_CONFIG_HOME/nvf` is intentional.

[rust-tools.nvim]: https://github.com/simrat39/rust-tools.nvim
[rustaceanvim]: https://github.com/mrcjkb/rustaceanvim

- Switch from [rust-tools.nvim] to the more feature-packed [rustaceanvim]. This
  switch entails a whole bunch of new features and options, so you are
  recommended to go through rustacean.nvim's README to take a closer look at its
  features and usage

[lz.n]: https://github.com/mrcjkb/lz.n

- Add [lz.n] support and lazy-load some builtin plugins.
- Add simpler helper functions for making keymaps

[poz](https://poz.pet):

[ocaml-lsp]: https://github.com/ocaml/ocaml-lsp
[new-file-template.nvim]: https://github.com/otavioschwanck/new-file-template.nvim
[neo-tree.nvim]: https://github.com/nvim-neo-tree/neo-tree.nvim

- Add [ocaml-lsp] support

- Fix "Emac" typo

- Add [new-file-template.nvim] to automatically fill new file contents using
  templates

- Make [neo-tree.nvim] display file icons properly by enabling
  `visuals.nvimWebDevicons`

[diniamo](https://github.com/diniamo):

- Move the `theme` dag entry to before `luaScript`.

- Add rustfmt as the default formatter for Rust.

- Enabled the terminal integration of catppuccin for theming Neovim's built-in
  terminal (this also affects toggleterm).

- Migrate bufferline to setupOpts for more customizability

- Use `clangd` as the default language server for C languages

- Expose `lib.nvim.types.pluginType`, which for example allows the user to
  create abstractions for adding plugins

- Migrate indent-blankline to setupOpts for more customizability. While the
  plugin's options can now be found under `indentBlankline.setupOpts`, the
  previous iteration of the module also included out of place/broken options,
  which have been removed for the time being. These are:

  - `listChar` - this was already unused
  - `fillChar` - this had nothing to do with the plugin, please configure it
    yourself by adding `vim.opt.listchars:append({ space = '<char>' })` to your
    lua configuration
  - `eolChar` - this also had nothing to do with the plugin, please configure it
    yourself by adding `vim.opt.listchars:append({ eol = '<char>' })` to your
    lua configuration

- Replace `vim.lsp.nvimCodeActionMenu` with `vim.ui.fastaction`, see the
  breaking changes section above for more details

- Add a `setupOpts` option to nvim-surround, which allows modifying options that
  aren't defined in nvf. Move the alternate nvim-surround keybinds to use
  `setupOpts`.

- Remove `autopairs.type`, and rename `autopairs.enable` to
  `autopairs.nvim-autopairs.enable`. The new
  [](#opt-vim.autopairs.nvim-autopairs.enable) supports `setupOpts` format by
  default.

- Refactor of `nvim-cmp` and completion related modules

  - Remove `autocomplete.type` in favor of per-plugin enable options such as
    [](#opt-vim.autocomplete.nvim-cmp.enable).
  - Deprecate legacy Vimsnip in favor of Luasnip, and integrate
    friendly-snippets for bundled snippets. [](#opt-vim.snippets.luasnip.enable)
    can be used to toggle Luasnip.
  - Add sorting function options for completion sources under
    [](#opt-vim.autocomplete.nvim-cmp.setupOpts.sorting.comparators)

- Add C# support under `vim.languages.csharp`, with support for both
  omnisharp-roslyn and csharp-language-server.

- Add Julia support under `vim.languages.julia`. Note that the entirety of Julia
  is bundled with nvf, if you enable the module, since there is no way to
  provide only the LSP server.

- Add [`run.nvim`](https://github.com/diniamo/run.nvim) support for running code
  using cached commands.

[Neovim documentation on `vim.cmd`]: https://neovim.io/doc/user/lua.html#vim.cmd()

- Make Neovim's configuration file entirely Lua based. This comes with a few
  breaking changes:

  - `vim.configRC` has been removed. You will need to migrate your entries to
    Neovim-compliant Lua code, and add them to `vim.luaConfigRC` instead.
    Existing vimscript configurations may be preserved in `vim.cmd` functions.
    Please see [Neovim documentation on `vim.cmd`]
  - `vim.luaScriptRC` is now the top-level DAG, and the internal `vim.pluginRC`
    has been introduced for setting up internal plugins. See the "DAG entries in
    nvf" manual page for more information.

- Rewrite `vim.maps`, see the breaking changes section above.

[NotAShelf](https://github.com/notashelf):

[ts-error-translator.nvim]: https://github.com/dmmulroy/ts-error-translator.nvim
[credo]: https://github.com/rrrene/credo
[tiny-devicons-auto-colors]: https://github.com/rachartier/tiny-devicons-auto-colors.nvim

- Add `deno fmt` as the default Markdown formatter. This will be enabled
  automatically if you have autoformatting enabled, but can be disabled manually
  if you choose to.

- Add `vim.extraLuaFiles` for optionally sourcing additional lua files in your
  configuration.

- Refactor `programs.languages.elixir` to use lspconfig and none-ls for LSP and
  formatter setups respectively. Diagnostics support is considered, and may be
  added once the [credo] linter has been added to nixpkgs. A pull request is
  currently open.

- Remove vim-tidal and friends.

- Clean up Lualine module to reduce theme dependency on Catppuccin, and fixed
  blending issues in component separators.

- Add [ts-ereror-translator.nvim] extension of the TS language module, under
  `vim.languages.ts.extensions.ts-error-translator` to aid with Typescript
  development.

- Add [neo-tree.nvim] as an alternative file-tree plugin. It will be available
  under `vim.filetree.neo-tree`, similar to nvimtree.

- Add `nvf-print-config` & `nvf-print-config-path` helper scripts to Neovim
  closure. Both of those scripts have been automatically added to your PATH upon
  using neovimConfig or `programs.nvf.enable`.

  - `nvf-print-config` will display your `init.lua`, in full.
  - `nvf-print-config-path` will display the path to _a clone_ of your
    `init.lua`. This is not the path used by the Neovim wrapper, but an
    identical clone.

- Add `vim.ui.breadcrumbs.lualine` to allow fine-tuning breadcrumbs behaviour on
  Lualine. Only `vim.ui.breadcrumbs.lualine.winbar` is supported for the time
  being.

  - [](#opt-vim.ui.breadcrumbs.lualine.winbar.enable) has been added to allow
    controlling the default behaviour of the `nvim-navic` component on Lualine,
    which used to occupy `winbar.lualine_c` as long as breadcrumbs are enabled.
  - `vim.ui.breadcrumbs.alwaysRender` has been renamed to
    [](#opt-vim.ui.breadcrumbs.lualine.winbar.alwaysRender) to be conform to the
    new format.

- Add [basedpyright](https://github.com/detachhead/basedpyright) as a Python LSP
  server and make it default.

- Add [python-lsp-server](https://github.com/python-lsp/python-lsp-server) as an
  additional Python LSP server.

- Add [](#opt-vim.options) to set `vim.o` values in in your nvf configuration
  without using additional Lua. See option documentation for more details.

- Add [](#opt-vim.dashboard.dashboard-nvim.setupOpts) to allow user
  configuration for [dashboard.nvim](https://github.com/nvimdev/dashboard-nvim)

- Update `lualine.nvim` input and add missing themes:

  - Adds `ayu`, `gruvbox_dark`, `iceberg`, `moonfly`, `onedark`,
    `powerline_dark` and `solarized_light` themes.

- Add [](#opt-vim.spellcheck.extraSpellWords) to allow adding arbitrary
  spellfiles to Neovim's runtime with ease.

- Add combined nvf configuration (`config.vim`) into the final package's
  `passthru` as `passthru.neovimConfiguration` for easier debugging.

- Add support for [tiny-devicons-auto-colors] under
  `vim.visuals.tiny-devicons-auto-colors`

- Move options that used to set `vim.o` values (e.g. `vim.wordWrap`) into
  `vim.options` as default values. Some are left as they don't have a direct
  equivalent, but expect a switch eventually.

[ppenguin](https://github.com/ppenguin):

- Telescope:
  - Fixed `project-nvim` command and keybinding
  - Added default ikeybind/command for `Telescope resume` (`<leader>fr`)
- Add `hcl` lsp/formatter (not the same as `terraform`, which is not useful for
  e.g. `nomad` config files).

[Soliprem](https://github.com/Soliprem):

- Add LSP and Treesitter support for R under `vim.languages.R`.
  - Add formatter support for R, with styler and formatR as options
- Add Otter support under `vim.lsp.otter` and an assert to prevent conflict with
  ccc
- Fixed typo in Otter's setupOpts
- Add Neorg support under `vim.notes.neorg`
- Add LSP, diagnostics, formatter and Treesitter support for Kotlin under
  `vim.languages.kotlin`
- changed default keybinds for leap.nvim to avoid altering expected behavior
- Add LSP, formatter and Treesitter support for Vala under `vim.languages.vala`
- Add [Tinymist](https://github.com/Myriad-Dreamin/tinymist] as a formatter for
  the Typst language module.
- Add LSP and Treesitter support for Assembly under `vim.languages.assembly`
- Move [which-key](https://github.com/folke/which-key.nvim) to the new spec
- Add LSP and Treesitter support for Nushell under `vim.languages.nu`
- Add LSP and Treesitter support for Gleam under `vim.languages.gleam`

[Bloxx12](https://github.com/Bloxx12)

- Add support for [base16 theming](https://github.com/RRethy/base16-nvim) under
  `vim.theme`
- Fix internal breakage in `elixir-tools` setup.

[ksonj](https://github.com/ksonj):

- Add LSP support for Scala via
  [nvim-metals](https://github.com/scalameta/nvim-metals)

[nezia1](https://github.com/nezia1):

- Add [biome](https://github.com/biomejs/biome) support for Typescript, CSS and
  Svelte. Enable them via [](#opt-vim.languages.ts.format.type),
  [](#opt-vim.languages.css.format.type) and
  [](#opt-vim.languages.svelte.format.type) respectively.
- Replace [nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt) with
  [nixfmt](https://github.com/NixOS/nixfmt) (nixfmt-rfc-style).

[Nowaaru](https://github.com/Nowaaru):

- Add `precognition-nvim`.

[DamitusThyYeeticus123](https://github.com/DamitusThyYeetus123):

- Add support for [Astro](https://astro.build/) language server.

## Release 0.6 {#sec-release-0.6}

Release notes for release 0.6

### Breaking Changes and Migration Guide {#sec-breaking-changes-and-migration-guide}

In v0.6 we are introducing `setupOpts`: many plugin related options are moved
into their respective `setupOpts` submodule, e.g. `nvimTree.disableNetrw` is
renamed to `nvimTree.setupOpts.disable_netrw`.

_Why?_ in short, you can now pass in anything to setupOpts and it will be passed
to your `require'plugin'.setup{...}`. No need to wait for us to support every
single plugin option.

The warnings when you rebuild your config should be enough to guide you through
what you need to do, if there's an option that was renamed but wasn't listed in
the warning, please file a bug report!

To make your migration process less annoying, here's a keybind that will help
you with renaming stuff from camelCase to snake_case (you'll be doing that a
lot):

```lua
-- paste this in a temp.lua file and load it in vim with :source /path/to/temp.lua
function camelToSnake()
    -- Get the current word under the cursor
    local word = vim.fn.expand("<cword>")
    -- Replace each capital letter with an underscore followed by its lowercase equivalent
    local snakeCase = string.gsub(word, "%u", function(match)
        return "_" .. string.lower(match)
    end)
    -- Remove the leading underscore if present
    if string.sub(snakeCase, 1, 1) == "_" then
        snakeCase = string.sub(snakeCase, 2)
    end
    vim.fn.setreg(vim.v.register, snakeCase)
    -- Select the word under the cursor and paste
    vim.cmd("normal! viwP")
end

vim.api.nvim_set_keymap('n', '<leader>a', ':lua camelToSnake()<CR>', { noremap = true, silent = true })
```

### Changelog {#sec-release-0.6-changelog}

[ksonj](https://github.com/ksonj):

- Added Terraform language support.

- Added `ChatGPT.nvim`, which can be enabled with
  [](#opt-vim.assistant.chatgpt.enable). Do keep in mind that this option
  requires `OPENAI_API_KEY` environment variable to be set.

[donnerinoern](https://github.com/donnerinoern):

- Added Gruvbox theme.

- Added marksman LSP for Markdown.

- Fixed markdown preview with Glow not working and added an option for changing
  the preview keybind.

- colorizer.nvim: switched to a maintained fork.

- Added `markdown-preview.nvim`, moved `glow.nvim` to a brand new
  `vim.utility.preview` category.

[elijahimmer](https://github.com/elijahimmer)

- Added rose-pine theme.

[poz](https://poz.pet):

- Added `vim.autocomplete.alwaysComplete`. Allows users to have the autocomplete
  window popup only when manually activated.

[horriblename](https://github.com/horriblename):

- Fixed empty winbar when breadcrumbs are disabled.

- Added custom `setupOpts` for various plugins.

- Removed support for deprecated plugin "nvim-compe".

- Moved most plugins to `setupOpts` method.

[frothymarrow](https://github.com/frothymarrow):

- Added option `vim.luaPackages` to wrap neovim with extra Lua packages.

- Rewrote the entire `fidget.nvim` module to include extensive configuration
  options. Option `vim.fidget-nvim.align.bottom` has been removed in favor of
  `vim.fidget-nvim.notification.window.align`, which now supports `top` and
  `bottom` values. `vim.fidget-nvim.align.right` has no longer any equivalent
  and also has been removed.

- `which-key.nvim` categories can now be customized through
  [vim.binds.whichKey.register](#opt-vim.binds.whichKey.register)

- Added `magick` to `vim.luaPackages` for `image.nvim`.

- Added `alejandra` to the default devShell.

- Migrated neovim-flake to `makeNeovimUnstable` wrapper.

[notashelf](https://github.com/notashelf):

- Finished moving to `nixosOptionsDoc` in the documentation and changelog. All
  documentation options and files are fully free of Asciidoc, and will now use
  Nixpkgs flavored markdown.

- Bumped plugin inputs to their latest versions.

- Deprecated `presence.nvim` in favor of `neocord`. This means
  `vim.rich-presence.presence-nvim` is removed and will throw a warning if used.
  You are recommended to rewrite your neocord configuration from scratch based
  on the. [official documentation](https://github.com/IogaMaster/neocord)

- Removed Tabnine plugin due to the usage of imperative tarball downloads. If
  you'd like to see it back, please create an issue.

- Added support for css and tailwindcss through
  vscode-language-servers-extracted & tailwind-language-server. Those can be
  enabled through `vim.languages.css` and `vim.languages.tailwind`.

- Lualine module now allows customizing `always_divide_middle`, `ignore_focus`
  and `disabled_filetypes` through the new options:
  [vim.statusline.lualine.alwaysDivideMiddle](#opt-vim.statusline.lualine.alwaysDivideMiddle),
  [vim.statusline.lualine.ignoreFocus](#opt-vim.statusline.lualine.ignoreFocus)
  and
  [vim.statusline.lualine.disabledFiletypes](#opt-vim.statusline.lualine.disabledFiletypes).

- Updated all plugin inputs to their latest versions (**21.04.2024**) - this
  brought minor color changes to the Catppuccin theme.

- Moved home-manager module entrypoint to `flake/modules` and added an
  experimental Nixos module. This requires further testing before it can be
  considered ready for use.

- Made lib calls explicit. E.g. `lib.strings.optionalString` instead of
  `lib.optionalString`. This is a pattern expected to be followed by all
  contributors in the future.

- Added `image.nvim` for image previews.

- The final neovim package is now exposed. This means you can build the neovim
  package that will be added to your package list without rebuilding your system
  to test if your configuration yields a broken package.

- Changed the tree structure to distinguish between core options and plugin
  options.

- Added plugin auto-discovery from plugin inputs. This is mostly from
  [JordanIsaac's neovim-flake](https://github.com/jordanisaacs/neovim-flake).
  Allows contributors to add plugin inputs with the `plugin-` prefix to have
  them automatically discovered for the `plugin` type in `lib/types`.

- Moved internal `wrapLuaConfig` to the extended library, structured its
  arguments to take `luaBefore`, `luaConfig` and `luaAfter` as strings, which
  are then concatted inside a lua block.

- Added [](#opt-vim.luaConfigPre) and [](#opt-vim.luaConfigPost) for inserting
  verbatim Lua configuration before and after the resolved Lua DAG respectively.
  Both of those options take strings as the type, so you may read the contents
  of a Lua file from a given path.

- Added `vim.spellchecking.ignoredFiletypes` and
  `vim.spellChecking.programmingWordlist.enable` for ignoring certain filetypes
  in spellchecking and enabling `vim-dirtytalk` respectively. The previously
  used `vim.spellcheck.vim-dirtytalk` aliases to the latter option.

- Exposed `withRuby`, `withNodeJs`, `withPython3`, and `python3Packages` from
  the `makeNeovimConfig` function under their respective options.

- Added [](#opt-vim.extraPackages) for appending additional packages to the
  wrapper PATH, making said packages available while inside the Neovim session.

- Made Treesitter options configurable, and moved treesitter-context to
  `setupOpts` while it is enabled.

- Added [](#opt-vim.notify.nvim-notify.setupOpts.render) which takes either a
  string of enum, or a Lua function. The default is "compact", but you may
  change it according to nvim-notify documentation.

## Release 0.5 {#sec-release-0.5}

Release notes for release 0.5

### Changelog {#sec-release-0.5-changelog}

[vagahbond](https://github.com/vagahbond):

- Added phan language server for PHP

- Added phpactor language server for PHP

[horriblename](https://github.com/horriblename):

- Added transparency support for tokyonight theme

- Fixed a bug where cmp's close and scrollDocs mappings wasn't working

- Streamlined and simplified extra plugin API with the addition of
  [](#opt-vim.extraPlugins)

- Allow using command names in place of LSP packages to avoid automatic
  installation

- Add lua LSP and Treesitter support, and neodev.nvim plugin support

- Add [](#opt-vim.lsp.mappings.toggleFormatOnSave) keybind

[amanse](https://github.com/amanse):

- Added daily notes options for obsidian plugin

- Added `jdt-language-server` for Java

[yavko](https://github.com/yavko):

- Added Deno Language Server for Javascript/Typescript

- Added support for multiple languages under `vim.spellChecking.languages`, and
  added vim-dirtytalk through `vim.spellChecking.enableProgrammingWordList`

[frothymarrow](https://github.com/FrothyMarrow):

- Renamed `vim.visuals.cursorWordline` to `vim.visuals.cursorline.enable`

- Added `vim.visuals.cursorline.lineNumbersOnly` to display cursorline only in
  the presence of line numbers

- Added Oxocarbon to the list of available themes.

[notashelf](https://github.com/notashelf):

- Added GitHub Copilot to nvim-cmp completion sources.

- Added [](#opt-vim.ui.borders.enable) for global and individual plugin border
  configuration.

- LSP integrated breadcrumbs with [](#opt-vim.ui.breadcrumbs.enable) through
  nvim-navic

- LSP navigation helper with nvim-navbuddy, depends on nvim-navic (automatically
  enabled if navic is enabled)

- Added nvim-navic integration for Catppuccin theme

- Fixed mismatching Zig language description

- Added support for `statix` and `deadnix` through
  [](#opt-vim.languages.nix.extraDiagnostics.types)

- Added `lsp_lines` plugin for showing diagnostic messages

- Added a configuration option for choosing the leader key

- The package used for neovim is now customizable by the user, using
  [](#opt-vim.package). For best results, always use an unwrapped package

- Added highlight-undo plugin for highlighting undo/redo targets

- Added bash LSP and formatter support

- Disabled Lualine LSP status indicator for Toggleterm buffer

- Added `nvim-docs-view`, a plugin to display LSP hover documentation in a side
  panel

- Switched to `nixosOptionsDoc` in option documentation. To quote home-manager
  commit: "Output is mostly unchanged aside from some minor typographical and
  formatting changes, along with better source links."

- Updated indent-blankine.nvim to v3 - this comes with a few option changes,
  which will be migrated with `renamedOptionModule`

[poz](https://poz.pet):

- Fixed scrollOffset not being used

- Updated clangd to 16

- Disabled `useSystemClipboard` by default

[ksonj](https://github.com/ksonj):

- Add support to change mappings to utility/surround

- Add black-and-isort python formatter

- Removed redundant "Enable ..." in `mkEnableOption` descriptions

- Add options to modify LSP key bindings and add proper which-key descriptions

- Changed type of `statusline.lualine.activeSection` and
  `statusline.lualine.inactiveSection` from `attrsOf str` to
  `attrsOf (listOf str)`

- Added `statusline.lualine.extraActiveSection` and
  `statusline.lualine.extraInactiveSection`

  # Release 0.4 {#sec-release-0.4}

Following the release of v0.3, I have decided to release v0.4 with a massive new
change: customizable keybinds. As of the 0.4 release, keybinds will no longer be
hardcoded and instead provided by each module's own keybinds section. The old
keybind system (`vim.keybinds = {}`) is now considered deprecated and the new
lib functions are recommended to be used for adding keybinds for new plugins, or
adding keybinds to existing plugins.

Alongside customizable keybinds, there are a few quality of life updates, such
as `lazygit` integration and the new experimental Lua loader of Neovim 0.9
thanks to our awesome contributors who made this update possible during my
absence.

### Changelog {#sec-release-0.4-changelog}

[n3oney](https://github.com/n3oney):

- Streamlined keybind adding process towards new functions in extended stdlib.

- Moved default keybinds into keybinds section of each module

- Simplified luaConfigRC and configRC setting - they can now just take strings

- Refactored the resolveDag function - you can just provide a string now, which
  will default to dag.entryAnywhere

- Fixed formatting sometimes removing parts of files

- Made formatting synchronous

- Gave null-ls priority over other formatters

[horriblename](https://github.com/horriblename):

- Added `clangd` as alternative lsp for C/++.

- Added `toggleterm` integration for `lazygit`.

- Added new option `enableluaLoader` to enable neovim's experimental module
  loader for faster startup time.

- Fixed bug where flutter-tools can't find `dart` LSP

- Added Debug Adapter (DAP) support for clang, rust, go, python and dart.

[notashelf](https://github.com/notashelf):

- Made Copilot's Node package configurable. It is recommended to keep as
  default, but providing a different NodeJS version is now possible.

- Added `vim.cursorlineOpt` for configuring Neovim's `vim.o.cursorlineopt`.

- Added `filetree.nvimTreeLua.view.cursorline`, default false, to enable
  cursorline in nvimtre.

- Added Fidget.nvim support for the Catppuccin theme.

- Updated bundled NodeJS version used by `Copilot.lua`. v16 is now marked as
  insecure on Nixpkgs, and we updated to v18

- Enabled Catppuccin modules for plugins available by default.

- Added experimental Svelte support under `vim.languages`.

- Removed unnecessary scrollbar element from notifications and codeaction
  warning UI.

- `vim.utility.colorizer` has been renamed to `vim.utility.ccc` after the plugin
  it uses

- Color preview via `nvim-colorizer.lua`

- Updated Lualine statusline UI

- Added vim-illuminate for smart highlighting

- Added a module for enabling Neovim's spellchecker

- Added prettierd as an alternative formatter to prettier - currently defaults
  to prettier

- Fixed presence.nvim inheriting the wrong client id

- Cleaned up documentation

## Release 0.3 {#sec-release-0.3}

Release 0.3 had to come out before I wanted it to due to Neovim 0.9 dropping
into nixpkgs-unstable. The Treesitter changes have prompted a Treesitter rework,
which was followed by reworking the languages system. Most of the changes to
those are downstreamed from the original repository. The feature requests that
was originally planned for 0.3 have been moved to 0.4, which should come out
soon.

### Changelog {#sec-release-0.3-changelog}

- We have transitioned to flake-parts, from flake-utils to extend the
  flexibility of this flake. This means the flake structure is different than
  usual, but the functionality remains the same.

- We now provide a home-manager module. Do note that it is still far from
  perfect, but it works.

- `nodejs_16` is now bundled with `Copilot.lua` if the user has enabled Copilot
  assistant.

- which-key section titles have been fixed. This is to be changed once again in
  a possible keybind rewrite, but now it should display the correct titles
  instead of `+prefix`

- Most of `presence.nvim`'s options have been made fully configurable through
  your configuration file.

- Most of the modules have been refactored to separate `config` and `options`
  attributes.

- Darwin has been deprecated as the Zig package is marked as broken. We will
  attempt to use the Zig overlay to return Darwin support.

- `Fidget.nvim` has been added as a neat visual addition for LSP installations.

- `diffview.nvim` has been added to provide a convenient diff utility.

  [discourse]: https://discourse.nixos.org/t/psa-if-you-are-on-unstable-try-out-nvim-treesitter-withallgrammars/23321?u=snowytrees

- Treesitter grammars are now configurable with
  [](#opt-vim.treesitter.grammars). Utilizes the nixpkgs `nvim-treesitter`
  plugin rather than a custom input in order to take advantage of build support
  of pinned versions. See [discourse] for more information. Packages can be
  found under the `pkgs.vimPlugins.nvim-treesitter.builtGrammars` attribute.
  Treesitter grammars for supported languages should be enabled within the
  module. By default no grammars are installed, thus the following grammars
  which do not have a language section are not included anymore: **comment**,
  **toml**, **make**, **html**, **css**, **graphql**, **json**.

- A new section has been added for language support: `vim.languages.<language>`.

  - The options `enableLSP` [](#opt-vim.languages.enableTreesitter), etc. will
    enable the respective section for all languages that have been enabled.
  - All LSP languages have been moved here
  - `plantuml` and `markdown` have been moved here
  - A new section has been added for `html`. The old
    `vim.treesitter.autotagHtml` can be found at
    [](#opt-vim.languages.html.treesitter.autotagHtml).

- `vim.git.gitsigns.codeActions` has been added, allowing you to turn on
  Gitsigns' code actions.

- Removed the plugins document in the docs. Was too unwieldy to keep updated.

- `vim.visual.lspkind` has been moved to [](#opt-vim.lsp.lspkind.enable)

- Improved handling of completion formatting. When setting
  `vim.autocomplete.sources`, can also include optional menu mapping. And can
  provide your own function with `vim.autocomplete.formatting.format`.

- For `vim.visuals.indentBlankline.fillChar` and
  `vim.visuals.indentBlankline.eolChar` options, turning them off should be done
  by using `null` rather than `""` now.

- Transparency has been made optional and has been disabled by default.
  [](#opt-vim.theme.transparent) option can be used to enable or disable
  transparency for your configuration.

- Fixed deprecated configuration method for Tokyonight, and added new style
  "moon"

- Dart language support as well as extended flutter support has been added.
  Thanks to @FlafyDev for his contributions towards Dart language support.

- Elixir language support has been added through `elixir-tools.nvim`.

- `hop.nvim` and `leap.nvim` have been added for fast navigation.

- `modes.nvim` has been added to the UI plugins as a minor error highlighter.

- `smartcollumn.nvim` has been added to dynamically display a colorcolumn when
  the limit has been exceeded, providing per-buftype column position and more.

- `project.nvim` has been added for better project management inside Neovim.

- More configuration options have been added to `nvim-session-manager`.

- Editorconfig support has been added to the core functionality, with an enable
  option.

- `venn-nvim` has been dropped due to broken keybinds.

## Release 0.2 {#sec-release-0.2}

Release notes for release 0.2

### Changelog {#sec-release-0.2-changelog}

[notashelf](https://github.com/notashelf):

- Added two minimap plugins under `vim.minimap`. `codewindow.nvim` is enabled by
  default, while `minimap.vim` is available with its code-minimap dependency.
- A complementary plugin, `obsidian.nvim` and the Neovim alternative for Emacs'
  orgmode with `orgmode.nvim` have been added. Both will be disabled by default.

- Smooth scrolling for ANY movement command is now available with
  `cinnamon.nvim`

- You will now notice a dashboard on startup. This is provided by the
  `alpha.nvim` plugin. You can use any of the three available dashboard plugins,
  or disable them entirely.

- There is now a scrollbar on active buffers, which can highlight errors by
  hooking to your LSPs. This is on by default, but can be toggled off under
  `vim.visuals` if seen necessary.

- Discord Rich Presence has been added through `presence.nvim` for those who
  want to flex that they are using the _superior_ text editor.

- An icon picker is now available with telescope integration. You can use
  `:IconPickerInsert` or `:IconPickerYank` to add icons to your code.

- A general-purpose cheatsheet has been added through `cheatsheet.nvim`. Forget
  no longer!

- `ccc.nvim` has been added to the default plugins to allow picking colors with
  ease.

- Most UI components of Neovim have been replaced through the help of
  `noice.nvim`. There are also notifications and custom UI elements available
  for Neovim messages and prompts.

- A (floating by default) terminal has been added through `toggleterm.nvim`.

- Harness the power of ethical (`tabnine.nvim`) and not-so-ethical
  (`copilot.lua`) AI by those new assistant plugins. Both are off by default,
  TabNine needs to be wrapped before it's working.

- Experimental mouse gestures have been added through `gesture.nvim`. See plugin
  page and the relevant module for more details on how to use.

- Re-open last visited buffers via `nvim-session-manager`. Disabled by default
  as deleting buffers seems to be problematic at the moment.

- Most of NvimTree's configuration options have been changed with some options
  being toggled to off by default.

- Lualine had its configuration simplified and style toned down. Less color,
  more info.

- Modules where multiple plugin configurations were in the same directory have
  been simplified. Each plugin inside a single module gets its directory to be
  imported.

- Separate config options with the same parent attribute have been merged into
  one for simplicity.

## Release 0.1 {#sec-release-0.1}

This is the current master branch and information here is not final. These are
changes from the v0.1 tag.

Special thanks to [home-manager](https://github.com/nix-community/home-manager/)
for this release. Docs/manual generation, the new module evaluation system, and
DAG implementation are from them.

### Changelog {#sec-release-0.1-changelog}

[jordanisaacs](https://github.com/jordanisaacs):

- Removed hare language support (lsp/tree-sitter/etc). `vim.lsp.hare` is no
  longer defined. If you use hare and would like it added back, please file an
  issue.

- [](#opt-vim.startPlugins) & [](#opt-vim.optPlugins) are now an enum of
  `string` for options sourced from the flake inputs. Users can still provide
  vim plugin packages.

  - If you are contributing and adding a new plugin, add the plugin name to
    `availablePlugins` in [types-plugin.nix].

- `neovimBuilder` has been removed for configuration. Using an overlay is no
  longer required. See the manual for the new way to configuration.

[relevant discourse post]: https://discourse.nixos.org/t/psa-if-you-are-on-unstable-try-out-nvim-treesitter-withallgrammars/23321?u=snowytrees

- Treesitter grammars are now configurable with
  [](#opt-vim.treesitter.grammars). Utilizes the nixpkgs `nvim-treesitter`
  plugin rather than a custom input in order to take advantage of build support
  of pinned versions. See the [relevant discourse post] for more information.
  Packages can be found under the `vimPlugins.nvim-treesitter.builtGrammars`
  namespace.

- `vim.configRC` and [](#opt-vim.luaConfigRC) are now of type DAG lines. This
  allows for ordering of the config. Usage is the same is in home-manager's
  `home.activation` option.

```nix
vim.luaConfigRC = lib.nvim.dag.entryAnywhere "config here"
```

[MoritzBoehme](https://github.com/MoritzBoehme):

- `catppuccin` theme is now available as a neovim theme [](#opt-vim.theme.style)
  and Lualine theme [](#opt-vim.statusline.lualine.theme).
