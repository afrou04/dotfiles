-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  api.config.mappings.default_on_attach(bufnr)
  vim.keymap.del('n', '<C-e>', { buffer = bufnr })
end

require("nvim-tree").setup({
  on_attach = my_on_attach,
  view = {
    width = 35,
  },
  filters = {
    git_ignored = false,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = true,
        picker = "default",
        chars = "1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
})

