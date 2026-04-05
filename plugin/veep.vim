vnoremap <expr> ! (mode() ==# 'V' ? '!' : ':Psh ')

command! -range -bang -nargs=+ -complete=command P <line1>,<line2>call veep#Part(<bang>0, <q-args>)
command! -range -bang -nargs=+ -complete=shellcmd Psh <line1>,<line2>call veep#Part(<bang>0, '!'.<q-args>)
command! -range -bang -nargs=+ -complete=shellcmd Pex <line1>,<line2>call veep#Part(<bang>0, '!'.<q-args>, '', v:false)
" Splits
command! -range -bang -nargs=* -bang -complete=command Penew <line1>,<line2>call veep#Part(<bang>0, <q-args>, 'enew')
command! -range -bang -nargs=* -bang -complete=command Pnew <line1>,<line2>call veep#Part(<bang>0, <q-args>, 'new')
command! -range -bang -nargs=* -bang -complete=command Ptabnew <line1>,<line2>call veep#Part(<bang>0, <q-args>, 'tabnew')
command! -range -bang -nargs=* -bang -complete=command Ptabedit <line1>,<line2>call veep#Part(<bang>0, <q-args>, 'tabnew')
command! -range -bang -nargs=* -bang -complete=command Pvnew <line1>,<line2>call veep#Part(<bang>0, <q-args>, 'vnew')
