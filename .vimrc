call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vimsence/vimsence'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'tmsvg/pear-tree'

call plug#end()

highlight CocHintFloat ctermfg=Red  guifg=#ff0000

:nnoremap <leader>rc :vsplit $MYVIMRC<cr>

command SW :execute ':silent w !sudo tee % > /dev/null' | :edit!

" evitar o shift quando detecta um erro
set signcolumn=yes
set showcmd
set showmatch
set smartcase
set autowrite
set mouse=a
map <leader><space> :let @/=''<cr> 

" permite numeros hibridos
set number
set relativenumber

syntax on

" alias :Wq = :wq
command! Wq wq
command! W w
command! WQ wq
command! Q q


" simplifica indexação
set tabstop=3
set shiftwidth=3
set softtabstop=3
set autoindent
set smartindent

set matchpairs+=<:>
set ttyfast

nnoremap j gj
nnoremap k gk

set laststatus=2
set encoding=utf-8

set hlsearch

""""""" Funções para o coc

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
  
" Trigger completion with tab
  " remap for complete to use tab and <cr>
inoremap <silent><expr> <TAB>
	  \ coc#pum#visible() ? coc#pum#next(1):
	  \ <SID>check_back_space() ? "\<Tab>" :
	  \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

"let g:coc_snippet_next = '<Tab>'
"let g:coc_snippet_prev = '<S-Tab>'

" Highlight search 
"hi CocSearch ctermfg=12 guifg=#18A3FF
"hi CocMenuSel ctermbg=109 guibg=#13354A

" Permite o uso de skeletons

augroup templates
	au!
	autocmd BufNewFile *.* silent! execute '0r $HOME/.vim/templates/skel.'.expand("<afile>:e")
augroup END

