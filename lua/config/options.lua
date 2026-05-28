vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.termguicolors = true

-- Diagnostics: show the message inline (virtual text) and in the sign column,
-- and pop up the full message in a float when the cursor rests on the line.
vim.diagnostic.config({
  virtual_text = { prefix = "●", source = true },
  underline = true,
  severity_sort = true,
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

-- Auto-open the diagnostic float when the cursor rests on a line (after
-- 'updatetime' ms). `focus = false` keeps the cursor in your buffer.
vim.api.nvim_create_autocmd("CursorHold", {
  group = vim.api.nvim_create_augroup("diagnostic_float", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
  end,
})
