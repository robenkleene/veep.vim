function! veep#Part(bang, cmd, split) range abort
  if a:firstline == 0 && a:lastline == 0
    echoerr "Warning: No range provided for P command."
    return
  endif
  let l:save = @@

  execute 'silent noautocmd keepjumps normal! gv'
  let l:mode = mode(1)
  execute 'silent noautocmd keepjumps normal! y'
  if empty(a:split)
    new
  else
    execute a:split
  endif
  let l:oldundolevels = &undolevels
  setlocal undolevels=-1

  setlocal buftype=nofile bufhidden=hide noswapfile
  execute 'silent noautocmd keepjumps normal! Vp'

  " `system(a:cmd)` does not support `%` for the current file, so instead we
  " use `execute 'silent! 0r !'.l:cmd` below which supports `%`, but since
  " it's a new window, we need to reference the previous file
  " let l:result = system(a:cmd)
  " Use previous file for inline ` % `, and ending `%$`
  if !empty(a:cmd)
    let l:cmd = substitute(a:cmd, '\s%\(\s\|$\)', ' #\1', '')
    let l:success = 1
    try
      if a:bang
        execute 'silent noautocmd keepjumps '.l:cmd
      else
        execute 'silent noautocmd keepjumps 0,$'.l:cmd
      endif
    catch
      let l:success = 0
      echoerr v:exception
    endtry
  endif

  if empty(a:split)
    if l:success
      if l:mode == 'v'
        execute 'silent noautocmd keepjumps normal! ggvGg_y'
      elseif l:mode == 'V'
        execute 'silent noautocmd keepjumps normal! ggVGy'
      elseif l:mode == "\<C-V>"
        " Use `^V ^V` to insert the `^V` for the blockwise selection
        execute 'silent noautocmd keepjumps normal! ggG$y'
      endif
      bd!
      execute 'silent noautocmd keepjumps normal! gvp'
    else
      bd!
    endif
  else
    " If a new split is created, goto first line
    norm gg
  endif

  let &l:undolevels = l:oldundolevels
  let @@ = l:save
endfunction
