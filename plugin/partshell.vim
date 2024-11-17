command! -range -nargs=* -complete=command P silent <line1>,<line2>call partshell#Part(<q-args>)

" Args
command! -nargs=+ -bang -complete=shellcmd ArgsSh call partshell#EditSh(<bang>0, <q-args>, 'args')
command! -nargs=+ -bang -complete=shellcmd Ash call partshell#EditSh(<bang>0, <q-args>, 'args')

" Grep
command! -nargs=+ -bang -complete=shellcmd GrepSh call partshell#GrepSh(<bang>0, <q-args>, 0)
command! -nargs=+ -bang -complete=shellcmd Gsh call partshell#GrepSh(<bang>0, <q-args>, 0)

command! -nargs=+ -bang -complete=shellcmd LgrepSh call partshell#GrepSh(<bang>0, <q-args>, 1)
command! -nargs=+ -bang -complete=shellcmd LGsh call partshell#GrepSh(<bang>0, <q-args>, 1)

" Make
command! -nargs=+ -bang -complete=shellcmd MakeSh call partshell#MakeSh(<bang>0, <q-args>, 0)
command! -nargs=+ -bang -complete=shellcmd Msh call partshell#MakeSh(<bang>0, <q-args>, 0)

command! -nargs=+ -bang -complete=shellcmd LmakeSh call partshell#MakeSh(<bang>0, <q-args>, 1)
command! -nargs=+ -bang -complete=shellcmd LMsh call partshell#MakeSh(<bang>0, <q-args>, 1)

" Splits
command! -nargs=+ -bang -complete=shellcmd EnewSh call partshell#Sh(<bang>0, <q-args>, 'enew')
command! -nargs=+ -bang -complete=shellcmd Esh call partshell#Sh(<bang>0, <q-args>, 'enew')

command! -nargs=+ -bang -complete=shellcmd NewSh call partshell#Sh(<bang>0, <q-args>, 'new')
command! -nargs=+ -bang -complete=shellcmd Nsh call partshell#Sh(<bang>0, <q-args>, 'new')

command! -nargs=+ -bang -complete=shellcmd TabnewSh call partshell#Sh(<bang>0, <q-args>, 'tabnew')
command! -nargs=+ -bang -complete=shellcmd Tsh call partshell#Sh(<bang>0, <q-args>, 'tabnew')

command! -nargs=+ -bang -complete=shellcmd VnewSh call partshell#Sh(<bang>0, <q-args>, 'vnew')
command! -nargs=+ -bang -complete=shellcmd Vsh call partshell#Sh(<bang>0, <q-args>, 'vnew')
