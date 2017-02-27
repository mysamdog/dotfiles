execute pathogen#infect()
syntax on
noremap <F2> :tabnew .<CR>
noremap <F6> :tabp<CR>
noremap <F7> :tabn<CR>
noremap <F12> :so $MYVIMRC<CR>
filetype plugin indent on
set tabstop=2
set shiftwidth=2
set backspace=indent,eol,start
set ruler
set number
inoremap jk <ESC>l
inoremap JK <ESC>l
inoremap kj <ESC>l
inoremap KJ <ESC>l
set shortmess=a
colo SlateDark
let g:EasyMotion_do_mapping = 0
noremap <leader> <PLUG>(easymotion-prefix)
let g:EasyMotion_smartcase = 1
map <leader>j <PLUG>(easymotion-j)
map <leader>k <PLUG>(easymotion-k)
let g:rainbow_active = 1
set wildchar=<Tab> wildmenu wildmode=full
set wildcharm=<C-Z>
nnoremap <F10> :b <C-Z>
set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
set laststatus=2
let g:ycm_confirm_extra_conf = 0
let delimitMate_expand_cr = 1
set splitbelow
set splitright
nmap <CR> G
nnoremap <BS> gg
let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'
let mapleader = "\\"
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
map n <Plug>(easymotion-next)
map N <Plug>(easymotion-prev)
map / <Plug>(easymotion-sn)
map / <Plug>(easymotion-tn)
omap t <Plug>(easymotion-t1)
silent! AirlineRefresh
silent! delcommand Split3
command Split3 execute "vsplit | split"
silent! au BufWritePost $MYVIMRC
nnoremap <leader>ez :vsplit ~/.zshrc<CR>
nnoremap <leader>ev :vsplit $MYVIMRC<CR>
let g:hardtime_default_on = 1
map  <Leader>f <Plug>(easymotion-bd-f)
nmap <Leader>f <Plug>(easymotion-overwin-f)
au Filetype clojure nmap <c-c><c-k> :Require<cr>
