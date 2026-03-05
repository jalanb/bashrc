# vim-history

A vim plugin to show recent files from your vim history filtered by time periods.

## Installation

### Manual Installation

Copy the plugin files to your vim directory:

```bash
# Copy to your vim plugin directory
cp -r vim-history/* ~/.vim/

# Or for Neovim
cp -r vim-history/* ~/.config/nvim/
```

### With a Plugin Manager

If you're using a plugin manager like Pathogen, Vundle, or vim-plug, copy the 
vim-history directory to your bundles/plugins directory.

After installation, run `:helptags ~/.vim/doc` (or `:helptags ~/.config/nvim/doc`) 
to generate the help tags.

## Usage

### Main Command

```vim
:VimHistory [count] [scale]
```

- `count`: Number of time units to look back (default: 7)  
- `scale`: Time scale - h(ours), d(ays), w(eeks), m(onths) (default: d)

### Examples

```vim
:VimHistory 3 h      " Files from last 3 hours
:VimHistory 7 d      " Files from last 7 days (default)
:VimHistory 2 w      " Files from last 2 weeks  
:VimHistory 1 m      " Files from last month
```

### Shortcuts

```vim
:VimHistoryToday     " Files from today
:VimHistoryWeek      " Files from this week
:VimHistoryMonth     " Files from this month
```

## How it Works

The plugin uses vim's built-in `v:oldfiles` list and checks filesystem 
modification times to filter files by the specified time period. Only 
files that still exist and are readable are shown.

## Help

For detailed help, run `:help vim-history` after installation.

## Requirements

- Vim 7.0+ (uses `v:oldfiles` and lambda functions)
- Files must still exist on disk to be shown
