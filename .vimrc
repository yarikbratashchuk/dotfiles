call plug#begin()
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
call plug#end()

syntax on

let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"

let g:go_decls_includes = "func,type"
let g:go_auto_sameids = 1
let g:go_info_mode = 'guru'
let g:go_auto_type_info = 1

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

set ruler
set rulerformat=%l,%v
set autowrite
set number
set background=dark
set updatetime=10
set lazyredraw
set hidden

set number relativenumber

colorscheme basic-dark

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

inoremap jk <ESC>
map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

nnoremap <silent> <leader>l :<C-u>call go#lint#Golint()<CR>
nnoremap <silent> <leader>v :<C-u>call go#lint#Vet(!g:go_jump_to_error)<CR>

autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

let g:go_highlight_function_arguments = 1
let g:go_highlight_function_calls = 1

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

noremap <Tab>j 15j
noremap <Tab>k 15k

hi Normal guibg=NONE ctermbg=NONE

" js config
autocmd Filetype javascript setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" html config
autocmd Filetype html setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
