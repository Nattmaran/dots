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

usermod.loadLsp = function()
  require('jdtls').start_or_attach({
    cmd = {'jdtls', vim.fn.getenv('HOME') .. '/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')},
    root_dir = require('jdtls.setup').find_root({'gradle.build', 'pom.xml'}),
    on_attach = function()
      require'lspmaps'.on_attach()
    end,
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  })
end

return usermod
