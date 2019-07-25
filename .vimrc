"Config
set nocompatible
syntax on
filetype off
set number
set background=dark
set noshowmode
set t_Co=256
set laststatus=2

set rtp+=~/.vim/bundle/Vundle.vim "Vundle (required)
call vundle#begin() "Vundle (required)

"Vundle plugin (Install with `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`)
Plugin 'VundleVim/Vundle.vim' "Vundle (required)

"Plugins
Plugin 'itchyny/lightline.vim'

"Colorschemes
Plugin 'morhetz/gruvbox'

call vundle#end() "Vundle (required)
filetype plugin indent on "Vundle (required)

"Colorscheme choice for vim
colorscheme gruvbox

"Colorscheme choice for lightline plugin
let g:lightline = { 'colorscheme': 'gruvbox', }
