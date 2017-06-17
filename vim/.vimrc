set nocompatible
filetype off

"Plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'flazz/vim-colorschemes.git'
Plugin 'vim-scripts/paredit.vim'
Plugin 'luochen1990/rainbow'
Plugin 'vim-scripts/SlateDark'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'tpope/vim-classpath'
Plugin 'guns/vim-clojure-highlight'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-dispatch'
Plugin 'easymotion/vim-easymotion'
Plugin 'tpope/vim-fireplace'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'tpope/vim-salve'
Plugin 'kshenoy/vim-signature'
call vundle#end()

"Editor settings
syntax on
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start
set ruler
set number
filetype plugin indent on
set shortmess=a
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set splitright
set splitbelow
set laststatus=2
"./ is a special case, will keep traversing up until it finds a file 'tags'
set tags=./tags;
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
silent! au BufWritePost $MYVIMRC
au Filetype clojure nmap <c-c><c-k> :Require<cr>
 
"Commands
silent! delcommand Split3
command Split3 execute "vsplit | split"

"Plugin settings
let g:EasyMotion_smartcase = 1
let g:rainbow_active = 1
let g:ycm_confirm_extra_conf = 0
let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'
silent! AirlineRefresh

"Editor keybinds
noremap <F2> :tabnew .<CR>
noremap <F6> :tabp<CR>
noremap <F7> :tabn<CR>
noremap <F12> :so $MYVIMRC<CR>
nnoremap <Space> @q
inoremap jk <ESC>l
nnoremap <CR> G
nnoremap <BS> gg
let mapleader = "\\"
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>ez :vsplit ~/.zshrc<CR>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <leader>vv :vsplit<CR>
nnoremap <leader>vs :split<CR>
nnoremap <A-]> :vsplit <CR>:exec("tag ".expand("<cword>"))<CR>
fun! SPLITAG() range
  let oldfile=expand("%:p")
    vsplit
  exe "tag ". expand("<cword>")
  let curfile=expand("%:p")
  if curfile == oldfile
    let pos=getpos(".")
    if &modified
      " if we have split before:
      quit
    endif
    call setpos('.', pos)
  endif
endfun
nnoremap <C-]> :call SPLITAG()<CR>z.

"Plugin keybinds
noremap <leader> <PLUG>(easymotion-prefix)
nnoremap <leader>j <PLUG>(easymotion-j)
nnoremap <leader>k <PLUG>(easymotion-k)
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)
map / <Plug>(easymotion-sn)
map / <Plug>(easymotion-tn)
omap t <Plug>(easymotion-t1)
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
