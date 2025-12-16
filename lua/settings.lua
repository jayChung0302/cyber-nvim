vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 200
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Cyber feel / ergonomics
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "88"
vim.opt.guicursor = ""

-- uv / .venv python auto-detect (project root)
local function get_python_path()
  local venv = vim.fn.getcwd() .. "/.venv/bin/python"
  if vim.fn.filereadable(venv) == 1 then
    return venv
  end
  local py3 = vim.fn.exepath("python3")
  if py3 ~= "" then return py3 end
  return "python"
end

vim.g.python3_host_prog = get_python_path()

-- DAP breakpoint sign (make it obvious)
vim.fn.sign_define("DapBreakpoint", { text = "🟥", texthl = "", linehl = "", numhl = "" })

