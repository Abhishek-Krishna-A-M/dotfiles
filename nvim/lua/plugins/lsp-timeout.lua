return {
  "hinell/lsp-timeout.nvim",
  dependencies = { "neovim/nvim-lspconfig" },
  init = function()
    -- Set the timeout to 3 minutes (180,000 ms) 
    -- This kills the LSP if you aren't actively in a JSX/TSX buffer
    vim.g.lsp_timeout_config = {
      stop_timeout = 180000, 
      silent = true,
    }
  end
}
