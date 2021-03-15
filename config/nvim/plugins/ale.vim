let g:ale_sign_column_always = 1
let g:ale_open_list = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_statusline_format = ['⤫ %d',' ⚠ %d', '⬥ ok']
let g:ale_sign_error = '⤫'
let g:ale_sign_warning = '⚠'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_fix_on_save = 1
let g:ale_hover_to_floating_preview = 1
let g:ale_floating_preview = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_fixers = {
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'json': ['prettier'],
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\}


let g:ale_linters = {
  \ 'c': ['clang'],
  \ 'c++': ['clang'],
  \ 'go': ['golangci-lint'],
  \ 'php': ['php'],
  \ 'perl': ['perl'],
  \ 'ruby': ['ruby', 'rubocop'],
  \ 'python': ['flake8'],
  \ 'javascript': ['eslint'],
  \ 'typescript': ['eslint'],
  \ 'Terraform': ['tflint']
\ }
let g:ale_ruby_rubocop_executable = 'bundle'

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear

hi ALEErrorSign ctermbg=green ctermfg=red guibg=green guifg=red
hi ALEWarningSign ctermbg=blue ctermfg=yellow

nnoremap <C-f> :ALEFix<cr>
