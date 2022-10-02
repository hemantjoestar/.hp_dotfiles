set shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent smartindent
compiler vyper

"nnoremap <buffer> <F5> :silent Make<CR>
nnoremap <buffer> <F5> :silent make \| :redraw!<CR>

autocmd BufWritePre *.vy silent! :call OnSave()<CR> 

function! OnSave()
	normal mi
	call FormatVars()
	normal `i
endfunction
setlocal commentstring=#\ %s
set colorcolumn=80

setlocal complete+=k
setlocal dictionary+=~/.config/nvim/after/ftplugin/vyper-completions.txt

setlocal iskeyword+=@-@
setlocal iskeyword+=. " msg.sender etc."

" insert interface from file
" :IVCI SimpleStorage.vy
" TODO: keep track if contract already added
function! InsertVyperContractInterface(contractFilePath)
	echom a:contractFilePath
	" echom "InsertVyperContractInterface called"
	" check if file exists
	" https://stackoverflow.com/questions/3098521/how-to-detect-if-a-specific-file-exists-in-vimscript
	if filereadable(a:contractFilePath)
		" 2read! vyper -f external_interface SimpleStorage.vy | sed '/^[[:space:]]*$/d'
		execute("2read! vyper -f external_interface ".a:contractFilePath." | sed '/^[[:space:]]*$/d'")
		normal o
		" let vyperContractName = substitute(a:contractFilePath,'\v^(\w+)\.vy','\1',"")
		" let vyperContractName = substitute(a:contractFilePath,'\v(\/|^)@<=(\w+)\.vy$','\2',"")
		let vyperContractName = matchstr(a:contractFilePath,'\v(\/|^)@<=[a-zA-Z0-9]+\.vy$')->substitute('\v^(\w+)(\.vy)','\1','')
		echom vyperContractName
		put = vyperContractName.'ContractInstance: '.vyperContractName.'ContractInterface'

		" find default interface declaration and eplace with new reference
		execute '%s/\v^interface\s('.vyperContractName.'):$/interface '.vyperContractName.'ContractInterface:/'
		" remove storage vars from imported interface
		%s/\v.*arg0.*//
		" above matches the some emtyline to delete
		" remove only multi blank lines (reduce them to a single blank line) and leaving single blank lines intact:
		" :g/^$/,/./-j
		g/^\_$\n\_^$/d
	else
		echo "couldnt find file"
		return
	endif
endfunction
command! -buffer -nargs=1 -complete=file_in_path IVCI call InsertVyperContractInterface(<q-args>)

" inoremap <expr> : FormatVars() \| Testchain()
" inoremap : :call FormatVars()
command! -buffer FV call FormatVars()

function! FormatVars()

	echom " start formatting"
	" Do first because rest depend 
	call ReplaceKebab()
	call FormatAssignment()
	call FormatOperators()
	call FormatTypeDeclarator()
	call FormatReturnArrow()

	call FormatConstantsDeclaration()
	call FormatStructDeclaration()
	call FormatInsideRoundBracket()

	echom " end formatting"
endfunction


" to work in tandem with indent
nmap <buffer> o <S-a><CR>
inoremap <buffer> <expr> <CR> ShouldIndent()

function! ShouldIndent()
	if match(getline('.'),'\v^struct\s.+:') == 0
		return "\<CR>\<TAB>"
	elseif match(getline('.'),'\v^def\s.+:') == 0
		return "\<CR>\<TAB>pass"
	elseif getline('.') =~ '^\s*$'
		" echom getpos('.')
		if getpos('.')[2] != 1
			echom "emptyline"
			return "\<BS>"
		endif
		echom "default-1"
		return "\<CR>"
	else
		echom "default"
		return "\<CR>"
	endif
endfunction

function! FormatInsideSquareBracket()

	%s/\v\s*,\s*(\w+)/, \1/g
endfunction

function! FormatInsideRoundBracket()
	" some wired bracket thing also getting selected
	%s/\v(\()(\s+)/\1/g
	" %s/\v\s+(\))/\1/g
	" need \n\s+
	" %s/\v\s*(\))\s*(:|\n\s+|\n)\s*/\1\2/
	%s/\v\s*,\s*(\w+)/, \1/g
	" https://stackoverflow.com/questions/2510859/vim-search-replace-spaces-between-2-brackets-or-columns
	%s/\v^def\s\w+\(.+\)/\=substitute(submatch(0),'\v(\(|,\s)(_)@<!([a-zA-Z0-9]+:)','\1_\3','g')/g
	" s/\v\(.+\)/\=substitute(submatch(0),'\v(\(|,\s)(_)@<!([a-zA-Z0-9]*)','\1_\3','g')/g
endfunction
function! FormatAssignment()
	" accomodate for += etc
	%s/\v(\s*(\+|-|\.)@<!\=\s*)/ = /g
endfunction

function! FormatOperators()
	%s/\v(\s*\=\=\s*)/ == /g
	%s/\v(\s*\<\s*)/ < /g
	" to prevent conflict with arrow operator
	%s/\v(\s*(-)@<!\>\s*)/ > /g
	%s/\v(\s*\<\=\s*)/ <= /g
	%s/\v(\s*\>\=\s*)/ >= /g
	%s/\v(\s*\!\=\s*)/ != /g
endfunction

function! FormatReturnArrow()
	%s/\v(\s*-\>\s*)/ -> /g
endfunction

function! FormatTypeDeclarator()
	" remove trailing whitespace
	%s/\v(\s+$)//
	%s/\v(\s*:\s*)(\n)@!/: /g
endfunction

function! FormatConstantsDeclaration()
	" \e to make rest to lower case
	%s/\v^(\w+):\sconstant/\U\1\e: constant/
	" seek and replace??
endfunction

function! FormatStructDeclaration()
	%s/\v^struct\s(\w+):/struct \u\1:/g
	" seek and replace??
endfunction

function! ReplaceKebab()
	%s/\v-(\w+)/\u\1/g
	" %s/\v(-\w+)@=:/\U\1/g
	" %s/\v(-\w+)(:|-\w+)@=/\U\1/g
	" %s/\v(-\w+)(:|-\w+)@=/\u\1/g
	" %s/\v(^\s+\w+-|^\w+-|)@<=(\w+)(:|-\w+)@=/\u\2/g
endfunction

function! InsertCompilerVersion()
	let vy_version = system('vyper --version | grep -Po "^(.*)(?=\+commit)"' )
	" let vy_version = exec 'r!vyper --version' 
	" echom vy_version
	let version_string = "# @version "
	let version_string .= vy_version
	" echom version_string
	call append(0,[version_string])
	" to remove null character /caret notation
	%s/[\x0]//g
	" put=version_string
	" echom "vy_version"
endfunction
command! -buffer ICV call InsertCompilerVersion()
augroup VyperSuggestionBindings
	autocmd!

	inoremap <C-p> <C-n>

	inoremap <buffer> <expr> <TAB> pumvisible()? "\<C-n>" : "\<TAB>"
	inoremap <buffer> <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	inoremap <buffer> <expr> <C-o> pumvisible() ? "\<C-y>" : "<C-o><ESC>"
	" cancel menu
	inoremap <buffer> <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

augroup END

" inoremap <expr> <CR> InsertMapForEnter()
function! InsertMapForEnter()
	if pumvisible()
		return "\<C-y>"
	elseif strcharpart(getline(getpos('.')[1]),getpos('.')[2]-3)== '):'
		return "\<CR>\<TAB>"
	else
		return "\<CR>"
	endif
endfunction
" let pattern_1 = '\v-(.*)'
" " let pattern_1 = '\(.*\)-\(.*\):'
" let substitute_1 = '\u\1'
" let flags = ""
" let line = getline('.')
" " let repl = substitute(line, pattern_1, substitute_1, flags)
" let repl = substitute(getline('.'), '\v-(.*)', '\u\1', "")
" call setline('.', repl)
" call setline('.', substitute(getline('.'), '\v-(.*)', '\u\1', ""))
" echom repl[0]
" call deletebufline(bufname(),1)
" function! FormatVars()
" 	" let t=[] | %s/\v\s*(.*-.*):\zs/\=add(t,submatch(1))[1:0]/ng | echo t | let tnew = substitute(t[0],'\v(.*)-(.*)','\1\u\2',"") | echo tnew | execute '%s/'.tmp.'/'.tnew.'/g'
" 	let vars_inside_struct = []
" 	%s/\v^\s+(\w+-\w+):\zs/\=add(vars_inside_struct,submatch(1))[1:0]/ng 
" 	" %s/\v-(\w+)(:|-\w+)@=/\=add(vars_inside_struct,submatch(1))[1:0]/ng 
" 	call uniq(vars_inside_struct)
" 	echom vars_inside_struct

" 	for i in range(len(vars_inside_struct))
" 		let tnew = substitute(vars_inside_struct[i],'\v(.*)-(.*)','\1\u\2',"") 
" 		echom tnew
" 		execute '%s/'.vars_inside_struct[i].'/'.tnew.'/g'
" 	endfor
" endfunction

function! Testchain()
	echom "testchain"
endfunction
