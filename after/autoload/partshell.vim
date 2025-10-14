function! partshell#Part(bang, cmd, split) range abort
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

function! partshell#EditSh(bang, cmd, edit) abort
  "let l:result = systemlist(a:cmd)
  "if v:shell_error != 0
  "  echom "Non-zero exit status running ".a:cmd
  "  return
  "endif
  " This temptfile based approach is hack-y but being able to see the shell
  " output makes it easier to diagnose errors and unexpected results
  let l:tmpfile = tempname()
  execute '!' . a:cmd . ' | tee ' . l:tmpfile
  if !filereadable(l:tmpfile)
    return
  endif
  let l:result = readfile(l:tmpfile)
  call delete(l:tmpfile)
  if empty(l:result)
    "echom "No results found running ".a:cmd
    return
  endif
  let l:escaped_files = map(l:result, {_, v -> fnameescape(v)})
  let l:args_list = join(l:escaped_files, ' ')
  execute a:edit.(a:bang ? '!':'').' '.l:args_list
endfunction

function! partshell#GrepSh(bang, cmd, location)
  if exists('*getcmdwintype') && !empty(getcmdwintype())
    echom "Not valid in command-line window"
    return
  endif
  let l:original_grepprg = &grepprg
  " The default way of running shell commands using `!` allows the use of `|`
  " to pipe unescaped, so reproduce that behavior here.
  let &grepprg=escape(a:cmd, '|')
  if a:location
    execute 'lgrep'.(a:bang ? '!':'')
  else
    execute 'grep'.(a:bang ? '!':'')
  endif
  let &grepprg = l:original_grepprg
endfunction

function! partshell#MakeSh(bang, cmd, location)
  if exists('*getcmdwintype') && !empty(getcmdwintype())
    echom "Not valid in command-line window"
    return
  endif
  let l:original_makeprg = &makeprg
  " The default way of running shell commands using `!` allows the use of `|`
  " to pipe unescaped, so reproduce that behavior here.
  let &makeprg = escape(a:cmd, '|')
  if a:location
    execute "lmake".(a:bang ? '!':'')
  else
    execute "make".(a:bang ? '!':'')
  endif
  let &makeprg = l:original_makeprg
endfunction

function! partshell#Sh(bang, cmd, split) abort
  if exists('*getcmdwintype') && !empty(getcmdwintype())
    echom "Not valid in command-line window"
    return
  endif

  " `system(a:cmd)` does not support `%` for the current file, so instead we
  " use `execute 'silent! 0r !'.l:cmd` below which supports `%`, but since
  " it's a new window, we need to reference the previous file
  " let l:result = system(a:cmd)
  " Use previous file for inline ` % `, and ending `%$`
  let l:cmd = substitute(a:cmd, '\s%\(\s\|$\)', ' #\1', '')
  let l:basename = fnameescape(a:cmd)

  if !a:bang || bufwinnr(l:basename) < 0
    execute a:split
  endif
  " Reset undo for this buffer
  let l:oldundolevels=&undolevels
  setlocal undolevels=-1
  let l:bufnr = bufnr(l:basename)
  if a:bang && l:bufnr > 0
    execute 'buffer '.l:bufnr
    enew
    bd#
  endif
  execute 'silent! 0r !'.l:cmd
  norm Gddgg
  filetype detect
  " Do naming after file type detect, this allows `ftplugin` to check
  " `eval('@%')` to see if this buffer is backed by a file before adding a
  " name
  for l:i in range(1, 9)
    " Wrap `file` in a try-catch to suppress errors if the name already exists
    " (The buffer will continue to show up as `[No Name]`)
    try
      execute 'silent file '.l:basename.(i > 1 ? ' '.l:i : '')
      silent file
      break
    catch
    endtry
  endfor
  let &l:undolevels=l:oldundolevels
endfunction
