set shiftwidth=2 tabstop=2 softtabstop=2 noexpandtab autoindent smartindent

" Automatically source .vimrc on save
augroup Vimrc
	autocmd!
	autocmd! bufwritepost init.vim source %
	autocmd BufWritePre *.vim :normal migg=G`i
augroup END
