-- Nordic theme.
return {
  "AlexvZyl/nordic.nvim",
  lazy = false,
  priority = 1000, -- load before everything else so colors apply on startup
  config = function()
    require("nordic").setup({
      italic_comments = true,
      transparent = { bg = false },
    })
    require("nordic").load()
  end,
}
