" 最後に開いたwindowでファイルを開く
let g:nvim_tree_disable_window_picker = 1

" アクティブなファイルにハイライト
let g:nvim_tree_highlight_opened_files = 1

" ファイルを開いた時にtreeを自動的に閉じる
let g:nvim_tree_quit_on_open = 1

let g:nvim_tree_icon_padding = "  "

let g:nvim_tree_show_icons = {
    \ 'git': 0,
    \ 'folders': 1,
    \ 'files': 1,
    \ 'folder_arrows': 0,
    \ }

let g:nvim_tree_icons = {
    \ 'default':        '',
    \ 'symlink':        '',
    \ 'git': {
    \   'unstaged':     "-",
    \   'staged':       "✓",
    \   'unmerged':     "",
    \   'renamed':      "➜",
    \   'untracked':    "★",
    \   'deleted':      "✗",
    \  },
    \ 'folder': {
    \   'arrow_open':   "",
    \   'arrow_closed': "",
    \   'default':      "",
    \   'open':         "",
    \  },
    \  'lsp': {
    \    'hint': "",
    \    'info': "",
    \    'warning': "",
    \    'error': "",
    \  }
    \ }
