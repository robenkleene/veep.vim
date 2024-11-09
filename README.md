# Partshell

Partshell is a Vim plugin that provides helper commands for working with shell commands. For example, `:GrepSh` is an easy way to use any `grep` program, for example `:GrepSh rg foo` will use [`ripgrep`](https://github.com/BurntSushi/ripgrep).

One advantage of this approach is it means it's flexible, for example [`pbpaste`](https://ss64.com/mac/pbpaste.html) on macOS outputs the clipboard contents, so with `:GrepSh pbpaste` or `:MakeSh pbpaste` Vim will parse `grep` or compile output respectively, allowing jumping directly to lines with matches or errors.

Each command also has a shorthand, for example `Gsh` is the same as `GrepSh`.

## `ArgsSh[!]`, `Ash[!]`

Populates the argument list with the result of a shell command. Each line is interpreted as a path to a file. A NULL byte terminates input.

### Example

`:ArgsSh fd partshell` uses [`fd`](https://github.com/sharkdp/fd) to populate the argument list with all the files with `partshell` in the name recursively from the current directory.

### Closest Built-In Command

<p><code>args `fd partshell`</code> (but this won't handle matches with spaces in their names properly).</p>

## Grep

### `GrepSh[!]`, `Gsh[!]`

### `LgrepSh[!]`, `LGsh[!]`

## Make

### `MakeSh[!]`, `Msh[!]`

### `LmakeSh[!]`, `LMsh[!]`

## New

### `Enewsh[!]`, `Esh[!]`

### `NewSh[!]`, `Nsh[!]`

### `TabnewSh[!]`, `Tsh[!]`

### `VnewSh[!]`, `Vsh[!]`

With a bang use the existing buffer

## `P`

- `P !` example
- The `P` command started as a  `B` the [vis](https://www.vim.org/scripts/script.php?script_id=1195).



