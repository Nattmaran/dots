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

usermod.loadLombokSupport = function()
  local JAVA_TOOL_OPTIONS="-javaagent:$HOME/.m2/repository/org/projectlombok/lombok/1.18.20/lombok-1.18.20.jar"
  vim.cmd('!export JAVA_TOOL_OPTIONS=' .. JAVA_TOOL_OPTIONS)
end


usermod.openDapScopes = function()
  local widgets = require('dap.ui.widgets')
  local my_sidebar = widgets.sidebar(widgets.scopes)
  my_sidebar.open()
end

usermod.openDapFrames = function()
  local widgets = require('dap.ui.widgets')
  local my_sidebar = widgets.sidebar(widgets.frames)
  my_sidebar.open()
end

usermod.floatDapScopes = function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end

usermod.hoverDapExpression = function()
  require('dap.ui.widgets').hover()
end


return usermod
