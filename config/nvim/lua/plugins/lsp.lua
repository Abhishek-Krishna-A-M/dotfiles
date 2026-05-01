return {
  "neovim/nvim-lspconfig",
  -- CRITICAL: Set lazy to false to prevent the "LspStart not found" error on VimEnter
  lazy = false,

  config = function()
    ------------------------------------------------------------------
    -- DIAGNOSTICS
    ------------------------------------------------------------------
    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      underline = true,
      severity_sort = true,
      update_in_insert = false,
      float = {
        border = "rounded",
        source = "if_many",
      },
    })

    ------------------------------------------------------------------
    -- ON_ATTACH (Keymaps)
    ------------------------------------------------------------------
    local on_attach = function(_, bufnr)
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, {
          buffer = bufnr,
          silent = true,
          desc = desc,
        })
      end

      map("n", "gd", vim.lsp.buf.definition, "Go to definition")
      map("n", "gr", vim.lsp.buf.references, "Find references")
      map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
      map("n", "K", vim.lsp.buf.hover, "Hover documentation")

      map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
      map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")

      map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostics")
      map("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, "Previous diagnostic")
      map("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, "Next diagnostic")

      map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
    end

    ------------------------------------------------------------------
    -- CAPABILITIES
    ------------------------------------------------------------------
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    ------------------------------------------------------------------
    -- LSP CONFIG HELPER (Neovim 0.11 Style)
    ------------------------------------------------------------------
    local lsp = vim.lsp.config

    -- Set global defaults for all servers
    lsp("*", {
      root_markers = { ".git" },
      on_attach = on_attach,
      capabilities = capabilities,
    })

    ------------------------------------------------------------------
    -- LUA
    ------------------------------------------------------------------
    lsp("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })

    ------------------------------------------------------------------
    -- VTSLS (Typescript)
    ------------------------------------------------------------------
    lsp("vtsls", {
      settings = {
        typescript = {
          tsserver = {
          },
        },
        vtsls = {
          autoUseWorkspaceTsdk = true,
          experimental = {
            completion = { enableServerSideFuzzyMatch = true },
          },
        },
      },
    })

    ------------------------------------------------------------------
    -- PYTHON
    ------------------------------------------------------------------
    lsp("pyright", {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
            autoImportCompletions = true,
          },
        },
      },
    })

    ------------------------------------------------------------------
    -- OTHER SERVERS (Standard Config)
    ------------------------------------------------------------------
    local servers = {
      "html",
      "cssls",
      "jsonls",
      "tailwindcss",
      "clangd",
      "jdtls",
      "gopls",
    }

    for _, name in ipairs(servers) do
      lsp(name, {})
    end

    ------------------------------------------------------------------
    -- ENABLE SERVERS
    ------------------------------------------------------------------
    -- This triggers the actual start logic for the servers listed
    vim.lsp.enable({
      "lua_ls",
      "vtsls",
      "pyright",
      "html",
      "cssls",
      "jsonls",
      "tailwindcss",
      "clangd",
      "jdtls",
      "gopls",
    })
  end,
}
