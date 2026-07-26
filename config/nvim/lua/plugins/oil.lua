vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "oil://*",
  callback = function()
    local dir = require("oil").get_current_dir()
    if dir then
      vim.fn.chdir(dir)
    end
  end,
})

return {
  "stevearc/oil.nvim",
  event = "VeryLazy",
  opts = {
    default_file_explorer = true,
    delete_to_trash = false,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = false,
      natural_order = true,
    },
    float = {
      padding = 2,
      border = "rounded",
    },
    -- Fixed the nesting here (removed the extra 'opts = {')
    keymaps = {
      ["<CR>"] = "actions.select",
      ["-"] = "actions.parent",
      ["q"] = "actions.close",
      -- Manual CD if you ever need it
      ["<leader>cd"] = "actions.cd",
      -- PREVIEW
      ["p"] = function()
        require("oil").open_preview()
      end,
    },
  },
  keys = {
    { "-", "<cmd>Oil<CR>", desc = "Open parent directory (Oil)" },
    { "<leader>e", "<cmd>Oil<CR>", desc = "File explorer" },
  },
}
