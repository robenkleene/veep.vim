# Veep

Veep ("V" for visual and "P" for pipe) is an update to [`vis.vim`](https://www.vim.org/scripts/script.php?script_id=1195), a Vim plugin for operating on *parts* of lines with Ex commands. 

For example, `:P sort` with a blockswise visual selection (e.g., with `<C-v>`) will sort a *column* of text, and `:Psh rev` with a characterwise visual selection (e.g., with `v`) will reverse *part* of a line using the `rev` shell command.

## Why Is This Plugin Necessary?

In Vim, Ex commands only operate on *ranges of lines*, they cannot operate on just *part* of a line.

A common way to use Ex commands in Vim is to create a visual selection, and then enter `:` to enter Vim's command line. If there's a visual selection, Vim prepopluates the command line with `:'<,'>`. `'<` and `'>` are used to indicate the first and last line of the visual selection. Line numbers themselves can also be used instead, e.g., `:1,9sort`.

Vim will enter `:'<,'>`, regardless of whether the current selection is [character-wise](https://vimhelp.org/visual.txt.html#characterwise-visual) (e.g., with `v`), [block-wise](https://vimhelp.org/visual.txt.html#blockwise-visual) (e.g., with `<C-v>`), or [line-wise](https://vimhelp.org/visual.txt.html#linewise-visual) selections (e.g., with `V`). *But `'<,'>` only matches the visual selection when the selection is linewise.* This is where plugins like Veep and `vis.vim` come in. These plugins allow Ex commands to *operate on any visual selection*.

### A Brief History of Ex Commands

Ex commands are named after the [Ex editor](https://en.wikipedia.org/wiki/Ex_(text_editor)) which is a [line editor](https://en.wikipedia.org/wiki/Line_editor) (like the more famous [ed](https://en.wikipedia.org/wiki/Ed_(software))). A line editor is a text editor that is designed to edit one line of text at a time. Vim's predecessor, [Vi](https://en.wikipedia.org/wiki/Vi_(text_editor)), is named such after the `visual` command in Ex that switches it to a full screen editing mode that shows the contents of the buffer while editing. In a line editor, the contents of the buffer isn't displayed by default, instead commands display the contents of lines, like `5n` to move to then print the contents of the fifth line in `ed`.

Vi, and later Vim, have evolved a lot since then, but this is the historical reason that Ex commands *only operate on whole lines*, that those commands were designed for an editor where operating on lines of text was the primary mode of operation, and, e.g., concepts like a selection, that could include part of a line, or a rectangular selection that spans part of multiple lines.

## Veep is Update to `vis.vim`

Veep is an update to `vis.vim`, and owes it's implementation to the clever trick `vis.vim` uses to operate on a visual selection: Yanking the contents of the visual selection and pasting it to a new buffer, then applying the Ex command to the contents of the new buffer, then copying the changed contents of the new buffer, and pasting it back over the original selection, an approach that proves (surprisingly) robust.

The history of this clever trick can traced back by checking the sources. [The version of `vis.vim` available on vim.org](https://www.vim.org/scripts/script.php?script_id=1195) links to [Dr Chip's Vim Page](http://www.drchip.org/astronaut/vim/index.html#VIS), which then further traces credit back: "The original <vis.vim> was by Stefan Roemer, but this one has been radically modified to support embedded tabs. It appears to operate considerably faster, and has no side effects on register usage, etc." The name "vis" is probably for visual (as in a visual selection) and the `:B` command `vis.vim` uses is probably for "block" (Dr. Chip's description "Performs an Ex command on a ctrl-v highlighted block. I often use it to target substitutes onto just a visual-block selection."

Veep started out as a fork of `vis.vim` with minor changes to how whitespace is handled, but more changes evolved overtime to warrant a separate release.

## Veep vs. `vis.vim`

The main differences between Veep and `vis.vim`:

- Uses `:P` (for "pipe") instead of `:B` (for "block").
- Adds the `:Psh` command to provide shell completion (`:P` takes an Ex command so it uses Ex command completion instead of shell completion [strangely, `:P !<command>` in Neovim will actually use shell completion, but not Vim]).
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

Use visual mode block-wise `<C-v>` to select `Header 3` rows 1-3, then try `P s/Row/Low` to replace in only the selection.

Another example is just doing a replacement on part of a line:

```
Who put the bomp in the "bomp bah bomp bah bomp?"
```

To replace, selecting in the quotes, then using `P s/bomp/plomp/g`.

The above examples also works using a shell comment, so `P !sed s/bomp/plomp/g` (or `Psh sed s/bomp/plomp/g` which uses the `Psh` command which provides shell completion in Vim) will have the same result.

### Built-In Alternative

Copy the selection to a new buffer, and apply the command there (this is also how `P` works internally), then copy the text again from the new buffer (being careful to use the same visual mode that was used to initially select the text, if you don't do this, pasting back will sometimes insert line breaks), then go back to the original buffer and restore your visual selection (`gv`) then paste (`p`).
