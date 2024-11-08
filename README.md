# Partshell

Partshell is a Vim plugin that provides helper commands for working with shell commands. For example, `:Shgrep` is an easy way to use any `grep` program, for example `:Shgrep rg foo` will use [`ripgrep`](https://github.com/BurntSushi/ripgrep).

One advantage of this approach is it means it's flexible, for example [`pbpaste`](https://ss64.com/mac/pbpaste.html) on macOS outputs the clipboard contents, so with `:Shgrep pbpaste` or `:Shmake pbpaste` Vim will parse `grep` or compile output respectively, allowing jumping directly to lines with matches or errors.

## `Shar[gs][!]`

Populates the argument list with the result of a shell command. Each line is interpreted as a path to a file. A NULL byte terminates input.

### Example

`Shargs fd partshell` uses [`fd`](https://github.com/sharkdp/fd) to populate the argument list with all the files with `partshell` in the name recursively from the current directory.

### Closest Built-In Command

<p><code>args `fd partshell`</code> (but this won't handle matches with spaces in their names properly).</p>

## `Shgr[ep][!]`

## `Shmak[e][!]`

## `Shlmak[e][!]`

## `Shlgr[ep][!]`

## `Shnew[!]`, `Shvne[w][!]`, `Shtabnew[!]`, `Shne[w][!]`

With a bang use the existing buffer

## `P`

- `P !` example
- The `P` command started as a  `B` the [vis](https://www.vim.org/scripts/script.php?script_id=1195).



