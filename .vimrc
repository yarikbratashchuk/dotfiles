call plug#begin()

Plug 'junegunn/vader.vim'
Plug 'chriskempson/base16-vim'

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
"Plug 'rust-lang/rust.vim'
call plug#end()


" Basic config {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

set mouse=
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
set textwidth=80 formatoptions-=t formatoptions+=j
set foldmethod=syntax
set foldlevel=5
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
inoremap <F8> Yarik Bratashchuk <yarik.bratashchuk@gmail.com>

colorscheme basic-dark

hi Normal guibg=NONE ctermbg=NONE

let g:LanguageClient_serverCommands = {
			\ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
			\ 'go': ['bingo'],
			\ 'python': ['pyls'],
			\ }

nnoremap <silent> gr :call LanguageClient#textDocument_references()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> gR :call LanguageClient#textDocument_rename()<CR>
"nnoremap fz :call LanguageClient_contextMenu()<CR>

let g:LanguageClient_diagnosticsSignsMax = 0
let g:LanguageClient_changeThrottle  = 10
let g:LanguageClient_hoverPreview = "Never"

nmap U viwU<esc>e
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
" }}}

" Rust code config {{{
"let g:rustfmt_autosave = 1
" }}}

" Js/Html code config {{{
"autocmd Filetype javascript 
"	\setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
"autocmd Filetype html 
"	\ setlocal tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab
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

" wpm {{{
function! s:wpm() abort
	if get(b:, 'wpm_start', 0) is 0 
		let b:wpm_start = [reltime(), wordcount().chars]
	else
		let l:time_past = reltimefloat(reltime(b:wpm_start[0]))
		let l:char_count = wordcount().chars - b:wpm_start[1]
		unlet b:wpm_start
		echom printf("WPM: %f", ((l:char_count/l:time_past)*12))
	endif
endfunction

augroup wpm
	autocmd!
	autocmd InsertEnter * :call s:wpm()
	autocmd InsertLeave * :call s:wpm()
augroup end
" }}}
