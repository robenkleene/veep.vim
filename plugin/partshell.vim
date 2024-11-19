command! -range -nargs=* -complete=command P silent <line1>,<line2>call partshell#Part(<q-args>)

" Args
command! -nargs=+ -bang -complete=shellcmd ArgsSh call partshell#EditSh(<bang>0, <q-args>, 'args')
command! -nargs=+ -bang -complete=shellcmd ArSh call partshell#EditSh(<bang>0, <q-args>, 'args')

" Grep
command! -nargs=+ -bang -complete=shellcmd GrepSh call partshell#GrepSh(<bang>0, <q-args>, 0)
command! -nargs=+ -bang -complete=shellcmd GrSh call partshell#GrepSh(<bang>0, <q-args>, 0)

command! -nargs=+ -bang -complete=shellcmd LgrepSh call partshell#GrepSh(<bang>0, <q-args>, 1)
command! -nargs=+ -bang -complete=shellcmd LgrSh call partshell#GrepSh(<bang>0, <q-args>, 1)

" Make
command! -nargs=+ -bang -complete=shellcmd MakeSh call partshell#MakeSh(<bang>0, <q-args>, 0)
command! -nargs=+ -bang -complete=shellcmd MakSh call partshell#MakeSh(<bang>0, <q-args>, 0)

command! -nargs=+ -bang -complete=shellcmd LmakeSh call partshell#MakeSh(<bang>0, <q-args>, 1)
command! -nargs=+ -bang -complete=shellcmd LmakSh call partshell#MakeSh(<bang>0, <q-args>, 1)

" Splits
command! -nargs=+ -bang -complete=shellcmd EnewSh call partshell#Sh(<bang>0, <q-args>, 'enew')
command! -nargs=+ -bang -complete=shellcmd EneSh call partshell#Sh(<bang>0, <q-args>, 'enew')

command! -nargs=+ -bang -complete=shellcmd NewSh call partshell#Sh(<bang>0, <q-args>, 'new')

command! -nargs=+ -bang -complete=shellcmd TabnewSh call partshell#Sh(<bang>0, <q-args>, 'tabnew')
command! -nargs=+ -bang -complete=shellcmd TabeditSh call partshell#Sh(<bang>0, <q-args>, 'tabnew')
command! -nargs=+ -bang -complete=shellcmd TabeSh call partshell#Sh(<bang>0, <q-args>, 'tabnew')

command! -nargs=+ -bang -complete=shellcmd VnewSh call partshell#Sh(<bang>0, <q-args>, 'vnew')
command! -nargs=+ -bang -complete=shellcmd VneSh call partshell#Sh(<bang>0, <q-args>, 'vnew')
