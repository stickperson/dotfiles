local M = {}

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local navic = require("nvim-navic")

      if client.server_capabilities.documentSymbolProvider then
        navic.attach(client, buffer)
      end

      on_attach(client, buffer)
    end,
  })
end

return M
