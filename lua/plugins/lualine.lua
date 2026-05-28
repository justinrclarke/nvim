-- Statusline.
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto", -- adapts to the active colorscheme (Nordic)
      globalstatus = true, -- one statusline for the whole window, not per-split
      icons_enabled = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff", "diagnostics" },
      lualine_c = { { "filename", path = 1 } }, -- relative path
      lualine_x = { "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
  },
}
