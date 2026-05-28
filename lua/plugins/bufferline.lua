-- Buffer tab bar: shows each open file as a tab and lets you flip between them.
-- In Neovim every file you open stays loaded as a "buffer" until you close it,
-- so switching is instant -- no re-opening required.
return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  keys = {
    -- Cycle between buffers.
    { "<S-l>", "<cmd>BufferLineCycleNext<CR>", desc = "Buffer: Next" },
    { "<S-h>", "<cmd>BufferLineCyclePrev<CR>", desc = "Buffer: Prev" },
    -- Move a buffer left/right in the bar.
    { "<leader>b.", "<cmd>BufferLineMoveNext<CR>", desc = "Buffer: Move right" },
    { "<leader>b,", "<cmd>BufferLineMovePrev<CR>", desc = "Buffer: Move left" },
    -- Jump straight to a buffer by its visible position (1-9).
    { "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Buffer: Go to 1" },
    { "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Buffer: Go to 2" },
    { "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Buffer: Go to 3" },
    { "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Buffer: Go to 4" },
    { "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Buffer: Go to 5" },
    { "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Buffer: Go to 6" },
    { "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Buffer: Go to 7" },
    { "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Buffer: Go to 8" },
    { "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Buffer: Go to 9" },
    -- Pick a buffer interactively by the letter shown on each tab.
    { "<leader>bp", "<cmd>BufferLinePick<CR>", desc = "Buffer: Pick" },
    -- Close the current buffer (keeps your window layout intact).
    { "<leader>bd", "<cmd>bdelete<CR>", desc = "Buffer: Delete" },
    -- Close every buffer except the current one.
    { "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", desc = "Buffer: Close others" },
  },
  opts = {
    options = {
      diagnostics = "nvim_lsp", -- surface LSP errors/warnings on each tab
      separator_style = "slant",
      show_buffer_close_icons = true,
      show_close_icon = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Explorer",
          text_align = "center",
          separator = true,
        },
      },
    },
  },
}
