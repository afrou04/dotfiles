require("diffview").setup()

-- Dfifviewのtoggleコマンド
vim.api.nvim_create_user_command("Diff", function(e)
  local view = require("diffview.lib").get_current_view()

  if view then
    vim.cmd("DiffviewClose")
    -- cocのserverがエラーになるので再起動
    vim.cmd("CocRestart")
  else
    vim.cmd("DiffviewOpen " .. e.args)
  end
end, { nargs = "*" })

require("diffview").setup({
  show_help_hints = false,   -- Show hints for how to open the help panel
  file_panel = {
    listing_style = "list",             -- One of 'list' or 'tree'
    tree_options = {                    -- Only applies when listing_style is 'tree'
      flatten_dirs = true,              -- Flatten dirs that only contain one single dir
      folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
    },
  },
  file_history_panel = {
    log_options = {   -- See ':h diffview-config-log_options'
      git = {
        single_file = {
          diff_merges = "combined",
        },
        multi_file = {
          diff_merges = "first-parent",
        },
      },
      hg = {
        single_file = {},
        multi_file = {},
      },
    },
    win_config = {    -- See ':h diffview-config-win_config'
      position = "bottom",
      height = 16,
      win_opts = {}
    },
  },
})
