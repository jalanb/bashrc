# Plans for vim

## VimHistory

## Current State
- Interactive menu with j/k navigation and Enter to select
- Filters v:oldfiles by filesystem modification time
- Opens selected files in current tab

## Version 1.1 - Better File Handling
- [ ] Show ALL files from v:oldfiles (readable + unreadable)
- [ ] Display unreadable files in grey/dimmed color
- [ ] When selecting unreadable file: create new file at that path

## Version 1.2 - Menu Persistence  
- [ ] Return to history menu after quitting opened files
- [ ] Make it a "top level menu" for vim file navigation
- [ ] Add keyboard mapping: `noremap th :call vim_history#show()<CR>`

## Version 2.0 - Enhanced Navigation
- [ ] fzf integration for searching the file list
- [ ] Fuzzy search within the history menu

## Version 3.0 - Organization
- [ ] Directory grouping options
- [ ] Choice between chronological vs directory-based views
- [ ] Figure out what "dir vs chronological" actually means

## Target Workflow
1. Open vim
2. Hit `th` (muscle memory from `tn`)  
3. Navigate/search recent files
4. Open file, edit, quit back to menu
5. Repeat until done

## Key Insight
`th` mapping works because on keyboard: t → h → n
Same finger movement, just stop one key earlier.
