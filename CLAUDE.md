# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package whose contents mirror the home directory structure. `stow <package>` symlinks files into `$HOME`.

## Installation

```bash
# Install packages + apply dotfiles (macOS only for packages)
./install.sh

# Apply dotfiles only (no package installation)
./install.sh -i

# Apply a single package manually
stow aliases          # or: bin git nvim psql ripgrep tmux wezterm zsh
```

The full stow invocation (from `install.sh`): `stow aliases bin git nvim psql ripgrep tmux wezterm zed zsh`

## Stow Package Structure

Each package directory follows the convention `<package>/<path-relative-to-$HOME>`. For example:
- `nvim/.config/nvim/` → `~/.config/nvim/`
- `zsh/.zshrc` → `~/.zshrc`
- `git/.gitconfig` → `~/.gitconfig`

## Neovim Config (`nvim/.config/nvim/`)

Uses **lazy.nvim** as the plugin manager. Entry point is `init.lua` which loads `config/{options,keymaps,autocmds,lazy}` then optionally `lua/work.lua` (machine-local overrides, not tracked).

Plugin files under `lua/plugins/`:
| File | Purpose |
|------|---------|
| `coding.lua` | LuaSnip snippets, blink.cmp completion, autopairs, GitHub Copilot |
| `editor.lua` | neo-tree, flash.nvim, which-key, todo-comments, trouble, mini.surround, toggleterm, nvim-ufo |
| `format.lua` | conform.nvim (formatters: black, stylua, prettier, shfmt, hclfmt, sqlfmt, markdownlint) + nvim-lint |
| `git.lua` | gitsigns, vim-fugitive, diffview, gitlinker, octo.nvim |
| `lsp.lua` | mason + mason-lspconfig + nvim-lspconfig; servers: bashls, dockerls, jedi, jsonls, rust_analyzer, sqls, terraformls, tflint, yamlls, lua_ls |
| `treesitter.lua` | treesitter parsers and text objects |
| `ui.lua` | onenord colorscheme, bufferline, lualine, noice.nvim, devicons |
| `util.lua` | snacks.nvim (picker/notifier/dashboard/zen), persistence.nvim, obsidian.nvim |

### Key Neovim Conventions

- **Leader**: `<space>`
- **File/search picker**: `snacks.nvim` (replaces Telescope) — `<leader><space>` smart find, `<leader>fg` grep, `<leader>ff` files
- **Completion**: `blink.cmp` — `<Tab>`/`<S-Tab>` navigate, `<CR>` accept, `<C-p>` accept Copilot
- **Flash motions**: `s` jumps word-start only (`\<` prefix); `S` treesitter select
- **LSP navigation**: `gd` definition, `gr` references, `K` hover — all via snacks picker
- **Copilot**: accept with `<C-p>` (not Tab, which is reserved for completion)
- **Work overrides**: `lua/work.lua` and `~/.zsh/work` are sourced if present; `~/.gitconfig_custom` and `~/.gitconfig_personal` are included conditionally

## Zsh Setup

- **Shell**: oh-my-zsh with `cloud` theme, vi mode enabled
- **Plugins**: git, zsh-autosuggestions, docker-compose, gh, aws, macos
- **Extra sources**: `~/.aliases`, `~/.zsh/functions`, `~/.zsh/work` (optional)
- **Tools loaded lazily**: `nvm` (via `nvminit` function), `fzf`, `z` (directory jumping)
- **History**: logged to `~/Logs/zsh-history-YYYY-MM-DD.log` via `precmd`

## Git Config Highlights

- **Pager/diff**: `delta` with side-by-side and line numbers; `icdiff` as difftool
- **Merge**: fugitive (`nvim -f -c "Gdiffsplit!" "$MERGED"`)
- **rerere**: enabled (remembers conflict resolutions)
- **Aliases**: `noop` = amend without edit, `noop-push` = amend + force push
- **Conditional includes**: `~/.gitconfig_custom` always; `~/.gitconfig_personal` for `~/projects/personal/`

## Tmux Config Highlights

- **Prefix**: `C-a` (not the default `C-b`); `C-q` sends prefix to inner session
- **Pane navigation**: vim-style `h/j/k/l` with prefix
- **Splits**: `|` horizontal, `-` vertical (both open in current path)
- **Sessionizer**: `prefix + f` opens `tmux-sessionizer` script; `prefix + i` opens cht.sh lookup
- **Lazygit popup**: `C-g` (no prefix needed)
- **Status bar**: top-positioned, 3-second refresh, Nerd Font icons
- **Passthrough**: `allow-passthrough on` and `extended-keys on` for Claude Code notifications
