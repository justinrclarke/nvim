-- File explorer.
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle left<CR>", desc = "Explorer: Toggle" },
  },
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "disabled", -- our autocmd owns auto-open
      -- Always show dotfiles / hidden / gitignored files.
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_hidden = false, -- Windows-only "hidden" attribute
      },
    },
    window = { position = "left", width = 32 },
  },
}
