"Plugs {{{
call plug#begin()

Plug 'preservim/nerdtree'
nnoremap tn :NERDTreeToggle<CR>

Plug 'majutsushi/tagbar'
nnoremap tt :TagbarToggle<CR><C-w>l

Plug 'prabirshrestha/async.vim'

Plug 'autozimu/LanguageClient-neovim', {
			\ 'branch': 'next',
			\ 'do': 'bash install.sh',
			\ }

Plug 'AndrewRadev/splitjoin.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'

" Go plugins
Plug 'Shougo/vimshell.vim'
Plug 'Shougo/vimproc.vim'
Plug 'sebdah/vim-delve'
Plug 'fatih/vim-go', {
			\ 'do': ':GoInstallBinaries'
			\ }

" Rust plugins
Plug 'arzg/vim-rust-syntax-ext'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'

call plug#end()
"}}}


" CtrlP config {{{
set wildignore+=*/vendor/*,*/tmp/*,*.so,*.swp,*.zip

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
			\ 'dir': '\.git$|vendor$\|\.hg$\|\.svn$\|\.yardoc\|public\/images\|public\/system\|data\|log\|tmp$',
			\ 'file': '\.exe$\|\.so$\|\.dat$'
			\ }
"}}}


" Basic config {{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

function! GitBranch()
	return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
	let l:branchname = GitBranch()
	return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\

filetype plugin indent on
"set ignorecase
"set smartcase
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
set updatetime=1000
set lazyredraw
set hidden
set number relativenumber
set noexpandtab tabstop=8 softtabstop=8 shiftwidth=8
set cursorline

augroup numbertoggle
	autocmd!
	autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
	autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
inoremap jk <ESC>
nnoremap <leader>a :cclose<CR>

nmap U viwU<esc>e

augroup filetype_vim
	autocmd!
	autocmd FileType vim setlocal foldmethod=marker
augroup END

set t_Co=256
colorscheme nnkd
hi Normal guibg=NONE ctermbg=NONE
"}}}


" Go code config {{{
let g:go_fmt_command = "goimports"
let g:go_list_type = "quickfix"
let g:go_decls_includes = "func,type"
"let g:go_def_mode='guru'
"let g:go_auto_sameids = 1
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
let g:go_auto_type_info = 1

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

"autocmd FileType go colorscheme basic-dark
" }}}


" Rust code config {{{
let g:rustfmt_autosave = 1

let g:racer_cmd = "/Users/yarik/.cargo/bin/racer"
"}}}



" registering lsp {{{
let g:LanguageClient_serverCommands = {
			\ 'rust': ['rust-analyzer'],
			\ 'python': ['/usr/local/bin/pyls'],
			\ }

"nnoremap <silent> gd :call LanguageClient#textDocument_definition({'gotoCmd': 'split'})<CR>
nnoremap <silent> sgd :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
" }}}
