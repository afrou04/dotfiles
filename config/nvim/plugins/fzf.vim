" base settings
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.9 } }

command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, {'options': ['--layout=reverse', '--info=inline', '--preview']}, <bang>0)

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

function! s:fzfFiles()
  let is_git = system('git status')
  if v:shell_error
    :Files
  else
    :GFiles
  endif
endfunction

" keymap settings
nnoremap <silent><C-p> :call <SID>fzfFiles()<CR>
nnoremap <S-f> :GGrep<Space>

