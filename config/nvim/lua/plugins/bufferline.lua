return {
  "echasnovski/mini.tabline",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Light font-based icons
  config = function()
    require("mini.tabline").setup({
      show_icons = true, -- Adds visual flair for "free"
      format = function(buf_id, label)
        local name = vim.fn.fnamemodify(label, ":t")
        local parent = vim.fn.fnamemodify(label, ":h:t")
        
        -- Get the icon for the file type
        local icon, hl = require("nvim-web-devicons").get_icon(name, nil, { default = true })

        if parent ~= "." then
          return icon .. " " .. parent .. "/" .. name
        end
        return icon .. " " .. name
      end,
    })

    -- Force transparency for mini.tabline specifically
    local hl_groups = { "MiniTablineFill", "MiniTablineActive", "MiniTablineVisible", "MiniTablineHidden" }
    for _, group in ipairs(hl_groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
  end,
}
