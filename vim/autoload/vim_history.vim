" autoload/vim_history.vim - Core functionality for vim-history plugin

function! vim_history#show(...) abort
    let l:count = a:0 >= 1 ? a:1 : 7
    let l:scale = a:0 >= 2 ? a:2 : 'd'
    
    let l:now = localtime()
    let l:scales = {'h': 3600, 'd': 86400, 'w': 604800, 'm': 2592000}
    
    if !has_key(l:scales, l:scale)
        echohl ErrorMsg
        echo "Unknown scale: " . l:scale . " (use h/d/w/m)"
        echohl None
        return
    endif
    
    let l:threshold = l:now - (l:count * l:scales[l:scale])
    let l:recent_files = []
    
    " Check v:oldfiles for recent files
    for l:file in v:oldfiles
        if filereadable(l:file)
            let l:mtime = getftime(l:file)
            if l:mtime >= l:threshold
                call add(l:recent_files, [l:mtime, l:file])
            endif
        endif
    endfor
    
    if empty(l:recent_files)
        echo "No files found in the last " . l:count . l:scale
        return
    endif
    
    " Sort by modification time (newest first)
    call sort(l:recent_files, {a, b -> b[0] - a[0]})
    
    " Open interactive menu
    call vim_history#open_menu(l:recent_files, l:count, l:scale)
endfunction

" Helper function to get human-readable time descriptions
function! vim_history#get_scales() abort
    return ['h (hours)', 'd (days)', 'w (weeks)', 'm (months)']
endfunction

" Open interactive menu for file selection
function! vim_history#open_menu(recent_files, count, scale) abort
    " Create new split buffer
    execute 'botright 15split __VimHistory__'
    
    " Set buffer options
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal nowrap
    setlocal cursorline
    setlocal nonumber
    setlocal norelativenumber
    
    " Store the file data in buffer variable
    let b:vim_history_files = a:recent_files
    
    " Clear buffer and add header
    normal! ggdG
    let l:header = "Files you've edited in vim with filesystem changes in last " . a:count . a:scale . ":"
    let l:subheader = "(from v:oldfiles, filtered by disk modification time)"
    let l:separator = repeat("=", max([len(l:header), len(l:subheader)]))
    
    call append(0, [l:header, l:subheader, l:separator])
    
    " Add file entries
    for [l:mtime, l:file] in a:recent_files
        let l:time_str = strftime('%Y-%m-%d %H:%M', l:mtime)
        let l:short_file = fnamemodify(l:file, ':~')
        call append(line('$'), l:time_str . '  ' . l:short_file)
    endfor
    
    " Add footer
    call append(line('$'), [l:separator, len(a:recent_files) . " files found", "", "j/k or ↑/↓ to navigate, <Enter> to open, q to quit"])
    
    " Position cursor on first file (after header)
    call cursor(4, 1)
    
    " Set up key mappings
    nnoremap <buffer> <silent> j :call vim_history#menu_down()<CR>
    nnoremap <buffer> <silent> k :call vim_history#menu_up()<CR>
    nnoremap <buffer> <silent> <Down> :call vim_history#menu_down()<CR>
    nnoremap <buffer> <silent> <Up> :call vim_history#menu_up()<CR>
    nnoremap <buffer> <silent> <CR> :call vim_history#menu_select()<CR>
    nnoremap <buffer> <silent> q :close<CR>
    nnoremap <buffer> <silent> <Esc> :close<CR>
    
    " Make buffer read-only
    setlocal readonly
    setlocal nomodifiable
endfunction

" Navigate down in menu, skipping header/footer
function! vim_history#menu_down() abort
    let l:current_line = line('.')
    let l:last_file_line = 3 + len(b:vim_history_files)
    
    if l:current_line < l:last_file_line
        normal! j
    endif
endfunction

" Navigate up in menu, skipping header/footer  
function! vim_history#menu_up() abort
    let l:current_line = line('.')
    
    if l:current_line > 4
        normal! k
    endif
endfunction

" Select current file and open it
function! vim_history#menu_select() abort
    let l:current_line = line('.')
    let l:file_index = l:current_line - 4  " Adjust for header lines
    
    " Check if we're on a valid file line
    if l:file_index >= 0 && l:file_index < len(b:vim_history_files)
        let l:file_path = b:vim_history_files[l:file_index][1]
        
        " Close the menu
        close
        
        " Open the selected file in the previous window
        execute 'edit ' . fnameescape(l:file_path)
    endif
endfunction
