hi StatusLine ctermbg=0 cterm=NONE

syntax off
set number relativenumber

set tabstop=2
set autoindent
set smartindent

set laststatus=2
set statusline=
set statusline+=\ %t\ %F
set statusline+=\ %=
set statusline+=\ CHAR=[%{matchstr(getline('.'),\ '\\%'\ .\ col('.')\ .\ 'c.')}\ ASCII=\%003b\ HEX=0x\%02B]
set statusline+=\ POS=[ROW=%06l\ COl=%06v\ LINES=%06L\ %p%%]
set statusline+=\ INFO=[%{strlen(&fenc)?&fenc:'none'},\ %{&ff},\ %Y]
set statusline+=\ BUF=[%n]
set statusline+=\ %h%m%r%w
