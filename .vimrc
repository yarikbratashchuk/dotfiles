call plug#begin()
Plug 'Shougo/vimproc.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'autozimu/LanguageClient-neovim', {
	\ 'branch': 'next',
	\ 'do': 'bash install.sh',
	\ }
"Plug 'prabirshrestha/async.vim'
"Plug 'junegunn/fzf'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" C plugins
Plug 'rhysd/vim-clang-format'

" Go plugins
Plug 'fatih/vim-go', {
	\ 'do': ':GoInstallBinaries'
	\ }
Plug 'sebdah/vim-delve'

" Rust plugins
Plug 'rust-lang/rust.vim'
call plug#end()


" --------------
" Basic config
" --------------
set syntax=on
set ruler
set rulerformat=%l,%v
set autowrite
set number
set background=dark
set updatetime=10
set lazyredraw
set hidden
set number relativenumber

augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
inoremap jk <ESC>
nnoremap <leader>a :cclose<CR>
noremap <Tab>j 15j
noremap <Tab>k 15k

colorscheme basic-dark

hi Normal guibg=NONE ctermbg=NONE

let g:LanguageClient_serverCommands = {
	\ 'go': ['bingo'],
        \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls']
	\ }

nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gR :call LanguageClient#textDocument_rename()<CR>
"nnoremap fz :call LanguageClient_contextMenu()<CR>

let g:LanguageClient_diagnosticsSignsMax = 0
let g:LanguageClient_changeThrottle  = 10
let g:LanguageClient_hoverPreview = "Never"

nmap U viwU<esc>e


" --------------
" C code config
" --------------
let g:clang_format#code_style = "google"
let g:clang_format#auto_format=1
autocmd FileType c,cpp,proto ClangFormat


" --------------
" Go code config
" --------------
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_decls_includes = "func,type"
let g:go_def_mode='godef'
let g:go_auto_sameids = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_function_arguments = 1
let g:go_highlight_function_calls = 1
"let g:go_info_mode = 'guru'
"let g:go_auto_type_info = 1

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

function! s:build_go_files()
	let l:file = expand('%')
	if l:file =~# '^\f\+_test\.go$'
		call go#test#Test(0, 1)
	elseif l:file =~# '^\f\+\.go$'
		call go#cmd#Build(0)
	endif
endfunction

let g:delve_breakpoint_sign = '>>'
let g:delve_tracepoint_sign = '<<'


" --------------
" Rust code config
" --------------
let g:rustfmt_autosave = 1


" --------------
" Js/Html code config
" --------------
"autocmd Filetype javascript setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
"autocmd Filetype html setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
