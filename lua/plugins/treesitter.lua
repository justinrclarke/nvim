-- Syntax highlighting & indentation (nvim-treesitter `main` branch / new API).
-- `main` removed `nvim-treesitter.configs`, forbids lazy-loading, and does not
-- auto-enable highlight. We install parsers via require('nvim-treesitter').install()
-- and start highlighting via a FileType autocmd. Requires the tree-sitter CLI.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main", -- required for nvim 0.12 (master is 0.10/0.11-only)
  lazy = false, -- main branch forbids lazy-loading
  build = ":TSUpdate",
  config = function()
    local langs = {
      "bash",
      "lua",
      "vim",
      "vimdoc",
      "javascript",
      "typescript",
      "tsx",
      "php",
      "go",
      "rust",
      "python",
      "zig",
      "json",
      "yaml",
      "toml",
      "markdown",
      "markdown_inline",
    }
    require("nvim-treesitter").install(langs) -- async; no-ops if already present

    local ft_to_lang = {
      sh = "bash",
      bash = "bash",
      lua = "lua",
      vim = "vim",
      help = "vimdoc",
      javascript = "javascript",
      typescript = "typescript",
      typescriptreact = "tsx",
      php = "php",
      go = "go",
      rust = "rust",
      python = "python",
      zig = "zig",
      json = "json",
      yaml = "yaml",
      toml = "toml",
      markdown = "markdown",
    }
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("ts_highlight", { clear = true }),
      pattern = vim.tbl_keys(ft_to_lang),
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf) -- pcall: parser may still be compiling on 1st run
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
