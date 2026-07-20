local virtual_text_float_config = {
  source = true,
  ---@param diagnostic Diagnostic
  ---@return string
  format = function(diagnostic)
    local source_prefix = string.format('%s: ', diagnostic.source)
    local message = diagnostic.message:gsub('^' .. source_prefix, '')
    return message
  end,
}
vim.diagnostic.config({
  float = virtual_text_float_config,
  virtual_text = virtual_text_float_config,
  source = true,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
    },
  },
})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump({ count = -1, on_jump = vim.diagnostic.open_float })
end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump({ count = 1, on_jump = vim.diagnostic.open_float })
end, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', 'dK', vim.diagnostic.open_float)
