set shiftwidth=2 tabstop=2 softtabstop=2 expandtab
set colorcolumn=80

" https://vim.fandom.com/wiki/Converting_variables_to_or_from_camel_case#:~:text=In%20Vim%2C%20move%20the%20cursor,case%20in%20the%20current%20line
" https://stackoverflow.com/questions/14387631/how-the-look-ahead-and-look-behind-concept-supports-such-zero-width-assertions-c
" https://stackoverflow.com/questions/6249172/delete-anything-other-than-pattern
" autocmd BufRead  *   exec "%s/\t/    /g"

" autocmd BufWritePost *.sh silent !sed -i 's/-\(\w\{2,\}\)/_\1/g' %
" autocmd BufWritePost *.sh silent !sed -i 's/\(\w\{2,\}\)-\(\w\{2,\}\)/\1_\2/g' %
autocmd BufWritePre *.sh :normal migg=G`izz
