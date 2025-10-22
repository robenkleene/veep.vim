vnoremap <expr> ! (mode() ==# 'V' ? '!' : ':Psh ')

command! -range -bang -nargs=+ -complete=command P <line1>,<line2>call veep#Part(<bang>0, <q-args>, '')
" Doing `'<,'>P !` supports tab completion in Neovim but not in Vim, so this
" helper command allows shell completion in Vim by using `'<,'>Psh`
command! -range -bang -nargs=+ -complete=shellcmd Psh <line1>,<line2>call veep#Part(<bang>0, '!'.<q-args>, '')
" Splits
command! -range -bang -nargs=* -bang -complete=command Penew call veep#Part(<bang>0, <q-args>, 'enew')
command! -range -bang -nargs=* -bang -complete=command Pnew call veep#Part(<bang>0, <q-args>, 'new')
command! -range -bang -nargs=* -bang -complete=command Ptabnew call veep#Part(<bang>0, <q-args>, 'tabnew')
command! -range -bang -nargs=* -bang -complete=command Ptabedit call veep#Part(<bang>0, <q-args>, 'tabnew')
command! -range -bang -nargs=* -bang -complete=command Pvnew call veep#Part(<bang>0, <q-args>, 'vnew')
