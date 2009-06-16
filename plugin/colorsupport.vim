" colorsupport.vim: Use color schemes written for gvim in color terminal
"
" Maintainer:       Lee Jihwan <moonz@kaist.ac.kr>
" Version:          1.0
" URL:              http://www.vim.org/script.php?script_id=...

if exists('g:loaded_colorsupport') || &cp
    finish
endif
let g:loaded_colorsupport = 1

" from gnome-terminal
let s:palette_dict = {
\   'tango':
\       [[0x2E2E, 0x3434, 0x3636], [0xCCCC, 0x0000, 0x0000],
\        [0x4E4E, 0x9A9A, 0x0606], [0xC4C4, 0xA0A0, 0x0000],
\        [0x3434, 0x6565, 0xA4A4], [0x7575, 0x5050, 0x7B7B],
\        [0x0606, 0x9820, 0x9A9A], [0xD3D3, 0xD7D7, 0xCFCF],
\        [0x5555, 0x5757, 0x5353], [0xEFEF, 0x2929, 0x2929],
\        [0x8A8A, 0xE2E2, 0x3434], [0xFCFC, 0xE9E9, 0x4F4F],
\        [0x7272, 0x9F9F, 0xCFCF], [0xADAD, 0x7F7F, 0xA8A8],
\        [0x3434, 0xE2E2, 0xE2E2], [0xEEEE, 0xEEEE, 0xECEC]],
\    'console':
\       [[0x0000, 0x0000, 0x0000], [0xAAAA, 0x0000, 0x0000],
\        [0x0000, 0xAAAA, 0x0000], [0xAAAA, 0x5555, 0x0000],
\        [0x0000, 0x0000, 0xAAAA], [0xAAAA, 0x0000, 0xAAAA],
\        [0x0000, 0xAAAA, 0xAAAA], [0xAAAA, 0xAAAA, 0xAAAA],
\        [0x5555, 0x5555, 0x5555], [0xFFFF, 0x5555, 0x5555],
\        [0x5555, 0xFFFF, 0x5555], [0xFFFF, 0xFFFF, 0x5555],
\        [0x5555, 0x5555, 0xFFFF], [0xFFFF, 0x5555, 0xFFFF],
\        [0x5555, 0xFFFF, 0xFFFF], [0xFFFF, 0xFFFF, 0xFFFF]],
\    'xterm':
\       [[0x0000, 0x0000, 0x0000], [0xCDCB, 0x0000, 0x0000],
\        [0x0000, 0xCDCB, 0x0000], [0xCDCB, 0xCDCB, 0x0000],
\        [0x1E1A, 0x908F, 0xFFFF], [0xCDCB, 0x0000, 0xCDCB],
\        [0x0000, 0xCDCB, 0xCDCB], [0xE5E2, 0xE5E2, 0xE5E2],
\        [0x4CCC, 0x4CCC, 0x4CCC], [0xFFFF, 0x0000, 0x0000],
\        [0x0000, 0xFFFF, 0x0000], [0xFFFF, 0xFFFF, 0x0000],
\        [0x4645, 0x8281, 0xB4AE], [0xFFFF, 0x0000, 0xFFFF],
\        [0x0000, 0xFFFF, 0xFFFF], [0xFFFF, 0xFFFF, 0xFFFF]],
\    'rxvt':
\       [[0x0000, 0x0000, 0x0000], [0xCDCD, 0x0000, 0x0000],
\        [0x0000, 0xCDCD, 0x0000], [0xCDCD, 0xCDCD, 0x0000],
\        [0x0000, 0x0000, 0xCDCD], [0xCDCD, 0x0000, 0xCDCD],
\        [0x0000, 0xCDCD, 0xCDCD], [0xFAFA, 0xEBEB, 0xD7D7],
\        [0x4040, 0x4040, 0x4040], [0xFFFF, 0x0000, 0x0000],
\        [0x0000, 0xFFFF, 0x0000], [0xFFFF, 0xFFFF, 0x0000],
\        [0x0000, 0x0000, 0xFFFF], [0xFFFF, 0x0000, 0xFFFF],
\        [0x0000, 0xFFFF, 0xFFFF], [0xFFFF, 0xFFFF, 0xFFFF]]
\ }

function! s:get_palette()
    let l:palette = s:palette_dict[g:colorsupport_palette_name]

    if &t_Co == 256
        let l:comp_vals = insert(range(0x5F, 0xFF, 40), 0)
        let l:grey_vals = range(0x08, 0xFF, 10)[:23]
    elseif &t_Co == 88
        let l:comp_vals = insert(range(0x5F, 0xFF, 80), 0)
        let l:grey_vals = range(0x1C, 0xFF, 30)
    else
        return l:palette
    endif

    for l:r in l:comp_vals
        for l:g in l:comp_vals
            for l:b in l:comp_vals
                call add(l:palette, [l:r * 0x100, l:g * 0x100, l:b * 0x100])
            endfor
        endfor
    endfor

    for l:c in l:grey_vals
        call add(l:palette, [l:c * 0x100, l:c * 0x100, l:c * 0x100])
    endfor

    return l:palette
endfunction

function! ColorSupportSetPalette(palette_name)
    if empty(filter(keys(s:palette_dict), 'v:val == a:palette_name'))
        echohl ErrorMsg
        echomsg 'Unknown palette name "' . a:palette_name . '"'
        echohl None
        return
    endif

    let g:colorsupport_palette_name = a:palette_name
    let s:palette = s:get_palette()
endfunction

function! s:rgb(rgb)
    return map([1, 3, 5], '("0x" . strpart(a:rgb, v:val, 2)) * 0x100')
endfunction

if exists('g:colorsupport_palette')
    if len(g:colorsupport_palette) != 16
        echohl ErrorMsg
        echomsg 'Invalid g:colorsupport_palette'
        echohl None
        finish
    endif
    let s:palette_dict['custom'] = map(g:colorsupport_palette, 's:rgb(v:val)')
    let g:colorsupport_palette_name = 'custom'
endif

if !exists('g:colorsupport_palette_name')
    let g:colorsupport_palette_name = 'tango'
endif

call ColorSupportSetPalette(g:colorsupport_palette_name)

function! s:color_name(name)
    return tolower(substitute(a:name, '\s\+', '', 'g'))
endfunction

function! ColorSupportLoadRGB(...)
    for l:dir in a:000
        let l:file = l:dir . '/rgb.txt'
        if !filereadable(l:file)
            continue
        endif
        let l:s = escape('v:val =~ "^\s*\d"', '\')
        let l:lines = filter(readfile(l:file), l:s)
        for l:split in map(l:lines, 'split(v:val)')
            let [l:r, l:g, l:b] = l:split[:2]
            let l:name = s:color_name(join(l:split[3:]))
            let s:color_map[l:name] = printf('#%02x%02x%02x', l:r, l:g, l:b)
        endfor
    endfor
endfunction

let s:color_map = {}
call ColorSupportLoadRGB($VIMRUNTIME, '/usr/share/X11', '/usr/lib/X11',
\                        '/usr/X11/share/X11')

function! s:distance(rgb1, rgb2)
    let l:dist = 0.0
    for l:i in range(0, 2)
        let l:dist += pow(a:rgb1[l:i] - a:rgb2[l:i], 2) / 3
    endfor
    return float2nr(l:dist)
endfunction

let s:rgb_cache = {}
function! s:map_color(color)
    let l:c = a:color
    if l:c[0] != '#'
        if !has_key(s:color_map, s:color_name(l:c))
            return l:c
        endif
        let l:c = s:color_map[s:color_name(l:c)]
    endif

    if !has_key(s:rgb_cache, l:c)
        let l:distances = map(copy(s:palette), 's:distance(v:val, s:rgb(l:c))')
        let s:rgb_cache[l:c] = index(l:distances, min(l:distances))
    endif

    return s:rgb_cache[l:c]
endfunction

function! s:map_attrs(attrs)
    let l:new_attrs = []
    for l:attr in split(a:attrs, ',')
        if l:attr ==? 'italic'
            continue
        endif
        call add(l:new_attrs, l:attr)
    endfor
    return join(l:new_attrs, ',')
endfunction

function! s:highlight_do(cmd)
    execute a:cmd
    return

    " deprecated (changing colors_name is easier)
    let l:name = exists('g:colors_name') ? g:colors_name : ''
    execute a:cmd
    if l:name != '' && !exists('g:colors_name')
        " reloaded
        execute a:cmd
        let g:colors_name = l:name
    endif
endfunction

let s:delay = 0
let s:last_cmds = []
function! s:highlight(arg_str)
    " TODO:
    " - argument as quoted string
    " - " could be escaped or be inside quoted string

    " remove comment
    if strlen(substitute(a:arg_str, '[^"]', '', 'g')) % 2 == 0
        let l:arg_str = a:arg_str
    else
        let l:arg_str = a:arg_str[:strridx(a:arg_str, '"') - 1]
    endif

    " ignore cterm*
    let l:args = filter(split(l:arg_str), 'v:val !~? "^cterm.*="')
    if empty(l:args)
        return
    endif

    let l:adds = []
    let l:delay = 0
    for l:arg in l:args
        if l:arg !~? '^gui.*='
            continue
        endif

        let [l:key, l:val] = split(l:arg, '=')
        if l:key ==? 'gui'
            let l:attrs = s:map_attrs(l:val)
            if l:attrs != ''
                call add(l:adds, 'cterm=' . l:attrs)
            endif
        elseif l:key =~? '^gui[fb]g$'
            call add(l:adds, 'cterm' . l:key[-2:] . '=' . s:map_color(l:val))
        endif
    endfor

    let l:kw = '^\%(clear\|link\|default\)$'
    if ((l:args[0] !~# l:kw && len(l:args) == 1) ||
    \   (l:args[0] == 'default' && l:args[1] !~# l:kw && len(l:args) == 2)) &&
    \  empty(l:adds)
        return
    endif

    let l:cmd = 'hi ' . join(l:args + l:adds)
    call add(s:last_cmds, l:cmd)
    if !s:delay
        call s:highlight_do(l:cmd)
    endif
endfunction

command! -nargs=* -complete=highlight
\   Highlight :call s:highlight(<q-args>)

function! s:scheme(file)
    return substitute(substitute(a:file, "^.*/", "", ""), "\.vim$", "", "")
endfunction

function! ColorSchemeComplete(arg_lead, cmd_line, csr_pos)
    let l:glob = globpath(&runtimepath, 'colors/' . a:arg_lead . '*.vim')
    return map(split(l:glob, "\n"), 's:scheme(v:val)')
endfunction

function s:get_sid()
    return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_get_sid$')
endfunction
let s:sid = s:get_sid()

function! s:get_funcs(pat)
    redir => l:funcs
    silent execute 'function' '/' . a:pat
    redir END
    return map(split(l:funcs, "\n"), 'v:val[9:strridx(v:val, "(") - 1]')
endfunction

let s:last_run = ''
function! s:run(cmds)
    " join continued lines
    let @" = substitute(a:cmds, '\n\s*\\', '', 'g')
    let s:last_run = @"
    @"
endfunction

function! s:cmp(h1, h2)
    return (a:h1 !~? 'normal') - (a:h2 !~? 'normal')
endfunction

let s:comment = '" Generated by colorsupport.vim (DO NOT MODIFY THIS LINE)'
let s:colors_name = ''
function! s:colorscheme(scheme)
    let l:file = ''
    if a:scheme =~ '/'
        if glob(a:scheme) != ''
            let l:file = a:scheme
        endif
        let l:scheme = substitute(a:scheme, '^.*/', '', '')
        let l:scheme = substitute(l:scheme, '\.vim$', '', '')
    else
        let l:glob = globpath(&runtimepath, 'colors/' . a:scheme . '.vim')
        let l:files = split(l:glob, "\n")
        if len(l:files) != 0
            let l:file = l:files[0]
        endif
        let l:scheme = a:scheme
    endif

    if l:file == ''
        echohl ErrorMsg
        echomsg 'Colorscheme "' . a:scheme . '" not found'
        echohl None
        return
    endif

    hi clear Normal
    set background&

    let l:lines = readfile(l:file)
    if has('gui_running') || (!empty(l:lines) && l:lines[0] == s:comment)
        execute 'source' l:file
        return
    endif

    let l:patsub = [
    \   ['^\s*\(exe\a*\s\+"\)\?hi\a*\s', '\1Highlight '],
    \   ["colors_name\\s*=\\s*['\"]", '\0.'],
    \   ["\\<has(['\"]gui_running['\"])", '!\0'],
    \   ['&term\>', '"builtin_gui"'],
    \   ['', '<ESC>'],
    \   ['\%(g:\)\@<!colors_name\>', 'g:\0'],
    \   ['^\s*fini\a*', 'return'],
    \   ['^\s*sy\a*\s\+enable', '"\0'],
    \   ['<SID>', '\0_'],
    \   ['\<s:', '\0_'],
    \ ]

    let l:s = 'v:val'
    for [l:pat, l:sub] in l:patsub
        let l:pat = escape(l:pat, '\"')
        let l:sub = escape(l:sub, '\"')
        let l:s = printf('substitute(%s, "%s", "%s", "g")', l:s, l:pat, l:sub)
    endfor

    call filter(l:lines, 'v:val !~ "^\\s*\\\""')
    call map(l:lines, l:s)

    let s:delay = 1
    let s:last_cmds = []
    call s:run(join(l:lines, "\n"))
    let s:colors_name = g:colors_name[1:]

    for l:var in filter(keys(s:), 'v:val =~ "^_"')
        unlet s:[l:var]
    endfor
    for l:func in filter(s:get_funcs(s:sid . '__'),
    \                    'v:val =~ "^<SNR>' . s:sid . '__"')
        execute 'delfunction' l:func
    endfor

    call sort(filter(s:last_cmds, 'v:val !~? "hi clear"'), 's:cmp')

    hi clear
    for l:cmd in s:last_cmds
        call s:highlight_do(l:cmd)
    endfor
    let s:delay = 0
endfunction

command! -nargs=1 -complete=customlist,ColorSchemeComplete
\   ColorScheme :call s:colorscheme(<f-args>)

if exists('g:colors_name')
    execute 'ColorScheme' g:colors_name
endif

function! s:colorscheme_browse(...)
    execute 'silent bot 10new ColorSchemeBrowse'
    setlocal bufhidden=wipe buftype=nofile nobuflisted
    setlocal noswapfile nowrap

    if a:0 == 0
        let l:glob = globpath(&runtimepath, 'colors/*.vim')
    else
        let l:glob = globpath(a:1, '*.vim')
    endif
    silent put =l:glob
    /^\s*$/delete
    setlocal nomodifiable

    map <buffer> <CR> :ColorScheme <C-R>=getline('.')<CR><CR>
endfunction

command! -nargs=? -complete=dir
\   ColorSchemeBrowse :call s:colorscheme_browse(<f-args>)

function! s:colorscheme_save(...)
    if s:colors_name == ''
        echohl ErrorMsg
        echomsg 'ColorScheme not loaded'
        echohl None
        return
    endif

    let l:name = a:0 == 0 ? s:colors_name : a:1
    let l:file = split(&runtimepath, '\s*,\s*')[0] . '/colors/'
    let l:file .= l:name . '.vim'

    if filereadable(l:file)
        echohl ErrorMsg
        echomsg 'ColorScheme already exists "' . l:file . '"'
        echohl None
        return
    endif

    let l:lines = [
    \   s:comment,
    \   'hi clear',
    \   'set background=' . &background,
    \   'if exists("syntax_on")',
    \   '  syntax reset',
    \   'endif',
    \   'let g:colors_name = "' . l:name . '"'
    \ ] + s:last_cmds

    call writefile(l:lines, l:file)
    echo 'ColorScheme "' . l:file . '" saved'
endfunction

command! -nargs=? ColorSchemeSave :call s:colorscheme_save(<f-args>)
command! -nargs=0 ColorSchemeDebug :echo s:last_run
command! -nargs=0 ColorSchemePrint :echo join(s:last_cmds, "\n")

function! ColorSchemeTest()
    " setup
    let l:more = &more
    set nomore
    let l:name = exists('g:colors_name') ? g:colors_name : ''

    " test
    let l:glob = globpath(&runtimepath, 'colors/*.vim')
    for l:file in split(l:glob, "\n")
        echo "checking " . l:file
        execute 'ColorScheme' l:file
    endfor

    " teardown
    if l:name != ''
        if l:name[0] == '.'
            let l:name = l:name[1:]
        endif
        execute 'ColorScheme' l:name
    else
        hi clear
    endif
    if l:more == 'more'
        set more
    endif
endfunction
