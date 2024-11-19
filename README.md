# Partshell

Partshell is a Vim plugin that adds helper commands for working with shell commands in Vim. For example, `:GrepSh` is an easy way to use any `grep` program, the same way Vim's builtin `:grep` command works. For example, `:Grepsh rg --vimgrep foo` will use [`ripgrep`](https://github.com/BurntSushi/ripgrep).

One advantage of this approach it's flexibility. For example, [`pbpaste`](https://ss64.com/mac/pbpaste.html) on macOS outputs the clipboard contents, so with `:Grepsh pbpaste` Vim will parse `grep` output from the clipboard.

Adding a bang (`!`), does the same behavior as the equivalent Vim built-in command (when the internal command supports one). For example, `:Grepsh!` won't automatically jump to the first match, just like `:grep!`.

All the command also support the shortest version of the matching command in Vim, e.g., `:grep` is defined as `:gr[ep]`, so `:Grepsh` also supports `:Grsh`, in documentation this is illustrated by listing the command as `:Gr[ep]sh`.

## `:Ar[gs]sh[!]`

Wrapper around `:args`.

Populates the argument list with the result of a shell command. Each line is interpreted as a path to a file (a NULL byte terminates input).

### Example

`:Argssh fd partshell` uses [`fd`](https://github.com/sharkdp/fd) to populate the argument list with all the files with `partshell` in the name (recursively from the current directory, because the way `fd` works by default).

#### Built-In Alternative

<p><code>args `fd partshell`</code> (but this won't handle matches with spaces in their filenames properly).</p>

## Grep

### `:Gr[ep]sh[!]`

Run the builtin `:grep` command using the arguments as `grepprg`. This populates the quickfix list with the matching lines using `grepformat`. With a bang (`!`), it doesn't automatically jump to the first match.

#### Example

`:Grepsh rg --vimgrep partshell` uses [ripgrep](https://github.com/BurntSushi/ripgrep) to populate the quickfix list with all the lines that contain `partshell` (recursively from the current directory, because the way `rg` works by default).

#### Built-In Alternative

`:set grepprg=rg\ --vimgrep | grep partshell` but that has the side effect of setting `grepprg` (which might be desirable! Setting `grepprg` to `rg` is a great alternative if the built-in `:grep` behavior isn't useful).

`:cexpr system('rg --vimgrep partshell')` will also likely work, although technically this uses `errorformat` instead of `grepformat` to parse matching lines (note that `%`, which can usually be used on the command line to reference the current file, will not work in this context).

### `:Lgr[ep]sh[!]`

The same as `:Grepsh` but populate the location list instead.

## Make

### `:Mak[e]sh[!]`

Run the builtin `:make` command using the arguments as `makeprg`. This populates the quickfix list with the lines with errors using `errorformat`. With a bang (`!`), it doesn't automatically jump to the first match.

#### Example

`:MakeSh clang %` compiles the current file with `clang`.

#### Built-In Alternative

`:set makeprg=clang\ % | make')` does not set `makeprg`.

`:cexpr system('clang hello_world.c')` will also work (although `%` to reference the current file will not work in this context).

### `:Lmak[e]sh[!]`

## New Window

Commands that create a new window.

### Example

`:Newsh git diff` to create a new diff buffer containing the output of `git diff`.

### Built-In Alternative

`:new | r !git diff` but this adds an extra new line at the top and bottom of the output, and doesn't detect the file type. To solve these issues `:new | 0r !git diff ^J norm Gddgg | filetype detect` should work but doesn't seem to in practice (`^J` means do `CTRL-V_CTRL-J` which is the command separator to use after a `:!` to perform a another Vim command instead of piping to a shell command).

### `:Ene[w]sh[!]`

Open a new buffer with a shell command in the current window (like `:enew` this will fail unless unless `'hidden'` is set or `'autowriteall'` is set and the file can be written).

### `:Newsh[!]`

Open a new buffer with a shell command replacing the existing buffer.

### `:Tabnewsh[!]`, `:Tabe[dit]sh[!]`

### `:Vne[w]sh[!]`


With a bang use the existing buffer

## `:P`

The special `:P` (for partial) command.

- `:P !` example
- The `:P` command started as a  `B` the [vis](https://www.vim.org/scripts/script.php?script_id=1195).
