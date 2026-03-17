# Neovim Config Overview

> Location: `~/.config/nvim_new`
> Run with: `NVIM_APPNAME=nvim_new nvim`

---

## Structure

```
nvim_new/
├── init.lua                     # Entry point
├── lua/
│   ├── config/
│   │   ├── lazy.lua             # Plugin manager bootstrap
│   │   ├── options.lua          # Editor settings
│   │   ├── keymaps.lua          # Core keymaps (no plugin deps)
│   │   └── autocmds.lua         # Autocommands
│   └── plugins/
│       ├── ui.lua               # Theme, bufferline, statusline, noice
│       ├── editor.lua           # Oil, flash, which-key, trouble, folding, terminal
│       ├── coding.lua           # Completion, snippets, copilot, autopairs
│       ├── lsp.lua              # LSP, Mason, lazydev
│       ├── format.lua           # conform.nvim (format), nvim-lint (lint)
│       ├── treesitter.lua       # Syntax, text objects
│       ├── git.lua              # Gitsigns, fugitive, diffview, gitlinker, octo
│       ├── dap.lua              # Debugger (DAP + Python)
│       └── util.lua             # Snacks, persistence, obsidian
└── after/ftplugin/
    └── json.lua                 # conceallevel=0 for JSON
```

---

## Key Design Decisions

| Old | New | Why |
|---|---|---|
| `nvim-cmp` | `blink.cmp` | Faster, written in Rust, built-in signature help |
| `none-ls` | `conform.nvim` + `nvim-lint` | Dedicated tools, purpose-built, less overhead |
| `neodev.nvim` | `lazydev.nvim` | Modern replacement, actively maintained |
| `telescope` + `fzf-lua` | `snacks.picker` | Already present, consolidates to one picker |
| `nvim-tree` | `oil.nvim` | Edit the filesystem like a buffer |
| `nvim-navbuddy/navic` | removed | Fewer moving parts |
| `lspsaga` | native `vim.lsp.*` + trouble | Less abstraction, native APIs |
| `fidget.nvim` | snacks notifier | Already included in snacks |
| `vim-illuminate` | `snacks.words` | Already included in snacks |
| `nvim-spectre` | `snacks.picker` grep | Already included in snacks |
| `harpoon` | bufferline + snacks picker | Covered by existing tools |
| `lspconfig` framework | `vim.lsp.config` + `vim.lsp.enable` | Native nvim 0.11+ API |
| `setup_handlers` | `automatic_enable = true` | mason-lspconfig v2 API |
| noice as notifier | snacks notifier | noice kept only for cmdline UI |

---

## Plugins

### UI (`lua/plugins/ui.lua`)

#### `catppuccin/nvim` — Colorscheme
Primary theme. Flavour: `frappe`. Integrations enabled for bufferline, blink.cmp, gitsigns, treesitter, snacks, trouble, which-key, noice, flash.

#### `folke/tokyonight.nvim` — Alternate colorscheme
Available as fallback. Switch with `:colorscheme tokyonight`.

#### `akinsho/bufferline.nvim` — Buffer tabs
Shows open buffers as tabs at the top. Displays LSP error/warning counts per buffer.

| Key | Action |
|---|---|
| `<Tab>` | Next buffer |
| `<S-Tab>` | Previous buffer |
| `\` | Pick buffer interactively |

#### `nvim-lualine/lualine.nvim` — Statusline
Shows: mode, git branch, diagnostics, filetype icon, filename (relative path), noice command/mode, DAP status, git diff, progress, cursor location.

#### `folke/noice.nvim` — UI for cmdline and popups
Replaces the default cmdline and popup UI. Does **not** handle `vim.notify` (snacks does that). Provides a command palette, bottom search bar, and better LSP hover formatting.

| Key | Action |
|---|---|
| `<S-Enter>` | Redirect cmdline output to split |
| `<leader>snh` | Noice message history |
| `<leader>sna` | All noice messages |
| `<C-f>` / `<C-b>` | Scroll LSP hover docs |

#### `nvim-tree/nvim-web-devicons` — Icons
File type icons used by oil, bufferline, lualine, etc.

---

### Editor (`lua/plugins/editor.lua`)

#### `stevearc/oil.nvim` — File explorer
Edit the filesystem like a text buffer. Navigate, rename, delete, and create files by editing lines. Replaces nvim-tree.

| Key | Action |
|---|---|
| `<leader>e` | Open file explorer |
| `-` | Open parent directory |
| `<CR>` | Open file/directory |
| `<C-v>` | Open in vertical split |
| `<C-s>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-p>` | Preview file |
| `<C-r>` | Refresh |
| `g.` | Toggle hidden files |
| `g?` | Show help |

#### `folke/flash.nvim` — Fast motions
Jump anywhere on screen with a few keystrokes using labeled targets. Works across windows.

| Key | Mode | Action |
|---|---|---|
| `s` | n/x/o | Flash jump |
| `S` | n/x/o | Flash treesitter (structural jump) |
| `r` | o | Remote flash (operate on distant target) |
| `R` | o/x | Treesitter search |
| `<C-s>` | c | Toggle flash in `/` search |

#### `folke/which-key.nvim` — Keymap hints
Shows available keybindings in a popup when you pause after a prefix key. Groups are labelled for discoverability.

#### `folke/todo-comments.nvim` — Highlight special comments
Highlights `TODO`, `FIXME`, `HACK`, `NOTE`, `WARN`, `PERF` in source files.

| Key | Action |
|---|---|
| `]t` | Next TODO comment |
| `[t` | Previous TODO comment |
| `<leader>xt` | List all TODOs in Trouble |
| `<leader>st` | Search TODOs via picker |

#### `folke/trouble.nvim` — Diagnostics panel
Pretty list for diagnostics, references, LSP definitions, quickfix, and location lists.

| Key | Action |
|---|---|
| `<leader>xx` | Toggle project diagnostics |
| `<leader>xX` | Toggle buffer diagnostics |
| `<leader>cs` | Toggle symbol list |
| `<leader>cl` | Toggle LSP definitions panel |
| `<leader>xL` | Toggle location list |
| `<leader>xQ` | Toggle quickfix list |

#### `echasnovski/mini.surround` — Surround text objects
Add, delete, replace, find surrounding characters (brackets, quotes, tags, etc.).

| Key | Action |
|---|---|
| `gza` | Add surrounding |
| `gzd` | Delete surrounding |
| `gzr` | Replace surrounding |
| `gzf` | Find next surrounding |
| `gzF` | Find previous surrounding |
| `gzh` | Highlight surrounding |

Example: `gza"` wraps selection in quotes. `gzd"` removes surrounding quotes.

#### `numToStr/Comment.nvim` — Toggle comments

| Key | Mode | Action |
|---|---|---|
| `<leader>/` | n | Toggle comment on current line |
| `<leader>/` | v | Toggle comment on selection |

#### `akinsho/toggleterm.nvim` — Floating terminal
Opens a floating terminal overlay.

| Key | Action |
|---|---|
| `<C-\>` | Toggle terminal |
| `<Esc><Esc>` | Exit terminal mode (return to normal) |

#### `iamcco/markdown-preview.nvim` — Live markdown preview
Opens a browser tab with a live-updating preview of the current markdown file.

| Key | Action |
|---|---|
| `<leader>mp` | Toggle markdown preview |

#### `kevinhwang91/nvim-ufo` — Better folding
Uses treesitter and LSP to create accurate, fast code folds. Folds are open by default.

| Key | Action |
|---|---|
| `zR` | Open all folds |
| `zM` | Close all folds |
| `zo` / `zc` | Open / close fold under cursor |

---

### Coding (`lua/plugins/coding.lua`)

#### `saghen/blink.cmp` — Completion
Fast completion engine written in Rust. Sources: LSP, path, snippets, buffer. Replaces nvim-cmp. Has built-in signature help.

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / previous item |
| `<CR>` | Accept completion |
| `<C-d>` | Scroll docs down |
| `<C-f>` | Scroll docs up |
| `<C-Space>` | Trigger completion (preset default) |
| `<C-e>` | Cancel completion (preset default) |

#### `L3MON4D3/LuaSnip` — Snippet engine
Powers snippet expansion. Includes VSCode-format snippets via `friendly-snippets`.

| Key | Mode | Action |
|---|---|---|
| `<C-k>` | i/s | Expand snippet or jump forward |
| `<C-j>` | i/s | Jump backward in snippet |
| `<C-l>` | i/s | Cycle snippet choice |

#### `windwp/nvim-autopairs` — Auto-close pairs
Automatically closes `(`, `[`, `{`, `"`, `'` etc. Treesitter-aware to avoid false positives.

#### `github/copilot.vim` — GitHub Copilot
AI code suggestions inline.

| Key | Mode | Action |
|---|---|---|
| `<C-p>` | i | Accept Copilot suggestion |

---

### LSP (`lua/plugins/lsp.lua`)

Uses native `vim.lsp.config` + `vim.lsp.enable` (nvim 0.11+). No deprecated lspconfig framework patterns.

#### `williamboman/mason.nvim` — Tool installer
Installs and manages LSP servers, formatters, and linters. Auto-installs configured tools on startup.

| Key | Action |
|---|---|
| `<leader>cm` | Open Mason UI |

Tools auto-installed: `black`, `stylua`, `prettier`, `shfmt`, `hclfmt`, `sqlfmt`, `markdownlint`, `flake8`, `mypy`, `shellcheck`, `hadolint`, `debugpy`.

#### `neovim/nvim-lspconfig` + `williamboman/mason-lspconfig.nvim` — LSP servers

Servers configured:

| Server | Language |
|---|---|
| `bashls` | Bash/Shell |
| `dockerls` | Dockerfile |
| `groovyls` | Groovy |
| `jedi_language_server` | Python |
| `jsonls` | JSON/JSONC |
| `lua_ls` | Lua |
| `rust_analyzer` | Rust |
| `sqls` | SQL |
| `terraformls` | Terraform |
| `tflint` | Terraform (linting) |
| `yamlls` | YAML |

LSP keymaps (active when an LSP is attached):

| Key | Action |
|---|---|
| `gd` | Goto definition |
| `gr` | Goto references |
| `gI` | Goto implementation |
| `gt` | Goto type definition |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<C-h>` (insert) | Signature help |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>ci` | LSP info |
| `<leader>ss` | LSP workspace symbols |
| `<leader>cd` | Line diagnostics float |
| `]d` / `[d` | Next / prev diagnostic |
| `]e` / `[e` | Next / prev error |
| `]w` / `[w` | Next / prev warning |

#### `folke/lazydev.nvim` — Lua LSP for neovim config
Provides accurate completions and type hints for `vim.*` and `Snacks.*` APIs when editing neovim config files. Replaces `neodev.nvim`.

---

### Formatting & Linting (`lua/plugins/format.lua`)

Replaces `none-ls`/`null-ls` with two dedicated tools.

#### `stevearc/conform.nvim` — Formatting
Formats on save automatically. Falls back to LSP formatting if no formatter is configured.

| Key | Action |
|---|---|
| `<leader>cf` | Format buffer (or range in visual mode) |

| Filetype | Formatter |
|---|---|
| Lua | `stylua` |
| Python | `black` |
| JS/TS/JSX/TSX | `prettier` |
| JSON/JSONC | `prettier` |
| YAML | `prettier` |
| Markdown | `markdownlint` → `prettier` |
| HTML/CSS | `prettier` |
| Shell/Bash | `shfmt` (2-space, compact if) |
| Terraform | `terraform_fmt` |
| HCL | `hclfmt` |
| SQL | `sqlfmt` |

#### `mfussenegger/nvim-lint` — Linting
Runs linters automatically on buffer enter, write, and leaving insert mode.

| Filetype | Linter(s) |
|---|---|
| Python | `flake8`, `mypy` |
| Markdown | `markdownlint` |
| Shell/Bash | `shellcheck` |
| Dockerfile | `hadolint` |

---

### Treesitter (`lua/plugins/treesitter.lua`)

#### `nvim-treesitter/nvim-treesitter` — Syntax & structural editing
Accurate syntax highlighting and code-aware text objects. Much better than regex-based highlighting.

Installed parsers: `bash`, `hcl`, `javascript`, `json`, `jsonc`, `lua`, `luadoc`, `markdown`, `markdown_inline`, `python`, `query`, `regex`, `terraform`, `typescript`, `vim`, `vimdoc`, `yaml`.

**Incremental selection:**

| Key | Action |
|---|---|
| `<C-Space>` | Start / expand selection by node |
| `<BS>` | Shrink selection |

**Text objects** (use with `d`, `y`, `c`, `v`, etc.):

| Object | Meaning |
|---|---|
| `af` / `if` | Around / inside function |
| `ac` / `ic` | Around / inside class |
| `aa` / `ia` | Around / inside argument/parameter |

**Motion** (jump to next/prev):

| Key | Jumps to |
|---|---|
| `]m` / `[m` | Next / prev function start |
| `]M` / `[M` | Next / prev function end |
| `]]` / `[[` | Next / prev class start |

**Swap:**

| Key | Action |
|---|---|
| `<leader>a` | Swap parameter with next |
| `<leader>A` | Swap parameter with previous |

---

### Git (`lua/plugins/git.lua`)

#### `lewis6991/gitsigns.nvim` — Git signs & hunk operations
Shows git status per-line in the sign column. Supports staging individual hunks.

| Key | Action |
|---|---|
| `]h` / `[h` | Next / prev hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |
| `<leader>ghS` | Stage entire buffer |
| `<leader>ghR` | Reset entire buffer |
| `<leader>ghu` | Undo stage hunk |
| `<leader>ghp` | Preview hunk |
| `<leader>ghb` | Full blame for current line |
| `<leader>ghd` | Diff this file |
| `<leader>ghD` | Diff against last commit |
| `ih` | Text object: select hunk (o/x modes) |

#### `tpope/vim-fugitive` — Git commands
Run any git command from inside neovim with `:Git`.

| Key | Action |
|---|---|
| `<leader>gg` | Open git status |

#### `sindrets/diffview.nvim` — Diff viewer
Side-by-side diff view and full file history browser.

| Key | Action |
|---|---|
| `<leader>gdo` | Open diffview |
| `<leader>gdc` | Close diffview |
| `<leader>gdh` | File history |

#### `ruifm/gitlinker.nvim` — Shareable git links
Generate a permalink to the current file/selection on GitHub/GitLab.

| Key | Mode | Action |
|---|---|---|
| `<leader>gy` | n/v | Copy git permalink to clipboard |

#### `pwntester/octo.nvim` — GitHub integration
Manage GitHub PRs and issues without leaving neovim. Requires `gh` CLI.

| Command | Action |
|---|---|
| `:Octo pr list` | List pull requests |
| `:Octo issue list` | List issues |
| `:Octo review start` | Start a PR review |

---

### DAP — Debugger (`lua/plugins/dap.lua`)

#### `mfussenegger/nvim-dap` — Debug Adapter Protocol
Core debugger. Language-agnostic.

| Key | Action |
|---|---|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue / start |
| `<leader>dso` | Step over |
| `<leader>dsi` | Step into |
| `<leader>dse` | Step out |
| `<leader>dR` | Run to cursor |
| `<leader>du` | Toggle DAP UI |

#### `mfussenegger/nvim-dap-python` — Python debugging
Configures debugpy for Python. DAP UI opens automatically on session start.

#### `rcarriga/nvim-dap-ui` — Debugger UI
Shows variables, call stack, watches, and console in a panel layout. Opens/closes automatically with debug sessions.

---

### Utilities (`lua/plugins/util.lua`)

#### `folke/snacks.nvim` — Central utility hub
The single most important plugin. Provides many features that would otherwise require multiple separate plugins.

**Features enabled:**

| Feature | What it does |
|---|---|
| `picker` | Fuzzy finder replacing telescope (frecency-sorted) |
| `notifier` | Popup notifications replacing nvim-notify |
| `dashboard` | Start screen with custom ASCII header |
| `indent` | Indent guides |
| `words` | Highlight all occurrences of word under cursor (replaces vim-illuminate) |
| `dim` | Dim inactive windows/scopes |
| `zen` | Distraction-free writing mode |
| `bigfile` | Disables heavy features for large files |
| `statuscolumn` | Modern status column |
| `input` | Better vim.ui.input |
| `quickfile` | Fast file opening |

**Picker keymaps:**

| Key | Action |
|---|---|
| `<leader><space>` | Smart find files (recent + project) |
| `<leader>ff` | Find files |
| `<leader>fo` | Recent files |
| `<leader>fb` | Open buffers |
| `<leader>fg` | Grep (live) |
| `<leader>sg` | Grep (live) |
| `<leader>sw` | Grep word under cursor |
| `<leader>fh` | Help tags |
| `<leader>sk` | Keymaps |
| `<leader>sc` | Command history |
| `<leader>sC` | Commands |
| `<leader>sd` | Diagnostics |
| `<leader>sm` | Marks |
| `<leader>sH` | Highlight groups |
| `<leader>sr` | Resume last picker |
| `<leader>ss` | LSP workspace symbols |
| `gd` | LSP definitions |
| `gr` | LSP references |
| `gI` | LSP implementations |
| `gt` | LSP type definitions |

**Git via picker:**

| Key | Action |
|---|---|
| `<leader>gb` | Git branches |
| `<leader>gl` | Git log |
| `<leader>gs` | Git status |

**Utilities:**

| Key | Action |
|---|---|
| `<leader>z` | Zen mode |
| `<leader>.` | Toggle scratch buffer |
| `<leader>S` | Select scratch buffer |
| `<leader>bd` | Delete buffer |
| `<leader>N` | Show notification history |
| `<leader>un` | Dismiss all notifications |
| `<leader>en` | Edit neovim config files |

**UI toggles:**

| Key | Toggles |
|---|---|
| `<leader>us` | Spelling |
| `<leader>uw` | Line wrap |
| `<leader>uL` | Relative line numbers |
| `<leader>ud` | Diagnostics |
| `<leader>ul` | Line numbers |
| `<leader>uc` | Conceal level |
| `<leader>uh` | Inlay hints |
| `<leader>ug` | Indent guides |
| `<leader>uD` | Dim mode |

#### `folke/persistence.nvim` — Session management
Saves and restores your session (buffers, windows, folds, cursor positions) per working directory.

| Key | Action |
|---|---|
| `<leader>qs` | Restore session for current directory |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Stop saving session |

#### `epwalsh/obsidian.nvim` — Obsidian vault
Integrates with Obsidian vaults for note-taking. Loads on markdown files. Vault path: `~/projects/obsidian`.

---

## Core Keymaps (no plugin required)

### Navigation

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Move between windows |
| `<C-Up/Down>` | Resize window height |
| `<C-Left/Right>` | Resize window width |
| `j` / `k` | Move by display line (wraps correctly) |

### Editing

| Key | Mode | Action |
|---|---|---|
| `<C-s>` | n/i/x/s | Save file |
| `<A-j>` / `<A-k>` | n/i/v | Move line/selection up or down |
| `<` / `>` | v | Indent / dedent (keep selection) |
| `p` | v | Paste without replacing yank register |
| `<Esc>` | n/i | Clear search highlight |

### Splits & Tabs

| Key | Action |
|---|---|
| `<leader>w-` or `<leader>-` | Split below |
| `<leader>w\|` or `<leader>\|` | Split right |
| `<leader>wd` | Close window |
| `<leader><tab><tab>` | New tab |
| `<leader><tab>]` / `[` | Next / prev tab |
| `<leader><tab>l` / `f` | Last / first tab |
| `<leader><tab>d` | Close tab |

### Misc

| Key | Action |
|---|---|
| `<leader>qq` | Quit all |
| `<leader>fn` | New file |
| `<leader>l` | Open Lazy plugin manager |
| `<leader>xl` | Location list |
| `<leader>xq` | Quickfix list |
| `<leader>ui` | Inspect highlight under cursor |
| `<Esc><Esc>` (terminal) | Exit terminal mode |

---

## Editor Settings

| Setting | Value |
|---|---|
| Leader key | `<Space>` |
| Local leader | `\` |
| Indentation | 2 spaces (expandtab) |
| Color column | 120 |
| Scroll offset | 8 lines |
| Clipboard | System clipboard |
| Undo | Persistent across sessions |
| Autowrite | On (saves on buffer switch) |
| Folds | Open by default (managed by nvim-ufo) |
| Conceallevel | 2 (0 for JSON files) |
| Wrap | Off |

## Autocommands

| Trigger | Effect |
|---|---|
| Yank | Flash highlight on yanked region |
| Terminal resize | Re-equalize all splits |
| File open | Restore cursor to last position |
| `help`, `qf`, etc. | Close with `q` |
| `gitcommit`, `markdown` | Enable wrap + spell |
| `json`, `jsonc`, `json5` | Set conceallevel to 0 |
| Save | Auto-create missing parent directories |
