set background=dark     
set ts=4
set iminsert=0          
set ruler               
set ttyfast
set filetype=sh       
set nomodeline            
set scroll=15
set helplang=en         
set mouse=a             
set backspace=indent,eol,start
set fileencodings=ucs-bom,utf-8,default,latin1
set guifont=Monospace\ 11
set iskeyword=@,48-57,_,192-255,.
set printoptions=paper:letter
set termencoding=utf-8
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=
colorscheme murphy
set cindent shiftwidth=4
map <F2> :wn!<CR>
map <F3> :!ant -f netappbuild.xml src-compile <CR>
map <F4> :!ant -f netappbuild.xml run-unit-tests <CR>
map <F6> :tabp <CR>
map <F7> :tabn <CR>
map <F8> :%s/   /   /<CR>
map <F9> :%s/   /   /g<CR>
map <F12> :tabnew <CR>
map <F11> :tabclose <CR>
set expandtab
