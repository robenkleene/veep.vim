function! veep#Part(bang, cmd, split = '', range = v:true) range abort
  if a:firstline == 0 && a:lastline == 0
    echohl ErrorMsg | echomsg "Warning: No range provided for P command." | echohl None
    return
  endif
  let l:save = @@

  silent noautocmd keepjumps normal! gv
  let l:mode = mode(1)
  silent noautocmd keepjumps normal! y
  " Use `tabnew`/`tabclose!` instead of `new`/`close!` so splits in the
  " original tab are not disturbed. Without this, opening a help split
  " (`:h expand()`) then running `:'<,'>P s/foo/bar` causes the help
  " window to resize.
  if empty(a:split)
    noautocmd tabnew
  else
    execute a:split
  endif
  let l:oldundolevels = &undolevels
  setlocal undolevels=-1

  setlocal buftype=nofile bufhidden=hide noswapfile
  silent noautocmd keepjumps normal! Vp

  if !empty(a:cmd)
    " Support `%` and `#`
    let l:cmd = expandcmd(a:cmd)
    let l:success = 1
    try
      if a:range
        execute 'silent noautocmd keepjumps 0,$'.l:cmd
      else
        execute 'silent noautocmd keepjumps '.l:cmd
      endif
    catch
      let l:success = 0
      echoerr v:exception
    endtry
  endif

  if empty(a:split)
    if l:success
      if l:mode == 'v'
        silent noautocmd keepjumps normal! ggvGg_y
      elseif l:mode == 'V'
        silent noautocmd keepjumps normal! ggVGy
      elseif l:mode == "\<C-V>"
        " Use `^V ^V` to insert the `^V` for the blockwise selection
        silent noautocmd keepjumps normal! ggG$y
      endif
      noautocmd tabclose!
      if !a:bang
        silent noautocmd keepjumps normal! gvp
      else
        echo @"
      endif
    else
      noautocmd tabclose!
    endif
  else
    " If a new split is created, goto first line
    norm gg
  endif

  let &l:undolevels = l:oldundolevels
  let @@ = l:save
endfunction
