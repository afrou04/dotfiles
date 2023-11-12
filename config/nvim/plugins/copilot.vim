let g:copilot_filetypes = #{
  \   gitcommit: v:true,
  \   markdown: v:true,
  \   text: v:true,
  \   ddu-ff-filter: v:false,
  \ }

" コミットメッセージにdiffを追加しcopilotに食べさせる
function! s:append_diff() abort
  " Get the Git repository root directory
  let git_dir = getcwd()

  " Get the diff of the staged changes relative to the Git repository root
  " Add a comment character to each line of the diff
  let diff = system('git -C ' . git_dir . ' diff --cached')
  let split_diff = join(map(split(diff, '\n'), {idx, line -> '# ' . line}), "\n")

  " Get a git log message
  let recent_log_messages = system('git -C ' . git_dir . ' log --oneline -n 20')
  let split_log_messages = join(map(split(recent_log_messages, '\n'), {idx, line -> '# ' . line}), "\n")

  " Append the diff to the commit message
  call append(line('$'), split(split_diff, '\n'))
  call append(line('$'), split(split_log_messages, '\n'))
endfunction

augroup EditCommitMessageCmd
  autocmd!
  autocmd BufNewFile,BufReadPost COMMIT_EDITMSG call s:append_diff()
augroup END
