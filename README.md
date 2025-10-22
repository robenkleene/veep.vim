# Veep

Veep ("V" for visual selection because all the commands require a range [that's usually set by a visual selection], and "P" for pipe, because all the commands act like a shell pipe taking the visual selection as input) is a Vim plugin that adds helper commands for working with shell commands in Vim. For example, `:Pshgrep` is an easy way to use any `grep` program, the same way Vim's builtin `:grep` command works. For example, `:Pshgrep rg --vimgrep foo` will use [`ripgrep`](https://github.com/BurntSushi/ripgrep).

All of the commands start with `P` which stands for "pipe", because all the Veep commands take a range that acts like a pipe (`|`) on the shell.

## Examples

- `:P <ex-command>`: Run an ex command but only use the visual selection, not the whole lines in the range (e.g., `:P sort` will sort a column selected with `C-v`, rather than all the lines in the range [`:sort` always sorts the whole lines in the range]).
- `:Pn <ex-command>`, `:Pv <ex-command>`, `:Ptabe <ex-command>`: Like `P`, but put the result in a new horizontal split, vertical split, or a new tab.
- `:Pn`, `:Pv`, `:Ptabe`: Omit the command to put the visual selection in a new horizontal split, vertical split, or a new tab.
- `!`, `:P !`: Like `:P` but for shell commands, pipe the current selection through a shell command, but only use the visual selection, not the whole lines in the range.

## `:P`

`:P` (stands for "pipe") takes a command, and that command's arguments, as its arguments, and applies that command the visual selection. This is similar to the builtin support for running commands on a range, `'<,'><command>`, the builtin range support *only works on full lines*, whereas the `:P` command also works on visual selections consisting of partial lines. Vim does not have a builtin way to apply a command to a selection that consists of partial lines. So if part of a line is selected with `v` or `CTRL-v`, `'<,'><command>` will still apply the command to the full line, whereas the `:P` command will only apply command to the selected part of the line.

Using `:P !<shell-command>` will run a shell command on the visual selection.

The inspiration for `:P`, as well implementation ideas, came from the `:B` in the [vis](https://www.vim.org/scripts/script.php?script_id=1195) plugin.

The command passed as an argument to `:P` must support ranges.

### `:Psh`

`:Psh` is shorthand for `P !` (i.e., run a shell command on the visual selection) that allows tab completion. (`P !<tab>` uses shell completion in Neovim, but it does not in Vim, so `Psh <tab>` can be used for shell completion in Vim.)

Veep binds `!` visual mode to use `:Psh` if there's a character-wise (`v`) or block-wise (`<C-v>`) visual selection, and the normal `!` behavior for line-wise `V`.

### `:Pn[ew][!]`

Like `:P` but put the results in a new buffer.

With a bang (`!`) omit the range to perform a normal mode command that doesn't take a range.

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
