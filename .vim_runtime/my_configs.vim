" Functions
" {
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

function! TabToggle()
  if &expandtab
    set shiftwidth=4
    set softtabstop=0
    set noexpandtab
  else
    set shiftwidth=4
    set softtabstop=4
    set expandtab
  endif
endfunction

function! UpdateCtags()
	exec "!ctags -f ./.ctags.vim -R . $(_get_python_lib_dirs) >/dev/null 2>&1"
endfunction

function! MatchCaseTag()
    let ic = &ic
    set noic
    try
        exe 'tjump ' . expand('<cword>')
    finally
       let &ic = ic
    endtry
endfunction

function! TabMode()
    if &expandtab
        return '[space]'
    else
        return '[tab]'
    endif
endfunction

function! LightLineModified()
    return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
    return &ft !~? 'help' && &readonly ? '' : ''
endfunction

function! LightLineFugitive()
    try
        if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
        let mark = ' '
        let branch = fugitive#head()
        return branch !=# '' ? mark.branch : ''
        endif
    catch
    endtry
    return ''
endfunction

function! LightLineFilename()
    let fname = expand('%:t')
    return fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item') ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFileformat()
    return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
    return winwidth(0) > 70 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
    return winwidth(0) > 70 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
    let fname = expand('%:t')
    return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! s:syntastic()
    SyntasticCheck
    call lightline#update()
endfunction

function! LightLineWhitespaceCheck()
    return get(b:, 'lightline_whitespace_check', "")
endfunction

function! LightLineWhitespace()
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && !&readonly && &modifiable && line('$') < 10000
        let trailing = search('\s$', 'nw')
        let mixed = search('\v(^\t+ +)|(^ +\t+)', 'nw')
        let b:lightline_whitespace_check = ""

        if trailing != 0
            let b:lightline_whitespace_check .= printf(' trailing[%s]', trailing)
        endif
        if mixed != 0
            let b:lightline_whitespace_check .= printf(' mixed-indent[%s]', mixed)
        endif
    endif
endfunction
" }

" Variables
" {
let $BASH_ENV = "~/.bashrc"
let mapleader = ","
let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")
let g:pymode_python = 'python3'
let g:pymode_folding = 0
let g:NERDTreeWinPos = "left"
let g:lightline = {
      \ 'colorscheme': 'material',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'whitespace', 'tabmode' ],  [ 'syntastic', 'lineinfo' ], [ 'percent' ], [ 'fileformat', 'fileencoding', 'filetype' ] ],
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}',
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
      \   'whitespace': '(exists("b:lightline_whitespace_check") && ""!=b:lightline_whitespace_check)',
      \ },
      \ 'component_function': {
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \   'whitespace': 'LightLineWhitespaceCheck',
      \   'tabmode': 'TabMode',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \   'whitespace': 'warning',
      \   'tabmode': 'warning',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }
" }

" Configuration
" {
if has('gui_running')
    set guifont=Ubuntu\ Mono\ derivative\ Powerline\ 9
else
    set t_Co=256
endif

colorscheme vice

set nu
set foldmethod=manual
set noshowmode
set laststatus=2
set fillchars+=vert:\ 
set diffopt+=vertical
set background=dark
set nobackup
set noswapfile

set tags=./.ctags.vim;
set modeline
set modelines=5
set shiftwidth=4
set softtabstop=4
set expandtab

let g:phpqa_messdetector_ruleset = "cleancode,codesize,controversial,design,naming,unusedcode"

if !&diff && &columns > 110
    autocmd VimEnter * if &ft != 'gitcommit' | NERDTree | endif
    autocmd BufWinEnter * NERDTreeMirror
    autocmd VimEnter * wincmd p
endif

augroup AutoSyntastic
    autocmd!
    autocmd BufWritePost *.c,*.cpp,*.sh,*.py call s:syntastic()
augroup END

augroup AutoWhitespaceCheck
    autocmd!
    autocmd BufWritePost * call LightLineWhitespace()
    autocmd BufReadPost * call LightLineWhitespace()
augroup END

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }

" Key mappings
" {
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
nnoremap <F3> :call MatchCaseTag()<CR>
nmap <F9> mz:execute TabToggle()<CR>'z
map <F2> :call UpdateCtags()<CR>
" }

