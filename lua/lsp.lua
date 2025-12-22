-- mason: LSP server installer/manager
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright" },
})

-- completion capabilities from nvim-cmp
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    -- <C-Space> is often intercepted on macOS/terminals; add <C-@> as alias.
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-@>"] = cmp.mapping.complete(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Neovim 0.11+ LSP config API
-- Register server configs
vim.lsp.config("pyright", {
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
      },
    },
  },
})

-- Enable server
vim.lsp.enable("pyright")

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    local map = vim.keymap.set
    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", vim.lsp.buf.references, opts)
    map("n", "K", vim.lsp.buf.hover, opts)
    map("n", "<leader>rn", vim.lsp.buf.rename, opts)
    map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end,
})
