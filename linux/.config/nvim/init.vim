syntax off
set number relativenumber

set tabstop=2
set autoindent
set smartindent

hi StatusLine ctermbg=0 cterm=NONE
set statusline=
set statusline+=\ %=
set statusline+=\ %cx%l/%L[%p%%]
set statusline+=\ Buf:%n
set statusline+=\ [%b][0x%B]
