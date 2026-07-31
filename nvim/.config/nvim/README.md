# Neovim & Telescope Configuration Cheat Sheet

---

## 1. General & Utility Keymaps

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| **`jk`** | Insert | `<Esc>` | Instantly exit insert mode |
| **`<Esc>`** | Normal | `:nohlsearch<CR><Esc>` | Clear search highlights and escape |
| **`<leader>w`** | Normal | `:w<CR>` | Save current file |
| **`<leader>q`** | Normal | `:q<CR>` | Quit current window |
| **`<leader>wq`** | Normal | `:wq<CR>` | Save and quit |

---

## 2. Telescope Fuzzy Finder

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| **`<leader>ff`** | Normal | `find_files()` | Find files (respects `.gitignore`) |
| **`<leader>fg`** | Normal | `live_grep()` | Live grep text search (respects `.gitignore`) |
| **`<leader>FF`** | Normal | `find_files({ no_ignore = true, hidden = true })` | Find **ALL** files (bypasses `.gitignore`, includes hidden) |
| **`<leader>FG`** | Normal | `live_grep({ no_ignore = true, hidden = true })` | Live grep **ALL** files (bypasses `.gitignore`) |
| **`<leader>fb`** | Normal | `buffers()` | Find open buffers |
| **`<leader>fh`** | Normal | `help_tags()` | Search Neovim help documentation |
| **`<leader>/`** | Normal | `current_buffer_fuzzy_find()` | Search text inside the active buffer |
| **`<leader>fr`** | Normal | `resume()` | Resume the previous Telescope window |

### Telescope Prompt Navigation (Insert Mode)
* **`<C-n>` / `<C-p>`** — Move selection down / up
* **`<Tab>` / `<S-Tab>`** — Alternative next / previous item navigation
* **`jk` or `<Esc>`** — Instantly close Telescope

---

## 3. LSP & Code Intelligence (Buffer-Local)

| Keybinding | Mode | Action | Description |
| :--- | :--- | :--- | :--- |
| **`gd`** | Normal | `vim.lsp.buf.definition` | Jump to symbol definition |
| **`gy`** | Normal | `vim.lsp.buf.type_definition` | Jump to symbol type definition |
| **`gr`** | Normal | `vim.lsp.buf.references` | Find all references across workspace |
| **`K`** | Normal | `vim.lsp.buf.hover` | Open floating documentation window |
| **`<leader>rn`** | Normal | `vim.lsp.buf.rename` | Workspace rename (updates symbol & all imports globally) |
| **`<leader>ca`** | Normal | `vim.lsp.buf.code_action` | Open Code Actions menu (quick-fixes, auto-imports) |
| **`gl`** | Normal | `vim.diagnostic.open_float` | Open floating error/warning diagnostic for current line |
| **`<leader>dw`** | Normal | `vim.diagnostic.setqflist` | Send all workspace diagnostics to Quickfix list |
| **`<leader>rr`** | Normal | *Custom Script* | Force restart Svelte LSP |
| **`<C-Space>`** | Insert | `<C-x><C-o>` | Trigger native completion |
| **`<C-h>`** | Insert | `vim.lsp.buf.signature_help` | Open function signature help |

---

## 4. Advanced Workflows & Systemic Tricks

### A. Global Project-Wide Refactoring via Quickfix List
When restructuring folders or renaming paths that bypass LSP symbols:
1. Run **`<leader>fg`** (Live Grep) to search for the old string/path.
2. Press **`<C-q>`** (Ctrl + q) while in Telescope to dump all search matches directly into Neovim's **Quickfix List**.
3. Run a global command to substitute the text across every file in the list simultaneously and save them:
   ```vim
   :cdo s#old_path/#new_path/#g | update
