function! partshell#Part(...) range abort
  let l:save = @@

  execute 'silent noautocmd keepjumps normal! gv'
  let l:mode = mode(1)
  execute 'silent noautocmd keepjumps normal! y'
  new
  let l:oldundolevels=&undolevels
  setlocal undolevels=-1

  setlocal buftype=nofile bufhidden=hide noswapfile
  execute 'silent noautocmd keepjumps normal! Vp'

  if a:0 >= 1 && !empty(a:1)
    let l:cmd = a:1
    execute 'silent noautocmd keepjumps 0,$'.l:cmd

    if l:mode == 'v'
      execute 'silent noautocmd keepjumps normal! ggvGg_y'
    elseif l:mode == 'V'
      execute 'silent noautocmd keepjumps normal! ggVGy'
    elseif l:mode == "\<C-V>"
      execute 'silent noautocmd keepjumps normal! gg<C-v>G$y'
    endif

    bd!
    execute 'silent noautocmd keepjumps normal! gvp'
  else
    let &l:undolevels=l:oldundolevels
  endif

  let @@ = l:save
endfunction

function! partshell#EditSh(cmd, edit) abort
  let l:result = systemlist(a:cmd)
  if v:shell_error != 0
    echom "Non-zero exit status running ".a:cmd
    return
  endif
  if empty(l:result)
    echom "No results found running ".a:cmd
    return
  endif
  let l:escaped_files = map(l:result, {_, v -> fnameescape(v)})
  let l:args_list = join(l:escaped_files, ' ')
  execute a:edit . ' ' . l:args_list
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
  let l:cmd = substitute(a:cmd, '\s%$', ' #', '')
  let l:basename = fnameescape(a:cmd)
  " Neither approach supports `DiffSh git diff %` well, but this one at
  " least allows `DiffSh git diff #`
  " let l:result = system(a:cmd)
  " new
  " put =l:result
  " This could be either `enew` or `new`, `:tag` works like `enew` and `:h`
  " and `:Man` work like `new`
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
  execute 'silent! 0r !'.l:cmd
  norm Gddgg
  let &l:undolevels=l:oldundolevels
  filetype detect
endfunction
