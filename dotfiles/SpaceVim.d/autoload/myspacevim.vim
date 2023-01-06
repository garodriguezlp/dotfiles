function! myspacevim#before() abort

  " enables autosaving
  set autowrite
  autocmd InsertLeave,TextChanged,FocusLost,BufLeave * silent! update

endfunction

function! myspacevim#after() abort

  " enables the use of the system clipboard
  set clipboard+=unnamed

  " enable copilot for git commit messages
  let g:copilot_filetypes = {
        \ 'gitcommit': v:true,
        \ }

  " enables displaying hidden characters
  setlocal list

endfunction
