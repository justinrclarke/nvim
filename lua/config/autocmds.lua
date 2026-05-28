-- On startup with a directory (`nvim .`, `nvim ~/proj`) or no args (`nvim`):
--   * cd into that directory so sessions + the file tree agree on "where",
--   * clear the stray directory/empty buffers Neovim auto-creates,
--   * restore the previous session for that codebase if one exists,
--   * open neo-tree on the left.
-- Files opened directly (`nvim foo.lua`) are left untouched; stdin (git commit)
-- is ignored.

-- Disable netrw so opening a directory doesn't render a file listing in the
-- main window -- neo-tree is our file explorer instead.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local group = vim.api.nvim_create_augroup("auto_open_neotree", { clear = true })

local read_from_stdin = false
vim.api.nvim_create_autocmd("StdinReadPre", {
  group = group,
  callback = function()
    read_from_stdin = true
  end,
})

-- True if any *real* file buffer is loaded (i.e. a session actually restored
-- something), ignoring unlisted scratch/plugin buffers.
local function has_listed_file_buffer()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fn.buflisted(buf) == 1
      and vim.bo[buf].buftype == ""
      and vim.api.nvim_buf_get_name(buf) ~= ""
    then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = group,
  callback = function()
    if read_from_stdin then
      return -- git commit / piped stdin
    end

    local argv = vim.fn.argv()
    local target_dir
    if #argv == 0 then -- `nvim`
      target_dir = vim.fn.getcwd()
    elseif #argv == 1 then
      local stat = vim.uv.fs_stat(argv[1])
      if stat and stat.type == "directory" then -- `nvim .` / `nvim ~/proj`
        target_dir = vim.fn.fnamemodify(argv[1], ":p")
      end
    end
    if not target_dir then
      return -- a single/multiple file args -> leave as the user asked
    end

    vim.schedule(function()
      -- Make the project dir the cwd so the session key and the tree root match.
      vim.cmd("cd " .. vim.fn.fnameescape(target_dir))

      -- Replace the auto-created directory/empty buffer with an unlisted
      -- scratch so the buffer tab bar starts empty (no phantom tabs).
      local start_buf = vim.api.nvim_get_current_buf()
      local scratch = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_win_set_buf(0, scratch)
      pcall(vim.api.nvim_buf_delete, start_buf, { force = true })

      -- Restore the previous session for this codebase, if one exists.
      -- No-op (leaves the clean scratch) when there's no saved session.
      require("persistence").load()

      -- Always show the file tree on the left.
      vim.schedule(function()
        vim.cmd("Neotree show left")
        -- If a session restored real buffers, focus the first one instead of
        -- leaving the cursor in the tree.
        if has_listed_file_buffer() then
          vim.cmd("wincmd l")
        end
      end)
    end)
  end,
})
