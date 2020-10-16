hi StatusLine ctermbg=NONE cterm=NONE

syntax on
set number relativenumber
set wrap linebreak

set tabstop=2
set shiftwidth=2
set softtabstop=2
set noexpandtab
set smartindent
set smarttab

set laststatus=2
set statusline=
set statusline+=\ [%n]\ %t\ %F
set statusline+=\ %=
set statusline+=\ %{matchstr(getline('.'),\ '\\%'\ .\ col('.')\ .\ 'c.')}\ \%003b\ 0x\%02B
set statusline+=\ %l/%v\ %L\ %p%%
set statusline+=\ [%{strlen(&fenc)?&fenc:'none'}\ %{&ff}\ %Y]
set statusline+=\ %h%m%r%w
