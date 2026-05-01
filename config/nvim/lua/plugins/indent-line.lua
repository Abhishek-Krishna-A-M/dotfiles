return {
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    main = "ibl",
    opts = {
      -- This defines the character for the vertical line
      indent = {
        char = "│", -- You can change this to "╎" or "┆" if you want it thinner
        tab_char = "│",
      },
      -- This section handles the "Active Block" highlighting
      scope = {
        enabled = true,
        show_start = true, -- Shows an underline at the start of the block
        show_end = false,
        highlight = { "Function", "Label" }, -- Colors the line based on your theme
      },
      -- Exclude these filetypes to save memory/resources
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
}
