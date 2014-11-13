" shell-profile-file
if has("syntax")
    syntax on
endif

if has("mac")
    let macvim_hig_shift_movement=1
endif

set nocompatible
set showmatch
set incsearch
set tabstop=4
set shiftwidth=4
set expandtab
set bs=2
set ruler

" TODO: update path on install
if filereadable(glob("~/.shell/vimrc.local")) 
    source ~/.shell/vimrc.local
endif
