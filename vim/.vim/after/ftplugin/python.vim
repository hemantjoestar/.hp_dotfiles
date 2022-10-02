" python stuff
set suffixesadd=.py             " Look for Python files.
set wildignore=*.pyc                " Ignore pyc files.
setlocal completeopt-=preview
let g:netrw_list_hide= '.*\.pyc$'   " Hide pyc files from file lists.
" Format
autocmd FileType python nnoremap <leader>y :0,$!blapf<cr><C-o>
" Lint
autocmd FileType python map <buffer> <leader>f :call Flake8()<cr>
" Import
autocmd FileType python map <leader>i :Isort<cr>
command! -range=% Isort :<line1>,<line2>! isort -

let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command = "<leader>s"
let g:jedi#goto_definitions_command = "gd"
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = "<C-p>"
let g:jedi#rename_command = "<leader>r"


if executable('black')
	use for formatprg insted of formatexpr
	setlocal formatprg='black -q -'
	setlocal formatexpr=
endif
" lua << EOF
" require("lspconfig").pylsp.setup{}
" EOF

" " use omni completion provided by lsp
" autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
" " autocmd Filetype python setlocal completeopt-=preview

" nnoremap <buffer> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <buffer> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
" nnoremap <buffer> K     <cmd>lua vim.lsp.buf.hover()<CR>
" nnoremap <buffer> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <buffer> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <buffer> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <buffer> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <buffer> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <buffer> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
" nnoremap <buffer> <space>f    <cmd>lua vim.lsp.buf.formatting()<CR>
