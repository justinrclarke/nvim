-- Static analysis diagnostics via external linters.
-- PHP: PHPStan (works with Larastan in Laravel projects). We only lint when the
-- project actually has phpstan installed at <root>/vendor/bin/phpstan, so it is
-- silent in projects that don't use it -- no spurious errors.
return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      php = { "phpstan" },
    }

    -- Resolve the project's local phpstan binary by walking up from the buffer.
    local function local_phpstan()
      local root = vim.fs.root(0, { "composer.json", ".git" }) or vim.uv.cwd()
      local bin = root .. "/vendor/bin/phpstan"
      return vim.fn.filereadable(bin) == 1 and bin or nil
    end

    local function try_lint()
      if vim.bo.filetype == "php" then
        local bin = local_phpstan()
        if not bin then
          return -- no project phpstan -> stay quiet
        end
        lint.linters.phpstan.cmd = bin
      end
      lint.try_lint()
    end

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
      callback = try_lint,
    })
  end,
}
