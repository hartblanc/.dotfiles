local util = require('lspconfig.util')

return {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        typeCheckingMode = 'standard',
        verboseOutput = true,
        logLevel = 'Trace',
        extraPaths = {
          'plz_out/gen',
          'plz-out/python/venv',
        },
      },
    },
  },
  on_new_config = function(config, root_dir)
    if util.root_pattern('.plzconfig')(root_dir) then
      config.settings = vim.tbl_deep_extend('force', config.settings, {
        python = {
          analysis = {
            extraPaths = {
              vim.fs.joinpath(root_dir, 'plz-out/python/venv'),
            },
            exclude = { 'plz-out' },
          },
        },
      })
    end
  end,
  root_dir = function(fname)
    return util.root_pattern('.plzconfig', 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', 'pyrightconfig.json', '.git')(fname) or vim.fn.getcwd()
  end,
}
