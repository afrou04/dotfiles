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
  let diff = system('git -C ' . git_dir . ' diff --cached')

  " Add a comment character to each line of the diff
  let comment_diff = join(map(split(diff, '\n'), {idx, line -> '# ' . line}), "\n")

  " Append the diff to the commit message
  call append(line('$'), split(comment_diff, '\n'))
endfunction

augroup EditCommitMessageCmd
  autocmd!
  autocmd BufNewFile,BufReadPost COMMIT_EDITMSG call s:append_diff()
augroup END
