set nocompatible

"""""""""""""""""""""""""
" General
"""""""""""""""""""""""""

set encoding=utf8

inoremap jk <Esc>

let maplocalleader=","
let mapleader=","

" Line numbering
set nu

" Set to auto read when a file is changed from the outside
set autoread

" Sets how many lines of history vim has to remember
set history=500

" Enable filetype plugins
filetype plugin on

map <F3> :setlocal spell!<CR>

map <F5> :! ruby %<CR>

" Map ,e and ,v to open files in the same directory as the current file
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

map <leader>b :Gblame<CR>

"""""""""""""""""""""""""
" Vundle & Plugins
"""""""""""""""""""""""""

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'gmarik/vundle'
Plugin 'kien/ctrlp.vim'
Plugin 'mattn/gist-vim'
Plugin 'mattn/webapi-vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'ervandew/supertab'

" Plugin configs
"
nmap <silent> <leader>n :NERDTreeToggle<CR>

" move between buffers with control + h
noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

" gists are private by default
let g:gist_post_private = 1

" Colors
Plugin 'altercation/vim-colors-solarized'
Plugin 'tomasr/molokai'

call vundle#end()

"""""""""""""""""""""""""
" Appearances
"""""""""""""""""""""""""

" Syntax highlighting
syntax on

" Color scheme
set t_Co=256
colorscheme molokai

" Line number colors
highlight LineNr ctermfg=gray ctermbg=none

" Column Limit
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

"highlight ColorColumn ctermbg=yellow
"call matchadd('ColorColumn', '\%81v', 100)

au BufNewFile,BufRead *.ejs set filetype=html

"""""""""""""""""""""""""
" Indentation
"""""""""""""""""""""""""

" Autoindent
filetype indent on
set autoindent

" Tabs to space
set tabstop=2 shiftwidth=2 expandtab

" Toggle autoincremental tabbing on paste
set pastetoggle=<F2>

"""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""

" Ignore case when searching
set ignorecase

" Makes search act like search in modern browsers
set incsearch

" Highlight search
set hls

" Allow expected backspace behavior
set backspace=indent,eol,start

"""""""""""""""""""""""""
" Backup
"""""""""""""""""""""""""

"set backupdir=/var/tmp,~/tmp

"set dir=/var/tmp,~/tmp

set noswapfile

"""""""""""""""""""""""""
" Experimental Below This Line
"""""""""""""""""""""""""

set smartindent

set smarttab

" Display tab characters and trailing spaces
exe "set listchars=tab:\uBB\uBB,trail:\uB7"
set list

"""""""""""""""""""""""""
" Rails / Zeus Magic
"""""""""""""""""""""""""

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo
    exec ":!zeus rspec " . a:filename
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_spec_file = match(expand("%"), '_spec.rb$') != -1
    if in_spec_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number)
endfunction

function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . _ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction

" Run this file
map <leader>t :call RunTestFile()<cr>
" Run only the example under the cursor
map <leader>T :call RunNearestTest()<cr>
" Run all test files
map <leader>a :call RunTests('spec')<cr>
" Show routes
map <leader>gR :call ShowRoutes()<cr>
