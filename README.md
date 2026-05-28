# Neovim config

A small, from-scratch Neovim configuration — no distro (not LazyVim/NvChad), just
[lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager and a
handful of well-chosen plugins. Built on the modern Neovim APIs (`vim.lsp.config`,
the nvim-treesitter `main` branch), so it targets **Neovim 0.11+** (treesitter
setup assumes **0.12**).

The layout is the conventional `init.lua` + `lua/` split, kept deliberately
readable: every file is short and commented so it's easy to fork and adapt.

## Requirements

- **Neovim 0.11+** (0.12 recommended — the treesitter spec uses the `main` branch)
- **git**, a **C compiler**, and **make** (for `telescope-fzf-native`)
- The **tree-sitter CLI** (treesitter `main` compiles parsers itself)
- A **Nerd Font** for icons
- `node` available on `PATH` (several language servers are Node scripts)
- Optional, per language: the **Zig** toolchain for `zls`, and a project-local
  `vendor/bin/phpstan` to enable PHP linting

Language-server binaries and `shellcheck` are installed automatically by
[Mason](https://github.com/williamboman/mason.nvim) on first launch.

## Install

> Back up any existing config first — this replaces `~/.config/nvim`.

```sh
git clone https://github.com/<you>/<repo>.git ~/.config/nvim
nvim
```

On first start, lazy.nvim bootstraps itself, installs the plugins, and Mason
pulls down the language servers. Treesitter parsers compile in the background —
give it a moment, then restart.

## What's included

| Area | Plugin |
| --- | --- |
| Plugin manager | [lazy.nvim](https://github.com/folke/lazy.nvim) |
| Colorscheme | [nordic.nvim](https://github.com/AlexvZyl/nordic.nvim) |
| File explorer | [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim) |
| Fuzzy finder | [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (+ fzf-native) |
| LSP | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) + [mason.nvim](https://github.com/williamboman/mason.nvim) |
| Completion | [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) + [LuaSnip](https://github.com/L3MON4D3/LuaSnip) |
| Linting | [nvim-lint](https://github.com/mfussenegger/nvim-lint) (PHPStan) |
| Syntax | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) (`main`) |
| Statusline | [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) |
| Buffer tabs | [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) |
| Terminal | [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) |
| Sessions | [persistence.nvim](https://github.com/folke/persistence.nvim) |

**Language servers** configured out of the box: TypeScript/JavaScript, JSON,
YAML, TOML, Bash (via shellcheck), PHP (intelephense), Go, Python, Rust, Zig,
and Lua.

## Behavior worth knowing

- **Auto-restore sessions.** Opening a directory (`nvim`, `nvim .`, `nvim ~/proj`)
  `cd`s into it, restores the session you last had open for that codebase, and
  opens the file tree. Opening a single file (`nvim foo.lua`) leaves everything
  alone, and a piped stdin (e.g. `git commit`) is ignored.
- **Newest-node for LSPs.** Node-based language servers are launched with the
  newest installed Node version (checking Herd's nvm and `~/.nvm`) so they don't
  run on an EOL runtime, without touching your shell or terminal node.
- **Quiet PHP linting.** PHPStan only runs when the project actually has
  `vendor/bin/phpstan`, so it stays silent everywhere else.

## Keymaps

Leader is `<Space>`.

### LSP & diagnostics
| Key | Action |
| --- | --- |
| `gd` / `gD` | Go to definition / declaration |
| `gr` / `gi` | References / implementation |
| `K` | Hover |
| `<leader>rn` | Rename |
| `<leader>ca` | Code action |
| `<leader>fd` | Diagnostic float |
| `[d` / `]d` | Previous / next diagnostic |

### Find (Telescope)
| Key | Action |
| --- | --- |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fh` | Help tags |

### Buffers
| Key | Action |
| --- | --- |
| `<S-l>` / `<S-h>` | Next / previous buffer |
| `<leader>1`–`<leader>9` | Jump to buffer by position |
| `<leader>bp` | Pick a buffer |
| `<leader>bd` | Close current buffer |
| `<leader>bo` | Close other buffers |
| `<leader>b.` / `<leader>b,` | Move buffer right / left |

### Other
| Key | Action |
| --- | --- |
| `<leader>e` | Toggle file explorer |
| `<C-t>` / `<leader>tt` | Toggle floating terminal |
| `<leader>qs` | Restore session for this directory |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save the current session |

## Structure

```
init.lua                 -- entry point; requires the modules below
lua/config/
  options.lua            -- editor options + diagnostic display
  keymaps.lua            -- non-plugin keymaps (LSP, diagnostics)
  autocmds.lua           -- startup: cd, session restore, open file tree
  lazy.lua               -- bootstraps lazy.nvim and imports plugins/
lua/plugins/             -- one file per plugin spec, auto-imported
```

## License

No license has been set yet. If you want others to freely reuse this config,
add a `LICENSE` file (MIT is the conventional choice for dotfiles) and update
this section.
