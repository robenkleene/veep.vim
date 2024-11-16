# Partshell

Partshell is a Vim plugin that adds helper commands for working with shell commands in Vim. For example, `:GrepSh` is an easy way to use any `grep` program, the same way Vim's builtin `:grep` command works. For example, `:GrepSh rg --vimgrep foo` will use [`ripgrep`](https://github.com/BurntSushi/ripgrep).

One advantage of this approach it's flexibility. For example, [`pbpaste`](https://ss64.com/mac/pbpaste.html) on macOS outputs the clipboard contents, so with `:GrepSh pbpaste` Vim will parse `grep` output from the clipboard.

Each command also has a shorthand, the shorthand for `:GrepSh` is `:Gsh`.

Adding a bang (`!`), does the same behavior as the equivalent Vim built-in command (when the internal command supports one). For example, `:GrepSh!` won't automatically jump to the first match, just like `:grep!`.

## `:ArgsSh[!]`, `:Ash[!]`

Wrapper around `:args`.

Populates the argument list with the result of a shell command. Each line is interpreted as a path to a file (a NULL byte terminates input).

### Example

`:ArgsSh fd partshell` uses [`fd`](https://github.com/sharkdp/fd) to populate the argument list with all the files with `partshell` in the name (recursively from the current directory, because the way `fd` works by default).

### Closest Built-In Command

<p><code>args `fd partshell`</code> (but this won't handle matches with spaces in their filenames properly).</p>

## Grep

### `:GrepSh[!]`, `:Gsh[!]`

Run the builtin `:grep` command using the arguments as `grepprg`. This populates the quickfix list with the matching lines using `grepformat`. With a bang (`!`), it doesn't automatically jump to the first match.

#### Example

`:GrepSh rg --vimgrep partshell` uses [ripgrep](https://github.com/BurntSushi/ripgrep) to populate the quickfix list with all the lines that contain `partshell` (recursively from the current directory, because the way `rg` works by default).

### Closest Built-In Command

`:set grepprg=rg\ --vimgrep | grep partshell` but that has the side effect of setting `grepprg` (which might be desirable! Setting `grepprg` to `rg` is a great alternative if the built-in `:grep` behavior isn't useful).

`:cexpr system('rg --vimgrep partshell')` will also likely work, although technically this uses `errorformat` instead of `grepformat` to parse matching lines.

### `:LgrepSh[!]`, `:LGsh[!]`

The same as `:GrepSh` but populate the location list instead.

## Make

### `:MakeSh[!]`, `:Msh[!]`

Run the builtin `:make` command using the arguments as `makeprg`. This populates the quickfix list with the lines with errors using `errorformat`. With a bang (`!`), it doesn't automatically jump to the first match.

#### Closest Built-In Command

 `:set makeprg=... | make "search_term"` but that has the side effect of setting `makeprg`.

`:cexpr system('')` does not set `makeprg`.

### `:LmakeSh[!]`, `:LMsh[!]`

## New Window

Commands that create a new window.

### `:Enewsh[!]`, `:Esh[!]`

### `:NewSh[!]`, `:Nsh[!]`

### `:TabnewSh[!]`, `:Tsh[!]`

### `:VnewSh[!]`, `:Vsh[!]`

With a bang use the existing buffer

## `:P`

The special `:P` (for partial) command.

- `:P !` example
- The `:P` command started as a  `B` the [vis](https://www.vim.org/scripts/script.php?script_id=1195).



