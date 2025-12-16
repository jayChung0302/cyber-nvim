-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Themes
  { "scottmckendry/cyberdream.nvim", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },

  -- Dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        config = {
          header = {
            "",
            " ███╗   ██╗██╗   ██╗██╗███╗   ███╗",
            " ████╗  ██║██║   ██║██║████╗ ████║",
            " ██╔██╗ ██║██║   ██║██║██╔████╔██║",
            " ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║",
            " ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║",
            " ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝         ",
            "",
            "   ░ CYBER NEOVIM ░",
            "",
          },
          shortcut = {
            { desc = "󰈞  Find File",   group = "Label", action = "Telescope find_files", key = "f" },
            { desc = "󰊄  Live Grep",   group = "Label", action = "Telescope live_grep",  key = "g" },
            { desc = "󰋚  Recent Files", group = "Label", action = "Telescope oldfiles",   key = "r" },
            { desc = "  New Python",  group = "Label", action = "enew | set ft=python", key = "a" },
            { desc = "  Quit",        group = "Label", action = "qa",                   key = "q" },
          },
          footer = { "", "⚡ uv + FastAPI + PyTorch + DAP ⚡" },
        },
      })
    end,
  },

  -- Treesitter
  {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = { "lua", "python", "bash", "json", "yaml", "markdown" },
    auto_install = false,
    highlight = { enable = true },
    indent = { enable = true },
  },
},


  -- Telescope
  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- NERDTree
  { "preservim/nerdtree" },

  -- LSP / Mason
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },

  -- Completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },

  -- Formatting (isort -> black)
  { "stevearc/conform.nvim", config = function()
      require("conform").setup({
        formatters_by_ft = {
          python = { "isort", "black" },
        },
        format_on_save = {
          timeout_ms = 1000,
          lsp_fallback = false,
        },
      })
    end
  },

  -- DAP
  { "mfussenegger/nvim-dap" },
  { "mfussenegger/nvim-dap-python", dependencies = { "mfussenegger/nvim-dap" }, config = function()
      require("dap-python").setup(vim.g.python3_host_prog)

      local dap = require("dap")
      dap.configurations.python = dap.configurations.python or {}
      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Debug current file",
        program = "${file}",
        pythonPath = vim.g.python3_host_prog,
        justMyCode = false,
      })
    end
  },

  -- DAP UI + virtual text
  { 
  "rcarriga/nvim-dap-ui",
  dependencies = { 
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio", -- ✅ 추가
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup()

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
  end
},

  { "theHamsta/nvim-dap-virtual-text", dependencies = { "mfussenegger/nvim-dap" }, config = function()
      require("nvim-dap-virtual-text").setup()
    end
  },
})

-- Default theme
vim.cmd.colorscheme("cyberdream")

