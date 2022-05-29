-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
HOME = os.getenv("HOME")
JAR = HOME.."/dev/jdtls/plugins/org.eclipse.equinox.launcher_1.6.300.v20210813-1054.jar"
CONFIGURATION = HOME.."/dev/jdtls/config_linux"
WORKSPACE = HOME.."/workspace"

JAVA_DEBUG = HOME.."/dev/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.36.0.jar"

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'java', -- or '/path/to/java11_or_newer/bin/java'
            -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xms1g',
    '-Xmx2G',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',

    '-jar', JAR,
         -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
         -- Must point to the
         -- eclipse.jdt.ls installation
    '-configuration', CONFIGURATION,
                    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^
                    -- Must point to the
                    -- eclipse.jdt.ls installation
    -- See `data directory configuration` section in the README
    '-data', vim.fn.getenv('HOME') .. '/workspace/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  },
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew', 'pom.xml'}),

  -- add custom lsp maps
  on_attach = function()
    require'lspmaps'.on_attach()
    require'jdtls'.setup_dap({ hotcodereplace = 'auto' })
  end,
  -- update completion capabilities
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = { }
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {vim.fn.glob(JAVA_DEBUG)}
  },
}
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
