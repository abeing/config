set nocompatible
filetype plugin on
syntax on
let g:vimwiki_list=[{'path': '~/memex/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_conceallevel=0
" Configure the GUI font (used by MacVim)
set guifont=Iosevka\ SS08:h14
" Configure gruvbox 
" Background override, otherwise MacVim will use the system default theme
" to determine light or dark background mode.
" set background=dark
autocmd vimenter * ++nested colorscheme gruvbox
