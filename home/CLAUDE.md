# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

# Home Directory - Personal Configuration Files

This directory contains dotfiles and personal configuration files that are linked from `$HOME` to provide a centralized configuration management system. These files configure bash, vim, git, Python, and other development tools.

## Architecture

The home directory serves as the source for symlinks from `$HOME` directories:
- `~/.bashrc` -> `~/jab/home/bashrc`
- `~/.vimrc` -> `~/jab/home/vimrc`
- `~/.gitconfig` -> `~/jab/home/gitconfig`
- `~/.inputrc` -> `~/jab/home/inputrc`
- `~/.pythonrc.py` -> `~/jab/home/pythonrc.py`
- And many more...

## Key Configuration Files

### bashrc
The main bash configuration that:
- Sources `~/jab/__init__.sh` to initialize the full bash environment
- Sets up custom PATH configuration including homebrew, local bins, and Python site packages
- Provides color utility functions (`lred`, `lgreen`, `lblue`)
- Configures a detailed PS1 prompt showing user@host and current directory
- Runs initialization and post-initialization sequences
- Logs startup to `$HOME/log/bashrc.log` when in interactive mode

### gitconfig
Comprehensive git configuration with:
- Extensive aliases for common operations (e.g., `git l` for formatted log, `git s` for status)
- Custom difftool configurations for icdiff, Kaleidoscope, vim, and others
- Default branch set to `__main__` (not main/master)
- Auto-prune and rebase settings
- Sophisticated merge and conflict resolution tools

### vimrc
Heavily customized vim configuration featuring:
- Extensive custom key mappings for function keys, letters, and punctuation
- Integration with plugins via pathogen and vim-plug
- Custom functions for number display modes, search management, and file operations
- Git integration through vim-fugitive and vim-gitgutter
- File explorer integration with ranger
- EasyMotion for enhanced navigation
- Custom colorscheme and visual settings

### inputrc
Readline configuration with:
- Vi editing mode enabled
- Case-insensitive completion
- Enhanced history search with up/down arrows
- Function key bindings for common operations
- Bash-specific key mappings

### pythonrc.py
Python REPL enhancements:
- Tab completion setup
- History file management with timestamps
- Custom `see()` function for filtered dir() listings
- Colored prompts (green for >>> and blue for ...)
- Custom quit object for easier exit

## Development Workflow

### Testing Configuration Changes
When modifying dotfiles:
1. Edit the file in `~/jab/home/`
2. Source the file to test: `source ~/.bashrc` or restart vim
3. Test functionality before committing changes

### Key Functions and Aliases
From bashrc:
- `.b`: Reload bash configuration
- `bashrc()`: Main initialization function
- `bbb()`: List all configuration files being sourced
- `vbb()`: Edit all bash configuration files in vim tabs

From gitconfig aliases:
- `git l`: Pretty formatted git log
- `git s`: Git status
- `git d`: Diff with icdiff
- `git om`: Checkout main branch (__main__)

### Path Configuration
The system maintains custom PATH ordering:
1. `$HOME/jab/bin` and `$HOME/bin` (personal scripts)
2. GNU tools from homebrew
3. System paths
4. Python site packages from `~/jab/src/python/site/`

### Color System
The bashrc implements a color system using ANSI escape codes:
- Red for hostnames and errors
- Green for paths and success
- Blue for usernames and information
- Functions like `lred()`, `lgreen()`, `lblue()` for consistent coloring

## Integration Points

This home directory integrates with:
- `~/jab/src/bash/` - Main bash function library
- `~/jab/environ.d/` - Environment variable configuration
- `~/jab/vim/` - Vim plugins and additional configuration
- `~/jab/bin/` - Personal executable scripts

## Security Considerations

- Git configuration includes credential storage setup
- SSH configuration referenced in git for secure connections
- No sensitive information stored in these configuration files
- Backup configurations maintain history without exposing secrets