-- mason: LSP server installer/manager
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

mason.setup()
mason_lspconfig.setup({
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

local function get_python_path(root_dir)
  local function join(p) return vim.fn.resolve(root_dir .. "/" .. p) end
  local venv = join(".venv/bin/python")
  if vim.fn.filereadable(venv) == 1 then
    return venv
  end
  local py3 = vim.fn.exepath("python3")
  if py3 ~= "" then return py3 end
  return "python"
end

-- LSP server setup via mason-lspconfig + lspconfig
local function setup_server(server_name)
  local opts = {
    capabilities = capabilities,
  }

  if server_name == "pyright" then
    opts.settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    }
    opts.before_init = function(_, config)
      config.settings.python.pythonPath = get_python_path(config.root_dir or vim.loop.cwd())
    end
  end

  lspconfig[server_name].setup(opts)
end

if mason_lspconfig.setup_handlers then
  mason_lspconfig.setup_handlers({ setup_server })
else
  for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
    setup_server(server)
  end
end

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
