local actions = require "telescope.actions"

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--ignore-file',
      '~/.ignore' -- .ignore に含まれいるものを検索対象隊から除外できる
    },
    dynamic_preview_title = true,
    layout_strategy = "vertical",
    layout_config = {
      mirror = true,
      prompt_position = "top",
      width = 0.95,
      height = 0.99,
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      }
    }
  },
  pickers = {
    buffers = {
      sort_lastused = true,
      ignore_current_buffer = true,
      mappings = {
        -- insert
        i = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        },
        -- normal
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        }
      },
    },
  },
}
