-- Toggleable terminal.
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Terminal: Toggle" },
    { [[<c-t>]], "<cmd>ToggleTerm<CR>", desc = "Terminal: Toggle", mode = { "n", "t" } },
  },
  opts = {
    open_mapping = [[<c-t>]],
    direction = "float",
    float_opts = { border = "curved" },
  },
}
