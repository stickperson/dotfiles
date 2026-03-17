# Neovim Config Comparison: `nvim` vs `nvim_new`

This document compares `~/.config/nvim` (old) with `~/.config/nvim_new` (new) in depth.

---

## Boot Order & Init

### Old (`nvim`)
```
init.lua → config.lazy → config.options (inside lazy.lua) → lazy.setup() → config.autocmds → config.keymaps
```
- `init.lua` only contains `require("config.lazy")`
- Leader is set in `config/options.lua`
- Keymaps and autocmds load **after** lazy

### New (`nvim_new`)
```
init.lua → config.options → config.keymaps → config.autocmds → config.lazy
```
- `init.lua` sets leader, `maplocalleader`, puts Mason bin on `PATH`, then loads everything
- Keymaps and autocmds load **before** lazy — safer, avoids race conditions with plugin keymaps
- `maplocalleader = "\\"` (old never set this)
- Mason bin prepended to `PATH` at init time so formatters/linters are available immediately

---

## Options Differences

| Option | Old | New | What it does |
|---|---|---|---|
| `laststatus` | `0` | `3` | `0` = no statusline; `3` = single global statusline across all windows |
| `wrap` | `true` | `false` | Whether long lines wrap visually |
| `scrolloff` | `4` | `8` | Minimum lines to keep above/below the cursor when scrolling |
| `list` | `true` | `true` ✓ | Show invisible characters (trailing spaces, tabs) |
| `confirm` | `true` | `true` ✓ | Prompt to save/discard instead of erroring on `:q` with unsaved changes |
| `inccommand` | `"nosplit"` | `"nosplit"` ✓ | Live preview of `:s` substitutions in the buffer as you type |
| `grepprg` | `"rg --vimgrep"` | `"rg --vimgrep"` ✓ | Command used by `:grep` — ripgrep instead of system grep |
| `grepformat` | `"%f:%l:%c:%m"` | `"%f:%l:%c:%m"` ✓ | Tells Neovim how to parse `:grep` output into the quickfix list |
| `undolevels` | `10000` | `10000` ✓ | Maximum number of undo steps (default is 1000) |
| `winminwidth` | `5` | `5` ✓ | Minimum window width — prevents splits collapsing to zero |
| `formatoptions` | `"jcroqlnt"` | not set | Controls auto-formatting behaviour (comment continuation, wrapping, etc.) |
| `wildmode` | `"longest:full,full"` | not set | How command-line tab completion behaves |
| `pumblend` | `10` | not set | Pseudo-transparency for the popup menu (0–100) |
| `softtabstop` | `2` | not set | How many spaces a `<Tab>` counts for in insert mode |
| `spelllang` | `{ "en" }` | not set | Language(s) used for spell checking |
| `splitkeep` | `"screen"` | not set | Keeps the same lines visible when splitting (nvim 0.9+) |
| `fillchars` | custom glyphs | not set | Characters used for fold markers, EOB, separators |
| `sessionoptions` | `buffers,curdir,tabpages,winsize` | not set | What `:mksession` saves (persistence.nvim uses this) |
| `shortmess` | appends `W,I,c,C` | not set | Suppresses various informational messages |
| `cmdheight` | not set | `1` | Height of the command line area |
| `hlsearch` | not set | `true` | Highlight all matches of the last search pattern |
| `incsearch` | not set | `true` | Show matches incrementally as you type a search |
| `swapfile` | not set | `false` | Disable swap files |
| `backup` | not set | `false` | Disable backup files |

**Old only**: disables LSP logging (`vim.lsp.set_log_level("OFF")`), sets `vim.g.markdown_recommended_style = 0`, loads `work.lua` with `pcall`, sets a cmdabbrev to prevent partial-range write prompt.

**New only**: `colorcolumn = "120"`, `cmdheight = 1`, explicit `hlsearch/incsearch`, disables netrw (`loaded_netrw/loaded_netrwPlugin`).

---

## Autocmds

Both configs share: TextYankPost yank highlight, VimResized split equalizer, BufReadPost cursor restore, FileType close-with-q, FileType gitcommit/markdown wrap+spell.

### Differences

| Autocmd | Old | New |
|---|---|---|
| `FocusGained` / `TermClose` / `TermLeave` checktime | Yes | No (snacks `quickfile` handles this) |
| VimResized | `tabdo wincmd =` | Same + restores current tabpage after |
| BufReadPost | Restores cursor (no exclusions) | Excludes `gitcommit` |
| FileType close-with-q patterns | `qf, help, man, notify, lspinfo, spectre_panel, startuptime, tsplayground, PlenaryTestPopup` | `checkhealth, help, lspinfo, man, notify, qf, query, startuptime, tsplayground` |
| FileType json | Sets `shiftwidth = 4` | Sets `conceallevel = 0` |
| BufWritePre auto-mkdir | No | Yes — creates parent directories on save |
| Augroup naming | No helper, no `clear = true` | `augroup()` helper, always `clear = true` |

---

## Plugin Stack Comparison

### Completion

| | Old | New |
|---|---|---|
| Engine | `hrsh7th/nvim-cmp` | `saghen/blink.cmp` |
| LSP source | `cmp-nvim-lsp` | built into blink |
| Buffer source | `cmp-buffer` | built into blink |
| Path source | `cmp-path` | built into blink |
| Snippet source | `cmp_luasnip` | built into blink |
| Ghost text | yes (`experimental`) | not configured |
| Signature help | no | yes (blink `signature.enabled = true`) |
| Capabilities | manually patched with `cmp_nvim_lsp.default_capabilities()` + foldingRange | `blink.cmp.get_lsp_capabilities()` applied globally via `vim.lsp.config("*", ...)` |

Old `nvim-cmp` mapping: `<Tab>/<S-Tab>` navigate, `<CR>` confirm (Replace, no auto-select), `<C-d>/<C-f>` scroll docs, `<C-Space>` complete, `<C-e>` close.

New `blink.cmp` mapping: `<Tab>/<S-Tab>` select+snippet_forward/backward, `<CR>` accept, `<C-d>/<C-f>` scroll docs. Documentation auto-shows after 200ms. Completion menu border `"rounded"`.

### Formatting & Linting

| | Old | New |
|---|---|---|
| Tool | `nvimtools/none-ls.nvim` (null-ls) | `stevearc/conform.nvim` + `mfussenegger/nvim-lint` |
| Format on save | Via `BufWritePre` in `lsp/format.lua`, toggleable | Via `conform` `format_on_save`, timeout 500ms |
| Lint | Via none-ls diagnostics sources | Via `nvim-lint` on `BufEnter/BufWritePost/InsertLeave` |
| Formatters | stylua, prettier, black, shfmt, terraform_fmt, hclfmt, sqlfmt, markdownlint | Same set |
| Linters | flake8, mypy, proselint, write_good | flake8, mypy, markdownlint, shellcheck, hadolint |
| Extras | `b.code_actions.gitsigns`, `b.code_actions.proselint`, `b.completion.spell` | None (gitsigns code actions gone) |
| Format key | `<leader>cf` (n + v) | `<leader>cf` (n + v), async |

Old none-ls also included `autopep8`, `beautysh`, `gopls`, `hadolint`, `shellcheck`, `write-good`, `yamlfmt` in Mason `ensure_installed`.

New Mason `ensure_installed` is leaner — only what conform/nvim-lint actually use plus debugpy.

### File Picker / Search

**Old** uses **Telescope** as the primary picker, plus **fzf-lua** as a secondary alternative:

- Telescope with extensions: `telescope-fzf-native`, `telescope-terraform-doc`, `advanced-git-search` (diffview integration)
- Custom picker: `lua/plugins/telescope/find_filetype.lua` — live grep filtered by filetype via `rg -t`
- `after/plugin/advanced-git-search.lua` — registers `DiffCommitLine` user command + visual `<leader>dcl` keymap
- fzf-lua with `<leader>lf/<leader>lg/<leader>lr/<leader>ls`

**New** uses **Snacks.picker** for everything — no Telescope at all:

- Smart find: `<leader><space>`
- Files: `<leader>ff`, Recent: `<leader>fo`, Buffers: `<leader>fb`
- Grep: `<leader>fg` / `<leader>sg`, Word: `<leader>sw`
- Help: `<leader>fh`, Keymaps: `<leader>sk`, Command history: `<leader>sc`
- Commands: `<leader>sC`, Diagnostics: `<leader>sd`, Marks: `<leader>sm`
- Highlights: `<leader>sH`, Resume: `<leader>sr`, Todos: `<leader>st`
- Colorschemes: `<leader>tc`
- Git: branches `<leader>gb`, log `<leader>gl`, status `<leader>gs`
- LSP: definitions `gd`, references `gr`, implementations `gI`, type defs `gt`, symbols `<leader>ss`
- Grep in directory (prompted): `<leader>tw`
- Edit nvim config: `<leader>en`

### File Explorer

| | Old | New |
|---|---|---|
| Sidebar | `kyazdani42/nvim-tree.lua` | `nvim-neo-tree/neo-tree.nvim` (v3.x) |
| Buffer-style | `stevearc/oil.nvim` (minimal opts) | `stevearc/oil.nvim` (with mini.icons) |
| Tree toggle | `<leader>e` | `<leader>e` (Neotree), `<leader>E` reveal |
| Oil open | `-` key | `-` key |
| Icons | nvim-web-devicons | mini.icons (for oil) + nvim-web-devicons |

Old nvim-tree is heavily configured: adaptive size, libuv watcher, git disabled, custom glyphs. New neo-tree is minimal: follow current file, libuv watcher, 35px wide, `<space>` disabled to not steal leader.

### LSP

**Old** has a dedicated `lua/plugins/lsp/` directory with three modules:

- `lsp/init.lua` — plugin spec (nvim-lspconfig, none-ls, mason, lspsaga)
- `lsp/keymaps.lua` — `M.get()` / `M.on_attach()` with lazy.nvim key handler integration, `M.rename()` (checks for inc_rename), `M.diagnostic_goto()`
- `lsp/format.lua` — `M.autoformat` toggle, `M.format()` (null-ls-aware), `M.on_attach()` BufWritePre hook
- `lsp/util.lua` — `M.on_attach()` wrapper that also attaches navic

LSP keymaps use Telescope for navigation: `gd` → `Telescope lsp_definitions`, `gr` → `Telescope lsp_references`, `gI` → `Telescope lsp_implementations`, `gt` → `Telescope lsp_type_definitions`.

Hover uses **lspsaga**: `K` → `Lspsaga hover_doc`, `lf` → `Lspsaga finder`.

**New** does everything in a single `lsp.lua` via a `LspAttach` autocmd:

- Navigation via Snacks.picker: `gd`, `gr`, `gI`, `gt`, `<leader>ss`
- Native hover: `K` → `vim.lsp.buf.hover`
- `<leader>cr` → `vim.lsp.buf.rename` (no inc_rename fallback)
- `<leader>ca` → `vim.lsp.buf.code_action` (was missing from old)
- `<leader>co` → Navbuddy code outline
- `<leader>ci` → LspInfo
- Per-severity diagnostic nav: `]e/[e` errors, `]w/[w` warnings
- `<C-h>` in insert → signature help
- `automatic_enable = true` in mason-lspconfig (old used `automatic_enable = false` + manual `vim.lsp.enable()`)

Old also had: `neodev.nvim` (Lua LSP type checking). New replaces with `lazydev.nvim` + `luvit-meta`, with explicit Snacks word support in the library.

Old had `nvim-navbuddy` from `SmiteshP/nvim-navbuddy`. New uses `hasansujon786/nvim-navbuddy` (a fork).

Old had **lspsaga** with code action lightbulb disabled and outline on left. New has no lspsaga.

Old had `j-hui/fidget.nvim` (tag = "legacy") for LSP progress. New has none (snacks notifier handles this).

### Git

| Plugin | Old | New |
|---|---|---|
| Fugitive | `lazy = false`, no keymaps | `cmd = "Git"`, `<leader>gg` |
| Gitsigns | `numhl=true`, `current_line_blame=true`, minimal hunk ops | More complete: stage/reset/undo/buffer ops, blame, diffthis, text object `ih` |
| Gitlinker | `lazy = false` | lazy, keymaps `<leader>gy` (n+v) |
| Diffview | Via telescope dependency, `<leader>do/<leader>dc` | Standalone, `<leader>gdo/<leader>gdc/<leader>gdh` (+ file history) |
| Advanced git search | Yes (telescope extension + DiffCommitLine cmd) | No |
| Octo | `lazy = false`, uses `requires` | `cmd = "Octo"`, uses `dependencies` |

Gitsigns old keymaps: `ghn/ghp` next/prev hunk, `]h/[h` next/prev, `<leader>rh` reset hunk (visual), `<leader>ph` preview hunk.

Gitsigns new keymaps: `]h/[h` with diff-mode awareness, `<leader>ghs/r` stage/reset, `<leader>ghS/R` stage/reset buffer, `<leader>ghu` undo stage, `<leader>ghp` preview, `<leader>ghb` blame (full), `<leader>ghd/D` diffthis, `ih` text object.

### Treesitter

**Old** uses the legacy `nvim-treesitter.configs.setup()` API with opts table:
- Highlights, indent, context_commentstring, incremental_selection
- Rainbow parentheses
- Rich textobjects: assignments (`aa/ia/la/ra`), statements (`as`), blocks (`ab/ib`), functions (`af/if`), classes (`ac/ic`), comments (`at`), parameters (`ap/ip`)
- Motion: `]m/[m/]M/[M` functions, `]]/[[/][/[]` classes, `]c/[c` conditionals, `]b/[b` blocks
- Swap: `<leader>a/<leader>A` parameters
- Key: `<c-space>` increment, `<bs>` decrement, `;` repeat last move
- Extra parser: `help`, `json5`, `jsonc`

**New** uses the v1.x API:
- `require("nvim-treesitter").setup()` (installs only)
- Manual `FileType` autocmd to start treesitter per buffer
- Textobjects: functions (`af/if`), classes (`ac/ic`), parameters (`aa/ia`)
- Motion: `]m/[m/]M/[M` functions, `]]/[[` classes
- Swap: `<leader>a/<leader>A` parameters
- No rainbow, no context_commentstring, no incremental_selection
- Extra parser: `luadoc`, `vimdoc` (instead of `help`)

### UI

#### Colorscheme

**Old**: onenord (priority 1001, `fade_nc`), catppuccin (priority 1002), tokyonight (priority 1001) — all `lazy = false`, no explicit `vim.cmd.colorscheme()` call (presumably set elsewhere or first one wins).

**New**: onenord (`priority = 1000`, explicitly calls `vim.cmd.colorscheme("onenord")` in config fn), catppuccin (`lazy = true`, with full integration opts: blink_cmp, bufferline, diffview, flash, gitsigns, lsp_trouble, mason, noice, snacks, treesitter, which_key, mini), tokyonight (`lazy = true`).

#### Bufferline

**Old**: Very heavily customized — tab_size 21, max_name_length 30, custom highlights for every state (fill, background, buffer_visible, close_button, tab_selected, tab, tab_close, duplicate with underline/italic, modified, separator, indicator). Close uses `mini.bufremove`. Offsets for NvimTree, DiffviewFiles, packer. Diagnostics disabled.

**New**: Minimal — `diagnostics = "nvim_lsp"` with icon indicators (` ` / ` `), `always_show_bufferline = false`, offset for oil only. Simpler and cleaner.

#### Lualine

**Old**: Clock in `lualine_z` (`os.date("%R")`), navic breadcrumbs in `lualine_c`, noice command+mode in `lualine_x`, lazy update count in `lualine_x`, diff in `lualine_x`. Extension: `nvim-tree`. `laststatus = 0` in options (conflict?).

**New**: No clock, no navic breadcrumbs, DAP status in `lualine_x` (shown when debugging), noice command+mode in `lualine_x`, diff in `lualine_x`. Icons defined cleanly. `laststatus = 3`.

#### Noice

**Old**: Intercepts `vim.notify`, overrides `vim.lsp.util.*`, `long_message_to_split` preset, routes that skip common save/edit messages. Keys: `<S-Enter>` redirect, `<leader>snl` last, `<leader>snh` history, `<leader>sna` all, `<c-f>/<c-b>` LSP scroll.

**New**: `notify.enabled = false` (snacks.notifier handles `vim.notify`), same LSP overrides, routes write messages to `"mini"` view instead of skipping, presets: `bottom_search=true`, `command_palette=true`, `long_message_to_split=true`. Keys: `<S-Enter>` redirect, `<leader>snh` history, `<leader>sna` all, `<c-f>/<c-b>` scroll (modes i/n/s).

#### Snacks

**Old** snacks opts: bigfile, dashboard, dim (no `enabled` key), indent (no `enabled` key), input, notifier, quickfile, statuscolumn, words, styles, **explorer** (enabled), picker (frecency only). Toggles in `VeryLazy` callback (init function). Buffer delete: `<leader>d`.

**New** snacks opts: bigfile, dashboard, **dim** (`enabled=true`), **indent** (`enabled=true`), input, notifier, picker (`enabled=true`, frecency), quickfile, statuscolumn, words, **zen** (`enabled=true`). No explorer. Toggles in `config` function using `.map()`. Buffer delete: `<leader>bd`. More picker keymaps. `<leader>N` notification history.

**Old** has `Snacks.toggle.treesitter():map("<leader>uT")` and `Snacks.toggle.option("background", ...):map("<leader>ub")` — **new does not**.

### DAP

| | Old | New |
|---|---|---|
| Step out | Commented out | `<leader>dse` |
| Run to cursor | No | `<leader>dR` |
| DAP UI toggle | No | `<leader>du` |
| UI open event | `before.attach` + `before.launch` | `after.event_initialized` |
| debugpy path | hardcoded mason path | Mason path with fallback to `python3` |
| nvim-nio | dep of nvim-dap-ui | explicit `{ lazy = true }` spec |

### Editor Utilities

| Plugin | Old | New |
|---|---|---|
| harpoon | Yes (`<leader>hc/d/m/v`) | **No** |
| spectre | Yes (`<leader>sr`) | **No** (snacks grep covers this) |
| nvim-ufo | `{ "lsp", "indent" }` providers | `{ "treesitter", "indent" }` providers |
| outline.nvim | Yes (`<leader>o`) | **No** (navbuddy via LSP keymaps) |
| toggleterm | `direction = "float"` | `direction = "float"`, curved border |
| illuminate | Yes (`event = BufReadPost`, 200ms delay) | **No** (snacks words covers this) |
| troublesum | Yes | **No** |
| glow.nvim | Yes (`ft = markdown`, `:Glow`) | **No** |
| markdown-preview | Yes | Yes (`<leader>mp`) |
| Comment.nvim | `<leader>/` (n+v), module-loaded | `<leader>/` (n+v), event=VeryLazy |
| mini.surround | `gz*` mappings | `gz*` mappings |
| which-key | Yes, groups defined | Yes, more groups defined |
| todo-comments | `TodoTrouble`/`TodoTelescope` cmds, highlight pattern tweak | `Trouble todo toggle`, `Snacks.picker.todo_comments()` |
| trouble.nvim | `TroubleToggle document_diagnostics`, `TroubleToggle workspace_diagnostics` | `Trouble diagnostics toggle`, buffer filter, symbols, LSP, loclist, qflist |

### Copilot

**Old**: `lazy = false`, conditionally loaded based on `setup.lua`'s `enable_copilot = true` flag via `cond`. `<C-p>` to accept.

**New**: `event = "InsertEnter"` (properly lazy), always loaded. `<C-p>` to accept.

### Obsidian

**Old**: `lazy = false`, event-triggered on `~/projects/obsidian/**.md` patterns, workspace name `"obsidian"`.

**New**: `lazy = true`, `ft = "markdown"`, workspace name `"personal"`.

---

## Keymaps: Side-by-Side

### Global Keymaps — Old Only

| Key | Action |
|---|---|
| `gw` / `gx` (n+x) | `*N` search current word |
| `n` / `N` (n+x+o) | Saner search direction via expr |
| `i` `,` / `.` / `;` | Insert undo breakpoints |
| `<leader>ur` | Redraw + clear hlsearch + diff update |
| `<leader>bb` / `<leader>`` | Switch to other buffer (`e #`) |
| `<leader>ww` | Other window (`<C-W>p`) |
| `<leader>lt` | ToggleListItem (markdown list) |

### Global Keymaps — New Only

| Key | Action |
|---|---|
| `<C-h/j/k/l>` | Window navigation |
| `<leader>ui` | Inspect position (`vim.show_pos`) |
| `<leader>en` | Snacks picker on nvim config dir |

### Paste Behaviour

- Old: `v p` → `P` (put before, preserving register — a simpler approach)
- New: `v p` → `"_dP` (delete to black hole, then put — more explicit)

### j/k remapping

- Old: commented out
- New: active for both `n` and `x` modes

### LSP Keymaps

| Key | Old | New |
|---|---|---|
| `gd` | `Telescope lsp_definitions` | `Snacks.picker.lsp_definitions()` |
| `gr` | `Telescope lsp_references` | `Snacks.picker.lsp_references()` |
| `gI` | `Telescope lsp_implementations` | `Snacks.picker.lsp_implementations()` |
| `gt` | `Telescope lsp_type_definitions` | `Snacks.picker.lsp_type_definitions()` |
| `K` | `Lspsaga hover_doc` | `vim.lsp.buf.hover` |
| `lf` | `Lspsaga finder` | — |
| `<leader>cr` | Rename (inc_rename or lsp) | `vim.lsp.buf.rename` |
| `<leader>cf` | Format | Format (conform) |
| `<leader>ca` | — | `vim.lsp.buf.code_action` |
| `<leader>co` | — | Navbuddy |
| `<leader>ci` | `LspInfo` | `LspInfo` |
| `<leader>cl` | `LspInfo` | Trouble LSP panel |
| `<leader>cd` | `vim.diagnostic.open_float` | `vim.diagnostic.open_float` (global) |
| `<leader>ss` | Telescope workspace symbols | `Snacks.picker.lsp_symbols()` |
| `<leader>nb` | Navbuddy | — (folded into `<leader>co`) |
| `]d/[d` | Diagnostic next/prev | Diagnostic next/prev (global) |
| `]e/[e` | Next/prev error | Next/prev error |
| `]w/[w` | Next/prev warning | Next/prev warning |
| `<c-h>` insert | Signature help | Signature help |

---

## Structural / Architectural Differences

### Old: Multi-file LSP
The old config splits LSP into `lsp/init.lua`, `lsp/keymaps.lua`, `lsp/format.lua`, `lsp/util.lua`. This is a mini-framework modelled after LazyVim's internal structure. It is more modular but harder to follow.

### New: Single-file LSP
All LSP logic lives in `lsp.lua` using a `LspAttach` autocmd. This is the modern idiomatic approach — simpler, explicit, and doesn't require cross-file coordination.

### Old: none-ls as the "everything" formatter
none-ls was used for formatting, linting, spell completion, proselint code actions, and gitsigns code actions — all in one tool. This is a common source of friction (startup cost, server protocol overhead for non-LSP tools).

### New: Conform + nvim-lint separation
Format-only tools go to conform, lint-only tools go to nvim-lint. Cleaner separation, better performance.

### Old: Telescope-centric workflow
Almost all fuzzy finding, navigation, and search goes through Telescope. Requires fzf-native build, multiple extensions, an `after/plugin/` hook for advanced-git-search, and a custom picker file.

### New: Snacks-centric workflow
Everything goes through `Snacks.picker`, which is the picker built into snacks.nvim — already loaded, frecency-enabled, no extra dependencies or extensions.

### Old: `setup.lua` config flag
`lua/config/setup.lua` returns `{ enable_copilot = true }` which coding.lua reads via `pcall(require, "config.setup")` to conditionally load Copilot. Also, `work.lua` stores a PR template macro in a register.

### New: No config flags
Copilot always loads. No work.lua equivalent.

### Old: Snacks toggles in `init` (VeryLazy callback)
Toggles run inside the `VeryLazy` user event callback — they work but don't register keymaps until VeryLazy fires.

### New: Snacks toggles in `config` function using `.map()`
Toggles run immediately when snacks loads (since `lazy = false`), and use the `.map()` method which integrates with which-key to show dynamic enabled/disabled icons and color-coded descriptions.

---

## Plugins in Old But Not New

| Plugin | Purpose | Replaced by |
|---|---|---|
| `nvim-telescope/telescope.nvim` + extensions | Fuzzy finder | Snacks.picker |
| `ANGkeith/telescope-terraform-doc.nvim` | Terraform docs | — |
| `aaronhallaert/advanced-git-search.nvim` | Git search in telescope | — |
| `nvim-telescope/telescope-fzf-native.nvim` | FZF for telescope | — |
| `ibhagwan/fzf-lua` | Secondary fuzzy finder | — |
| `kyazdani42/nvim-tree.lua` | File explorer sidebar | neo-tree |
| `windwp/nvim-spectre` | Search/replace in files | Snacks grep |
| `ThePrimeagen/harpoon` | File bookmarks | — |
| `hrsh7th/nvim-cmp` + sources | Completion | blink.cmp |
| `nvimtools/none-ls.nvim` | Formatting + linting | conform.nvim + nvim-lint |
| `nvimdev/lspsaga.nvim` | LSP UI (hover, finder) | native vim.lsp + snacks |
| `folke/neodev.nvim` | Lua LSP type checking | lazydev.nvim |
| `SmiteshP/nvim-navic` | Breadcrumbs in lualine | removed |
| `SmiteshP/nvim-navbuddy` | Code outline | hasansujon786/nvim-navbuddy |
| `j-hui/fidget.nvim` | LSP progress spinner | snacks notifier |
| `RRethy/vim-illuminate` | Reference highlighting | snacks words |
| `hedyhli/outline.nvim` | Symbol outline panel | navbuddy |
| `ellisonleao/glow.nvim` | Markdown preview in terminal | — |
| `ivanjermakov/troublesum.nvim` | Trouble summary | — |
| `rmehri01/onenord.nvim` (priority 1001) | Colorscheme | same, explicit default |
| `catppuccin/nvim` (lazy=false) | Colorscheme | same, lazy=true |
| `numToStr/Comment.nvim` | Comments | same |
| `ruifm/gitlinker.nvim` (lazy=false) | Git links | same, properly lazy |
| `pwntester/octo.nvim` (lazy=false) | GitHub in nvim | same, cmd-lazy |

## Plugins in New But Not Old

| Plugin | Purpose |
|---|---|
| `saghen/blink.cmp` | Modern completion engine |
| `stevearc/conform.nvim` | Dedicated formatter |
| `mfussenegger/nvim-lint` | Dedicated linter |
| `nvim-neo-tree/neo-tree.nvim` | Modern file tree |
| `folke/lazydev.nvim` | Lua LSP (replaces neodev) |
| `Bilal2453/luvit-meta` | Lua uv type annotations |
| `hasansujon786/nvim-navbuddy` | Navbuddy fork |

---

## Notable Gaps — Applied

These were present in the old config but absent from `nvim_new`. All have since been added.

### Options (`lua/config/options.lua`)

| Option | What it does |
|---|---|
| `inccommand = "nosplit"` | Live preview of `:s/foo/bar` substitutions in the buffer as you type |
| `confirm = true` | Prompts to save/discard instead of erroring when quitting a modified buffer |
| `list = true` | Makes invisible characters (trailing spaces, tabs) visible |
| `grepprg = "rg --vimgrep"` | Makes `:grep` use ripgrep instead of system grep |
| `grepformat = "%f:%l:%c:%m"` | Parses ripgrep output into the quickfix list correctly |
| `winminwidth = 5` | Prevents windows collapsing to zero width with many vertical splits |
| `undolevels = 10000` | Raises undo history from default 1000 to 10000 steps |

### Keymaps (`lua/config/keymaps.lua`)

| Key | What it does |
|---|---|
| `n` / `N` (n, x, o) | Saner search direction — always means next/prev relative to the direction searched |
| `i` `,` / `.` / `;` | Insert undo breakpoints at punctuation — undo works at clause granularity, not full insert session |
| `<leader>bb` | Switch to alternate buffer (`e #`) — fast toggle between two files |
| `<leader>ur` | Redraw screen + clear search highlights + force diff update |
