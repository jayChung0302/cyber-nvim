-- mason: LSP server installer/manager
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_util = require("lspconfig.util")

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

-- Global diagnostic display (virtual text + signs)
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

local root_markers = {
  "pyrightconfig.json",
  "pyproject.toml",
  "setup.py",
  "setup.cfg",
  "Pipfile",
  "requirements.txt",
  ".git",
}

local function get_python_path(root_dir)
  root_dir = root_dir or vim.loop.cwd()
  local venv = lsp_util.path.join(root_dir, ".venv", "bin", "python")
  if vim.fn.filereadable(venv) == 1 then
    return venv
  end
  local py3 = vim.fn.exepath("python3")
  if py3 ~= "" then return py3 end
  return "python"
end

local function pyright_cmd()
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver"
  if vim.fn.executable(mason_bin) == 1 then
    return { mason_bin, "--stdio" }
  end
  return { "pyright-langserver", "--stdio" }
end

local function pyright_root_dir(fname)
  return lsp_util.root_pattern(unpack(root_markers))(fname)
    or lsp_util.find_git_ancestor(fname)
    or vim.loop.cwd()
end

-- Neovim 0.11+ LSP config API (avoids deprecated lspconfig setup)
vim.lsp.config("pyright", {
  cmd = pyright_cmd(),
  root_dir = pyright_root_dir,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
      },
    },
  },
  before_init = function(_, config)
    local root = config.root_dir or pyright_root_dir(vim.api.nvim_buf_get_name(0))
    config.settings = config.settings or {}
    config.settings.python = config.settings.python or {}
    config.settings.python.pythonPath = get_python_path(root)
  end,
})

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
