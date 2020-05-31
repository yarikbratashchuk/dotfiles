"lugs {{{
call plug#begin()

Plug 'preservim/nerdtree'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'majutsushi/tagbar'
"Plug 'vim-syntastic/syntastic'

" C plugins
Plug 'rhysd/vim-clang-format'

" Go plugins
Plug 'sebdah/vim-delve'
Plug 'fatih/vim-go', {
			\ 'do': ':GoInstallBinaries'
			\ }

" Rust plugins
Plug 'rust-lang/rust.vim'
Plug 'arzg/vim-rust-syntax-ext'

" Exercism
Plug 'junegunn/vader.vim'

call plug#end()
"}}}


" CtrlP config {{{
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_working_path_mode = 'ra'
"}}}


" Basic config {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

set rulerformat=%22(%l,%c%V\ %o\ %p%%%)
set path=./*
set syntax=on
set magic
set synmaxcol=200
set encoding=utf-8
set ruler rulerformat=%l,%v smartindent
set autowrite
set number
set background=dark
set updatetime=10
set lazyredraw
set hidden
set number relativenumber
set noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
"set textwidth=80 formatoptions-=t formatoptions+=j
filetype plugin indent on 

augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
inoremap jk <ESC>
nnoremap fo :grep <cword> ./**/*.go<CR>
nnoremap <leader>a :cclose<CR>
nnoremap tt :TagbarToggle<CR><C-w>l
nnoremap tn :NERDTreeToggle<CR>

nmap U viwU<esc>e

augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

colorscheme basic-dark
hi Normal guibg=NONE ctermbg=NONE
"}}}


" C code config {{{
"let g:clang_format#code_style = "google"
"let g:clang_format#auto_format=1
"autocmd FileType c,cpp,proto ClangFormat
" }}}


" Go code config {{{
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

if executable('go-langserver')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'go-langserver',
				\ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
				\ 'whitelist': ['go'],
				\ })
	"autocmd BufWritePre *.go LspDocumentFormatSync
endif

" }}}


" Rust code config {{{
let g:rustfmt_autosave = 1

if executable('rls')
	au User lsp_setup call lsp#register_server({
				\ 'name': 'rls',
				\ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
				\ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
				\ 'whitelist': ['rust'],
				\ })
endif
" }}}


" Js/Html code config {{{
"autocmd Filetype javascript 
"	\setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
"autocmd Filetype html 
"	\ setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
" }}}


" registering lsp {{{
function! s:on_lsp_buffer_enabled() abort
	setlocal omnifunc=lsp#complete
	setlocal signcolumn=yes
	if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
	nmap <buffer> gd <plug>(lsp-definition)
	nmap <buffer> <f2> <plug>(lsp-rename)
endfunction

augroup lsp_install
	au!
	autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }}}


" exercism {{{
function! s:exercism_tests()
	if expand('%:e') == 'vim'
		let testfile = printf('%s/%s.vader', expand('%:p:h'),
					\ tr(expand('%:p:h:t'), '-', '_'))
		if !filereadable(testfile)
			echoerr 'File does not exist: '. testfile
			return
		endif
		source %
		execute 'Vader' testfile
	else
		let sourcefile = printf('%s/%s.vim', expand('%:p:h'),
					\ tr(expand('%:p:h:t'), '-', '_'))
		if !filereadable(sourcefile)
			echoerr 'File does not exist: '. sourcefile
			return
		endif
		execute 'source' sourcefile
		Vader
	endif
endfunction

autocmd BufRead *.{vader,vim}
			\ command! -buffer Test call s:exercism_tests()
" }}}
