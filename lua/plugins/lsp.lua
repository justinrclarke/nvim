-- Language servers. Mason installs the binaries; nvim-lspconfig ships the
-- per-server definitions (cmd, filetypes, root markers) under its `lsp/`
-- runtime dir. We configure + enable them with the built-in vim.lsp API
-- (nvim 0.11+), not the deprecated `require('lspconfig')[x].setup()` path.
return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Language servers (provide diagnostics/error-checking + completion).
      local servers = {
        "ts_ls", -- JavaScript / TypeScript
        "jsonls", -- JSON
        "yamlls", -- YAML
        "taplo", -- TOML
        "bashls", -- Bash (uses shellcheck for diagnostics)
        "intelephense", -- PHP (replaces phpactor)
        "gopls", -- Go
        "pyright", -- Python
        "rust_analyzer", -- Rust
        "zls", -- Zig (needs the zig toolchain installed)
        "lua_ls", -- Lua
      }

      -- Non-LSP CLI tools (linters/formatters). shellcheck powers bashls'
      -- diagnostics; mason prepends its bin dir to PATH so bashls finds it.
      local tools = {
        "shellcheck",
      }

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        -- We enable servers ourselves below, so don't double-enable here.
        automatic_enable = false,
      })
      require("mason-tool-installer").setup({
        ensure_installed = tools,
        run_on_start = true,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Defaults merged into every server config.
      vim.lsp.config("*", { capabilities = capabilities })

      -- Per-server overrides.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- Several language servers are Node scripts (mason installs them with an
      -- `env node` shebang), so they run on whatever node is first on PATH --
      -- here, Herd's EOL v18. Launch them explicitly with the NEWEST installed
      -- node so they use a current LTS. Resolved dynamically (survives Herd
      -- adding/removing versions); only these LSPs are affected -- the shell,
      -- terminal, and Herd's per-site node are untouched.
      local function newest_node()
        local roots = {
          vim.fn.expand("~/Library/Application Support/Herd/config/nvm/versions/node"),
          vim.fn.expand("~/.nvm/versions/node"),
        }
        local best, best_path = { -1, -1, -1 }, nil
        for _, root in ipairs(roots) do
          if vim.fn.isdirectory(root) == 1 then
            for name, t in vim.fs.dir(root) do
              local a, b, c = name:match("^v(%d+)%.(%d+)%.(%d+)$")
              if t == "directory" and a then
                local v = { tonumber(a), tonumber(b), tonumber(c) }
                if v[1] > best[1]
                  or (v[1] == best[1] and v[2] > best[2])
                  or (v[1] == best[1] and v[2] == best[2] and v[3] > best[3])
                then
                  local node = root .. "/" .. name .. "/bin/node"
                  if vim.fn.executable(node) == 1 then
                    best, best_path = v, node
                  end
                end
              end
            end
          end
        end
        return best_path
      end

      local node = newest_node()
      if node then
        local mason_bin = vim.fn.expand("~/.local/share/nvim/mason/bin/")
        local node_servers = { "ts_ls", "jsonls", "yamlls", "bashls", "pyright", "intelephense" }
        for _, name in ipairs(node_servers) do
          local def = vim.lsp.config[name] -- merged default config from lspconfig's lsp/ file
          if def and type(def.cmd) == "table" and def.cmd[1] then
            local bin = mason_bin .. def.cmd[1]
            if vim.fn.filereadable(bin) == 1 then
              local cmd = { node, bin }
              for i = 2, #def.cmd do
                cmd[#cmd + 1] = def.cmd[i]
              end
              vim.lsp.config(name, { cmd = cmd })
            end
          end
        end
      end

      vim.lsp.enable(servers)
    end,
  },
}
