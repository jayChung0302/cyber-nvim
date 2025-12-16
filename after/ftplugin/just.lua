local setlocal = vim.opt_local
setlocal.ts = 2
setlocal.sts = 2
setlocal.sw = 2
setlocal.expandtab = true

-- treesitter highlight

-- treesitter indent
vim.bo.indentexpr = "nvim_treesitter#indent()"

-- etc.
setlocal.commentstring = '# %s'
