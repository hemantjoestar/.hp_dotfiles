set shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent smartindent
set colorcolumn=97

nnoremap * *:%s/<C-r>//
set iskeyword+=- "personal preference"

setlocal spellfile=~/.vim/spell/crypto.utf-8.add
setlocal spelllang=en_us
setlocal nospell


"provide completion only from tags for first line
function! SetComplete()
	if getpos('.')[1] == 1
		" echom "on line 1" 
		setlocal complete=t
	else
		setlocal complete=.,kspell
	endif
endfunction
autocmd CursorMoved  <buffer> :call SetComplete()

augroup vimwikiBindings
	autocmd!

	" trouble maker for vimwiki
	" autocmd BufWritePre *.wiki :normal migg=G`i
	"
	" here since vimwiki overwrites <CR> from init.vim with its own bindings
	inoremap <C-p> <C-n>

	inoremap <buffer> <expr> <TAB> pumvisible()? "\<C-n>" : "\<TAB>"
	inoremap <buffer> <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	inoremap <buffer> <expr> <C-o> pumvisible() ? "\<C-y>" : "<Space>"
	" cancel menu
	inoremap <buffer> <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

augroup END

" tags settings... override default complete settings and read only from
" generated .vimwiki.tags

"set complete=t,.


"autocmd BufRead,BufNewFile diary.wiki VimwikiDiaryGenerateLinks
"autocmd BufWritePost *.wiki silent !~/.config/nvim/myscripts/format_tags_proper.sh %
"autocmd BufWritePost *.wiki :set spell

