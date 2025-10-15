# Partshell

Partshell is a Vim plugin that adds helper commands for working with shell commands in Vim. For example, `:Shgrep` is an easy way to use any `grep` program, the same way Vim's builtin `:grep` command works. For example, `:Shgrep rg --vimgrep foo` will use [`ripgrep`](https://github.com/BurntSushi/ripgrep).

## The Way of Partshell

1. Don't build specific tools into your editor, instead leverage flexible functionality that can work with a myriad of tools.
2. Don't build specific workflows into your editor, instead use efficient functionality that can be composed together to accomplish complex tasks.
3. Minimize editing your config, instead to seek to freeze your config such that it supports our needs today and the needs of tomorrow.

## Advantages

A couple of general advantages of the Partshell approach when compared to other existing solutions to the same problems:

1. **Flexibility:** For example, [`pbpaste`](https://ss64.com/mac/pbpaste.html) on macOS outputs the clipboard contents, so with `:Shgrep pbpaste` Vim will parse `grep` output from the clipboard (e.g., the built-in `:grep` command with the `'grepprg'` variable make this more difficult).
2. **Repeatability:** Since this approach only runs commands with arguments from the command line, like `:Shgrep fd partshell`, it's easy to repeat (or refine) previous commands using Vim's command line history by hitting up arrow (e.g., as opposed to fuzzy finders, which present a custom UI, if you want to re-open the same file you have to go through that UI every time).

## Cheat Sheet

- `:P <ex-command>`: Run an ex command but only use the visual selection, not the whole lines in the range (e.g., `:P sort` will sort a column selected with `C-v`, rather than all the lines in the range [`:sort` always sorts the whole lines in the range]).
- `:Pn <ex-command>`, `:Pv <ex-command>`, `:Ptabe <ex-command>`: Like `P`, but put the result in a new horizontal split, vertical split, or a new tab.
- `:Pn`, `:Pv`, `:Ptabe`: Omit the command to put the visual selection in a new horizontal split, vertical split, or a new tab.
- `!`, `:P !`: Like `:P` but for shell commands, pipe the current selection through a shell command, but only use the visual selection, not the whole lines in the range.
- `Shg rg foo`: Populate the quickfix list from an `rg` search.
- `Sha fd foo`: Populate the argument list from an `fd` search.
- `Shm make`: Run a compile command, populating the quickfix list with any errors.
- `Shn git show`, `Shv git show`, `Shtabe get show`: Show the current `git` commit in a horizontal split, a vertical split, or a new tab.

## Notes

Adding a bang (`!`), does the same behavior as the equivalent Vim built-in command (when the internal command supports one). For example, `:Shgrep!` won't automatically jump to the first match, just like `:grep!`. The `Shn[ew]` family of commands implement different bang behavior (because the built-in `:new` does not support a bang).

## `:Sha[rgs][!]`

Wrapper around `:args`.

Populates the argument list with the result of a shell command. Each line is interpreted as a path to a file (a NULL byte terminates input).

### Example

`:Shargs fd partshell` uses [`fd`](https://github.com/sharkdp/fd) to populate the argument list with all the files with `partshell` in the name (recursively from the current directory, because the way `fd` works by default).

#### Built-In Alternative

<p><code>args `fd partshell`</code> (but this won't handle matches with spaces in their filenames properly).</p>

## Grep

### `:Shg[rep][!]`

Run the arguments as a `grep` program, populating the quickfix list with the matching lines. With a bang (`!`), it doesn't automatically jump to the first match.

#### Example

`:Shgrep rg --vimgrep partshell` uses [ripgrep](https://github.com/BurntSushi/ripgrep) to populate the quickfix list with all the lines that contain `partshell` (recursively from the current directory, because the way `rg` works by default).

#### Built-In Alternative

`:set grepprg=rg\ --vimgrep | grep partshell` but that has the side effect of setting `'grepprg'` (which might be desirable! Setting `'grepprg'` to `rg` is a great alternative if the built-in `:grep` behavior isn't useful).

`:cexpr system('rg --vimgrep partshell')` will also likely work, although technically this uses `'errorformat'` instead of `'grepformat'` to parse matching lines (note that `%`, which can usually be used on the command line to reference the current file, will not work in this context).

### `:Shlg[rep][!]`

The same as `:Shgrep` but populate the location list instead of the quickfix list.

## Make

### `:Shm[ake][!]`

Run the arguments as a `make` program, populating the quickfix list with the lines with errors using `'errorformat'`. With a bang (`!`), it doesn't automatically jump to the first match.

#### Example

`:Shmake clang %` compiles the current file with `clang`.

#### Built-In Alternative

`:set makeprg=clang\ % | make`.

`:cexpr system('clang hello_world.c')` will also work (although `%` to reference the current file will not work in this context).

### `:Shlm[ake][!]`

The same as `:Shgrep` but populate the location list instead of the quickfix list.

## New Window

Commands that create a new buffer containing the output of a shell command.

The buffer will be named after the shell command, for example `Shnew git show` will create a buffer named `git show`. With a bang (`!`) the output will be read only (`setlocal buftype=nofile readonly nomodifiable`), won't prompt to save the buffer (e.g., `:qa` without a bang will still quit without saving the buffer) and the same buffer will be re-used for subsequent runs (without a bang, a new buffer will be created appending a number to the end, e.g., `git show 2`). These changes make `:shn!` more appropriate just as *a viewer* of shell output.

### Example

`:Shnew git diff` to create a new diff buffer named `git diff` containing the output of `git diff`.

### Built-In Alternative

`:new | r !git diff` but this adds an extra new line at the top and bottom of the output, and doesn't detect the file type. To solve these issues `:new | 0r !git diff ^J norm Gddgg | filetype detect` should work but doesn't seem to in practice (`^J` means do `CTRL-V_CTRL-J` which is the command separator to use after a `:!` to perform a another Vim command instead of piping to a shell command).

### `:She[new][!]`

Open a new buffer containing the result of a shell command (like `:enew` this will fail unless unless `'hidden'` is set or `'autowriteall'` is set and the file can be written).

### `:Shn[ew][!]`

Open a new buffer in a new window containing the result of a shell command.

### `:Shtabn[ew][!]`, `:Shtabe[dit][!]`

Open a new buffer on a new tab page containing the result of a shell command.

### `:Shv[new][!]`

Like `:Shn[ew][!]` but split vertically.

## `:P`

`:P` (stands for "partial") takes a command, and that command's arguments, as its arguments, and applies that command the visual selection. This is similar to the builtin support for running commands on a range, `'<,'><command>`, the builtin range support *only works on full lines*, whereas the `:P` command also works on visual selections consisting of partial lines. Vim does not have a builtin way to apply a command to a selection that consists of partial lines. So if part of a line is selected with `v` or `CTRL-v`, `'<,'><command>` will still apply the command to the full line, whereas the `:P` command will only apply command to the selected part of the line.

Using `:P !<shell-command>` will run a shell command on the visual selection.

The inspiration for `:P`, as well implementation ideas, came from the `:B` in the [vis](https://www.vim.org/scripts/script.php?script_id=1195) plugin.

The command passed as an argument to `:P` must support ranges.

### `:Psh`

`:Psh` is shorthand for `P !` (i.e., run a shell command on the visual selection) that allows tab completion. (`P !<tab>` uses shell completion in Neovim, but it does not in Vim, so `Psh <tab>` can be used for shell completion in Vim.)

Partshell binds `!` visual mode to use `:Psh` if there's a character-wise (`v`) or block-wise (`<C-v>`) visual selection, and the normal `!` behavior for line-wise `V`.

### `:Pn[ew][!]`

Like `:P` but put the results in a new buffer.

With a bang (`!`) omit the range to perform a command that doesn't take a range.

Without an argument, just create a new buffer with the contents.

### `:Pv[new][!]`

Like `:Pnew` but put the results in a new vertical buffer.

### `:Ptabn[ew][!]`, `:Ptabe[dit][!]`

Like `:Pnew` but put the results in a new vertical buffer.

### Example

Take this example of a Markdown table:

```
| Header 1     | Header 2     | Header 3     |
|--------------|--------------|--------------|
| Row 1 Cell 1 | Row 1 Cell 2 | Row 1 Cell 3 |
| Row 2 Cell 1 | Row 2 Cell 2 | Row 2 Cell 3 |
| Row 3 Cell 1 | Row 3 Cell 2 | Row 3 Cell 3 |
```

Use visual mode blockwise `<C-v>` to select `Header 3` rows 1-3, then try `P s/Row/Low` to replace in only the selection.

Another example is just doing a replacement on part of a line:

```
Who put the bomp in the "bomp bah bomp bah bomp?"
```

To replace, selecting in the quotes, then using `P s/bomp/plomp/g`.

The above examples also works using a shell comment, so `P !sed s/bomp/plomp/g` (or `Psh sed s/bomp/plomp/g` which uses the `Psh` command which provides shell completion in Vim) will have the same result.

### Built-In Alternative

Copy the selection to a new buffer, and apply the command there (this is also how `P` works internally), then copy the text again from the new buffer (being careful to use the same visual mode that was used to initially select the text, if you don't do this, pasting back will sometimes insert line breaks), then go back to the original buffer and restore your visual selection (`gv`) then paste (`p`).
