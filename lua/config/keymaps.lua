local map = vim.keymap.set

-- Clear search highlight.
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- LSP (these functions are always available; buffers attach a client as needed).
map("n", "gd", vim.lsp.buf.definition, { desc = "LSP: Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "LSP: Go to declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "LSP: References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "LSP: Implementation" })
map("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: Rename" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: Code action" })

-- Diagnostics.
map("n", "<leader>fd", vim.diagnostic.open_float, { desc = "Diagnostics: Float" })
map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Diagnostics: Prev" })
map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Diagnostics: Next" })

-- Plugin keymaps (Neotree, Telescope, ToggleTerm) are defined in their
-- lua/plugins/*.lua specs so the plugins can lazy-load on first use.
