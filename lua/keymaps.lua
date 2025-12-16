local map = vim.keymap.set

-- Basic
map("n", "<leader>w", "<cmd>w<cr>")
map("n", "<leader>q", "<cmd>q<cr>")

-- Splits
map("n", "<leader>sv", "<cmd>vsplit<cr>")
map("n", "<leader>sh", "<cmd>split<cr>")

-- Window move (Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Resize (Alt + hjkl)
map("n", "<A-h>", "<cmd>vertical resize -5<cr>")
map("n", "<A-l>", "<cmd>vertical resize +5<cr>")
map("n", "<A-j>", "<cmd>resize -2<cr>")
map("n", "<A-k>", "<cmd>resize +2<cr>")

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>")

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float)
map("n", "[d", vim.diagnostic.goto_prev)
map("n", "]d", vim.diagnostic.goto_next)

-- NERDTree
map("n", "<leader>n", "<cmd>NERDTreeToggle<cr>")
map("n", "<leader>nf", "<cmd>NERDTreeFind<cr>")

-- Run current Python file with uv (assumes project has uv + .venv)
map("n", "<leader>rr", function()
  local file = vim.fn.expand("%:p")
  vim.cmd("botright split term://uv run python " .. vim.fn.fnameescape(file))
end)

-- Run with stdin from input.txt (algorithm style)
map("n", "<leader>ri", function()
  local file = vim.fn.expand("%:p")
  vim.cmd("botright split term://bash -lc 'uv run python " .. file .. " < input.txt'")
end)

-- Run multi cases with diff (cases/in/*.txt + cases/out/*.txt)
map("n", "<leader>rc", function()
  local file = vim.fn.expand("%:p")
  vim.cmd("botright split term://bash -lc './scripts/run_cases.sh " .. file .. "'")
end)

-- Insert algorithm template into empty file
local algo_template = [[
import sys
from typing import *
input = sys.stdin.readline

def solve():
    # TODO
    pass

if __name__ == "__main__":
    solve()
]]

map("n", "<leader>at", function()
  if vim.fn.line("$") == 1 and vim.fn.getline(1) == "" then
    vim.api.nvim_put(vim.split(algo_template, "\n"), "l", true, true)
    vim.cmd("normal! gg")
  end
end)

-- FastAPI run (expects main.py with app)
map("n", "<leader>fa", function()
  vim.cmd("botright split term://uvicorn main:app --reload")
end)

-- Theme switcher
map("n", "<leader>tc", function() vim.cmd.colorscheme("cyberdream") end)
map("n", "<leader>tt", function() vim.cmd.colorscheme("tokyonight-storm") end)
map("n", "<leader>to", function() vim.cmd.colorscheme("oxocarbon") end)
map("n", "<leader>tm", function() vim.cmd.colorscheme("catppuccin-mocha") end)

-- DAP keymaps (safe require)
local function safe_require(mod)
  local ok, m = pcall(require, mod)
  return ok and m or nil
end

map("n", "<leader>dc", function()
  local dap = safe_require("dap"); if dap then dap.continue() end
end)

map("n", "<leader>db", function()
  local dap = safe_require("dap"); if dap then dap.toggle_breakpoint() end
end)

map("n", "<leader>dB", function()
  local dap = safe_require("dap")
  if dap then dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end
end)

map("n", "<leader>do", function()
  local dap = safe_require("dap"); if dap then dap.step_over() end
end)

map("n", "<leader>di", function()
  local dap = safe_require("dap"); if dap then dap.step_into() end
end)

map("n", "<leader>dO", function()
  local dap = safe_require("dap"); if dap then dap.step_out() end
end)

map("n", "<leader>dq", function()
  local dap = safe_require("dap"); if dap then dap.terminate() end
end)

map("n", "<leader>dr", function()
  local dap = safe_require("dap"); if dap then dap.restart() end
end)

map("n", "<leader>du", function()
  local dapui = safe_require("dapui"); if dapui then dapui.toggle() end
end)

map("n", "<leader>dp", function()
  local dap = safe_require("dap"); if dap then dap.repl.open() end
end)

map({ "n", "v" }, "<leader>dh", function()
  local widgets = safe_require("dap.ui.widgets"); if widgets then widgets.hover() end
end)

map("n", "<leader>ds", function()
  local widgets = safe_require("dap.ui.widgets")
  if widgets then widgets.centered_float(widgets.scopes) end
end)

