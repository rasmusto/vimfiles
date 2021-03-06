" pathogen setup {{{1
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

set regexpengine=0
set lazyredraw
set clipboard=autoselect,exclude:.*

set autochdir

" General {{{1
set history=300

" Enable filetype plugin
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

let mapleader = ","
let g:mapleader = ","
let maplocalleader = ","
let g:maplocalleader = ","

" change timeout for sending esc/meta through terminal
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw

set timeout
set ttimeoutlen=50

" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
autocmd! bufwritepost *.snippets call ReloadAllSnippets()

" profiling {{{1
nnoremap <silent> <leader>DD :exe ":profile start profile.log"<cr>:exe ":profile func *"<cr>:exe ":profile file *"<cr>
nnoremap <silent> <leader>DP :exe ":profile pause"<cr>
nnoremap <silent> <leader>DC :exe ":profile continue"<cr>
nnoremap <silent> <leader>DQ :exe ":profile pause"<cr>:noautocmd qall!<cr>

" VIM user interface {{{1
set scrolloff=7
set wildmenu
set hidden

" Mouse control in terminal
set mouse=a
set ttyfast
set ttymouse=xterm2

set backspace=start,indent

set smartcase ignorecase
set hlsearch
set incsearch
set magic

let loaded_matchparen = 1
" set showmatch
" let timeoutlen = 10
" set matchtime=2

" No sound on errors
set noerrorbells
set novisualbell
set t_vb=

" Lock scrolling horizontally when using scrollbind
set scrollopt+=hor
set scrollopt+=ver
set scrollopt+=jump

set number

set listchars=tab:»\ ,eol:¬

" Colors and Fonts {{{1
syntax enable

" Set font according to system
if has('mac')
    set gfn=Bitstream\ Vera\ Sans\ Mono:h12
    " set shell=/bin/bash
elseif has('win32')
    set shellcmdflag=/c
    set guifont=DejaVu_Sans_Mono:h12:cANSI
elseif has('unix')
    set guifont=GohuFont
    " set shell=/bin/bash
endif

let g:solarized_italic=0

if has('gui_running')
    "Fullscreen
    set go-=m go-=T go-=l go-=L go-=r go-=R go-=b go-=F go=
    set t_Co=256
    set background=dark
    " set background=light
    colorscheme solarized
else
    set t_Co=256
    set background=dark
    " set background=light
    colorscheme solarized
endif

set encoding=utf8
try
    lang en_US
catch
endtry

set fileformats=unix,dos,mac

" Files and backups {{{1
set nobackup
set nowritebackup
set noswapfile

" Text, tab and indent related {{{1
set expandtab
set shiftwidth=4
set smarttab

set linebreak
set textwidth=80

set autoindent
set nowrap

" Visual mode related{{{1

" show length of visual mode selection
set showcmd

function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Mappings {{{1
" In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>
vnoremap <silent> gv :call VisualSearch('gv')<CR>

" Command mode related
cnoremap <C-P> <Up>
cnoremap <C-N> <Down>

" Moving around, tabs and buffers
" Window movement
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

nnoremap <leader>v <C-w>v<C-w>l
nnoremap <leader>s <C-w>s

" Close the current buffer
map <leader>dd :Bclose<cr>

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

" Buffer changing
map <M-l> :bn<cr>
map <M-h> :bp<cr>
nmap <leader>l :set list!<CR>
map <silent> <leader><cr> :noh<cr>

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Specify the behavior when switching between buffers
try
    set switchbuf=usetab
    set showtabline=1
catch
endtry


" Quickfix/location list {{{1
map <leader>co :botright copen<cr>
map <leader>lo :botright lopen<cr>

map <M-n> :cn<cr>
map <M-p> :cp<cr>


" Language-specific settings {{{1
" C {{{2
au FileType c set tabstop=2
" au FileType c set shiftwidth=4
" au FileType c set noexpandtab
au FileType c set path=.,/usr/include,/tools/dist/cadence/LDV/5.8-s005/Linux/tools.lnx86/include,,

" Python {{{2
let python_highlight_all = 1

au FileType python set smartindent
au FileType python set tabstop=4
au FileType python set shiftwidth=4
au FileType python set expandtab

" BODOL {{{2
" Keybindings for λ and ƒ
inoremap <A-l> <C-v>u3bb<Space>
inoremap <A-f> <C-v>u192<Space>

" Clojure {{{2
let g:clojure_align_multiline_strings = 1
let g:clojure_align_subforms = 1

" Haskell {{{2
let g:haddock_browser = "chromium"
let g:haddock_docdir = "/usr/share/haskell/haddock"

" whitespace {{{2
func! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.r :call DeleteTrailingWS()
autocmd BufWrite *.clj :call DeleteTrailingWS()

highlight ExtraWhitespace ctermbg=0 guibg=#073642
" highlight ExtraWhitespace ctermbg=7 guibg=#eee8d5
match ExtraWhitespace /\s\+$/

" autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
" autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
" autocmd InsertLeave * match ExtraWhitespace /\s\+$/
" autocmd BufWinLeave * call clearmatches()

" Omni complete functions {{{2
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType c set omnifunc=ccomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete

" MISC {{{1
" Remove the Windows ^M - when the encodings gets messed up
noremap <leader>mmm mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Statusline {{{1
set laststatus=2

" Plugin-specific mappings {{{1

" Tagbar {{{2
let g:tagbar_left = 1
let g:tagbar_compact = 1

let g:tagbar_ctags_bin = '/usr/bin/ctags'
map <F4> :TagbarToggle<cr>
map <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

" R lang {{{2
let vimrplugin_screenplugin = 0
let vimrplugin_underscore = 0

" Yankring {{{2
let g:yankring_history_file = '.yankring_history'
let g:Powerline_symbols = 'fancy'
set fillchars+=stl:\ ,stlnc:\ 
let g:Powerline_theme = 'default'
let g:Powerline_colorscheme = 'skwp'

" Ctrlp {{{2
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_open_multiple_files = '1hjr'
let g:ctrlp_max_height = 40
let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/](vnc_logs|target|.git|.hg|.svn|build)$',
            \ 'file': '\v\.(o)$',
            \ }
let g:ctrlp_working_path_mode = 'r'

" Syntastic {{{2
" disable perl syntax checking, it's recursive and takes too long
let g:syntastic_disabled_filetypes = ['perl', 'python']

" python syntax checking weirdness
let g:syntastic_enable_highlighting = 0
let g:syntastic_echo_current_error = 0
let g:syntastic_python_checker='flake8'
let g:syntastic_python_checker_args='--ignore=E501'
let g:syntastic_enable_signs=0
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],
                           \ 'passive_filetypes': ['python', 'perl'] }

" paredit {{{2
let g:paredit_shortmaps=1
command! Ptoggle call PareditToggle()

" airline {{{2
set noshowmode

function! SyntaxItem()
    return synIDattr(synID(line("."),col("."),1),"name")
endfunction

let g:airline_section_b = '%{SyntaxItem()}'

let g:airline_inactive_collapse=1
let g:airline_powerline_fonts=0
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_linecolumn_prefix = '¶ '
let g:airline_branch_prefix = ''
let g:airline_paste_symbol = 'Þ'
let g:airline_whitespace_symbol = 'W'

let g:airline_detect_paste=1
let g:airline_detect_whitespace=0 "disabled
let g:airline_enable_tagbar=1

let g:airline#extensions#tabline#enabled = 0

" formatoptions {{{1
set formatoptions=crqj2

" From sample vimrc (thanks bram) {{{1
if has("autocmd")

    " Enable file type detection.
    " Use the default filetype settings, so that mail gets 'tw' set to 72,
    " 'cindent' is on in C files, etc.
    " Also load indent files, to automatically do language-dependent indenting.
    filetype plugin indent on

    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!

        " For all text files set 'textwidth' to 78 characters.
        autocmd FileType text setlocal textwidth=78

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid or when inside an event handler
        " (happens when dropping a file on gvim).
        " Also don't do it when the mark is in the first line, that is the default
        " position when opening a file.
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif

    augroup END

else
    set autoindent
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" Command/search edit window {{{1
au CmdwinEnter * nnoremap <buffer> <ESC> :q<cr>
au CmdwinEnter * nnoremap <buffer> <C-[> :q<cr>

" Change case {{{1
set tildeop

au BufRead,BufNewFile *.cshrc set filetype=csh

" persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

nnoremap <F5> :GundoToggle<CR>

" cscope {{{1
set csprg=/usr/bin/cscope

set cscopequickfix=s-,c-,d-,i-,t-,e-
set cscopetag
set csto=1

if filereadable("cscope.out")
    cs add cscope.out
endif

set cscopeverbose

nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>

" Using 'CTRL-spacebar' then a search type makes the vim window
" split horizontally, with search result displayed in
" the new window.

nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>

nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>

" Hitting CTRL-space *twice* before the search type does a vertical
" split instead of a horizontal one

nmap <C-Space><C-Space>s
            \:vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>g
            \:vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>c
            \:vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>t
            \:vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>e
            \:vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-Space><C-Space>i
            \:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-Space><C-Space>d
            \:vert scs find d <C-R>=expand("<cword>")<CR><CR>

nmap <C-@><C-@>s
            \:vert scs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>g
            \:vert scs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>c
            \:vert scs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>t
            \:vert scs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>e
            \:vert scs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-@><C-@>i
            \:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-@><C-@>d
            \:vert scs find d <C-R>=expand("<cword>")<CR><CR>
