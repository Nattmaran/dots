local usermod = {}
local f = vim.fn

usermod.makeJavaTest = function()
  local m = f.fnamemodify
  local srcfile = f.expand("%")
  local dirname = m(srcfile, ':h:s?main?test?')
  local filename = m(srcfile, ':.:s?main?test?:s?\\.java?Test\\.java?')
  vim.cmd('silent !mkdir -p ' .. dirname)
  vim.cmd('e ' .. filename)
end

return usermod
