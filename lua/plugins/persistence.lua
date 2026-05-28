-- Per-directory session persistence: remembers the buffers/layout you had open
-- in each codebase and restores them next time you `nvim` that directory.
-- Restore is triggered explicitly from lua/config/autocmds.lua on startup.
return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- start tracking once a real file is opened
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Session: Restore for this dir" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Session: Restore last" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Session: Don't save this one" },
  },
  opts = {},
  config = function(_, opts)
    -- Keep junk out of saved sessions: no blank/help/terminal windows.
    vim.o.sessionoptions = "buffers,curdir,folds,globals,skiprtp,tabpages,winsize"

    require("persistence").setup(opts)

    -- Close neo-tree before a session is written so it isn't restored as a
    -- broken/empty window next time -- our autocmd re-opens it fresh instead.
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceSavePre",
      callback = function()
        pcall(vim.cmd, "Neotree close")
      end,
    })
  end,
}
