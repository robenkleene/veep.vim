command! -range -nargs=* -complete=command P silent <line1>,<line2>call partshell#Part(<q-args>)

" Args
command! -nargs=+ -bang -complete=shellcmd Argssh call partshell#EditSh(<bang>0, <q-args>, 'args')
command! -nargs=+ -bang -complete=shellcmd Arsh call partshell#EditSh(<bang>0, <q-args>, 'args')

" Grep
command! -nargs=+ -bang -complete=shellcmd Grepsh call partshell#GrepSh(<bang>0, <q-args>, 0)
command! -nargs=+ -bang -complete=shellcmd Grsh call partshell#GrepSh(<bang>0, <q-args>, 0)

command! -nargs=+ -bang -complete=shellcmd Lgrepsh call partshell#GrepSh(<bang>0, <q-args>, 1)
command! -nargs=+ -bang -complete=shellcmd Lgrsh call partshell#GrepSh(<bang>0, <q-args>, 1)

" Make
command! -nargs=+ -bang -complete=shellcmd Makesh call partshell#MakeSh(<bang>0, <q-args>, 0)
command! -nargs=+ -bang -complete=shellcmd Maksh call partshell#MakeSh(<bang>0, <q-args>, 0)

command! -nargs=+ -bang -complete=shellcmd Lmakesh call partshell#MakeSh(<bang>0, <q-args>, 1)
command! -nargs=+ -bang -complete=shellcmd Lmaksh call partshell#MakeSh(<bang>0, <q-args>, 1)

" Splits
command! -nargs=+ -bang -complete=shellcmd Enewsh call partshell#Sh(<bang>0, <q-args>, 'enew')
command! -nargs=+ -bang -complete=shellcmd Enesh call partshell#Sh(<bang>0, <q-args>, 'enew')

command! -nargs=+ -bang -complete=shellcmd Newsh call partshell#Sh(<bang>0, <q-args>, 'new')

command! -nargs=+ -bang -complete=shellcmd Tabnewsh call partshell#Sh(<bang>0, <q-args>, 'tabnew')
command! -nargs=+ -bang -complete=shellcmd Tabeditsh call partshell#Sh(<bang>0, <q-args>, 'tabnew')
command! -nargs=+ -bang -complete=shellcmd Tabesh call partshell#Sh(<bang>0, <q-args>, 'tabnew')

command! -nargs=+ -bang -complete=shellcmd Vnewsh call partshell#Sh(<bang>0, <q-args>, 'vnew')
command! -nargs=+ -bang -complete=shellcmd Vnesh call partshell#Sh(<bang>0, <q-args>, 'vnew')
