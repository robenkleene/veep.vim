# Veep

Veep ("V" for visual and "P" for pipe) is an update to [`vis.vim`](https://www.vim.org/scripts/script.php?script_id=1195), a Vim plugin for operating on *parts* of lines with Ex commands. 

For example, `:P sort` can sort a *column* of text, and `:Psh rev` can run the shell command `rev` on *part* of a line.

## A Brief History of Ex Commands

Ex commands are named after the [Ex editor](https://en.wikipedia.org/wiki/Ex_(text_editor)) which is a [line editor](https://en.wikipedia.org/wiki/Line_editor) (like [ed](https://en.wikipedia.org/wiki/Ed_(software)). A line editor is a text editor that edits lines of text one at a time. Vim's predecessor ([Vi](https://en.wikipedia.org/wiki/Vi_(text_editor) is named such after the `visual` command in Ex that switched to it's full screen editing mode. The full screen editing mode means it the contents of a buffer full screen. In a line editor, the contents of the buffer isn't displayed by default, instead commands would display the contents of lines (e.g., `5n` in `ed` means move to line five and print the contents of that line).

This is all to explain why Vim's Ex commands *only operate on whole lines*, and what the value Veep, which is allowing Ex commands to *operate on any visual selection*. In addition to [line-wise](https://vimhelp.org/visual.txt.html#linewise-visual) (with `V`), a visual selection in Vim can also be either [character-wise](https://vimhelp.org/visual.txt.html#characterwise-visual) (with `v`) or [block-wise](https://vimhelp.org/visual.txt.html#blockwise-visual) (with `<C-v>`). Veep allows Ex commands to also work with the latter two.

## `vis.vim`

Veep is an update to `vis.vim`, and owes it's implementation to the clever trick `vis.vim` uses to operate on a visual selection: Yanking the contents of the visual selection to a new buffer, then apply the Ex command to the contents of the new buffer, then copy the changed contents of the new buffer, and paste back over the original selection. An approach that proves to be surprisingly robust in usually doing what you want.

The history of this trick can be found by tracing back through from the `vis.vim` to give credit to the inspiration. The [version created by Charles Campbell on vim.org](https://www.vim.org/scripts/script.php?script_id=1195), links to [Dr Chip's Vim Page](http://www.drchip.org/astronaut/vim/index.html#VIS), which then further traces credit back "The original <vis.vim> was by Stefan Roemer, but this one has been radically modified to support embedded tabs. It appears to operate considerably faster, and has no side effects on register usage, etc."

## Veep vs. `vis.vim`

The main changes Veep makes from `vis.vim`:

- Uses `:P` instead of `:B`.
- Adds the `:Psh` command to provide shell completion (`:P` takes an Ex command so it uses Ex command completion).
- Binds `!` in visual mode to use `:Psh` if there's a character-wise (`v`) or block-wise (`<C-v>`) visual selection, and the normal `!` behavior for line-wise `V`.
- Includes the `:Pnew`, `:Pvnew`, `Penew`, and `tabedit` family of commands that put the result in a new buffer instead of replacing the visual selection.

## Veep Examples

- `:P <ex-command>`: Run an ex command but only use the visual selection, not the whole lines in the range (e.g., `:P sort` will sort a column selected with `C-v`, rather than all the lines in the range [`:sort` always sorts the whole lines in the range]).
- `:Pnew <ex-command>`, `:Pvnew <ex-command>`, `:Ptabedit <ex-command>`: Like `P`, but put the result in a new horizontal split, vertical split, or a new tab.
- `:Pnew`, `:Pvnew`, `:Ptabedit`: Omit the command to put the visual selection in a new horizontal split, vertical split, or a new tab.
- `!`, `:P !`: Like `:P` but for shell commands, pipe the current selection through a shell command, but only use the visual selection, not the whole lines in the range.

## `:P`

`:P` (for "pipe") takes a command, and that command's arguments, as its arguments, and applies that command the visual selection. This is similar to the builtin support for running commands on a range, `'<,'><command>`, the builtin range support *only works on full lines*, whereas the `:P` command also works on visual selections consisting of partial lines. Vim does not have a builtin way to apply a command to a selection that consists of partial lines. So if part of a line is selected with `v` or `CTRL-v`, `'<,'><command>` will still apply the command to the full line, whereas the `:P` command will only apply command to the selected part of the line.

Using `:P !<shell-command>` will run a shell command on the visual selection.

The commands passed as an argument to `:P` must support ranges, unless `:P!` is used, in which case they must *not* require a range.

### `:Psh`

`:Psh` is shorthand for `P !` (i.e., run a shell command on the visual selection) that allows tab completion. (`P !<tab>` uses shell completion in Neovim, but it does not in Vim, so `Psh <tab>` can be used for shell completion in Vim.)

Veep binds `!` visual mode to use `:Psh` if there's a character-wise (`v`) or block-wise (`<C-v>`) visual selection, and the normal `!` behavior for line-wise `V`.

### `:Pn[ew][!]`

Like `:P` but put the results in a new buffer (which is useful for example to just see the output of a command, rather than replacing the selection).

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
