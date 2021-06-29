" base settings
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }
let $FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
let g:fzf_command_prefix = 'Fzf'

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   "rg --ignore-file ~/.ignore --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1,
  \   fzf#vim#with_preview({'options': '--exact --delimiter : --nth 3..'}), <bang>0)

command! -bang -nargs=* FzfGGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

function! s:fzfFiles()
  let is_git = system('git status')
  if v:shell_error
    :FzfFiles
  else
    :FzfGFiles --cached --others --exclude-standard
  endif
endfunction

" keymap settings
nnoremap <silent><C-p> :call <SID>fzfFiles()<CR>
nnoremap <silent><S-p> :FzfBuffers<CR>
nnoremap <S-f> :Rg<CR>
nmap <silent><leader>ii  :e ~/.ignore<CR>

