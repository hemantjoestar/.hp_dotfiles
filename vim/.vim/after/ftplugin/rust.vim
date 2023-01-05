compiler rust
nnoremap <buffer> <F5> :silent Make!<CR>
let g:rustfmt_autosave = 1
setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi

" autocmd QuickFixCmdPost [^l]* nested cwindow
" autocmd QuickFixCmdPost    l* nested lwindow
function! DisableDebugMapping()
	unmap <F6>
endfunction
function! EnableDebugMapping()
	nnoremap <F6> :call SetBinaryDebug()<CR>
endfunction
call EnableDebugMapping()
function! DisableMaps()
	call DisableDebugMapping()
	unmap ]b
	unmap [b
endfunction
function! EnableMaps()
	call EnableDebugMapping()
	nnoremap [b :bprevious<CR>
	nnoremap ]b :bnext<CR>
endfunction

function! SetViewPort()
	let l:wdth= winwidth('%')
	let l:hight= winheight('%')
	if l:wdth > l:hight
		" wide
		exe "normal \<C-w>\<C-w>"
		exe "normal \<C-w>H"
		exe "normal \<C-w>l"
		exe "normal \<C-w>"
		exe "resize 7"
		exe "normal \<C-w>h"
	else
		" tall
		exe "normal \<C-w>\<C-w>"
		exe "normal \<C-w>"
		exe "resize 50"
		exe "normal \<C-w>\<C-w>"
		exe "normal \<C-w>"
		exe "resize 5"
		exe "normal \<C-w>r"
		exe "normal \<C-w>\<C-w>"
		exe "normal \<C-w>\<C-w>"
	endif
endfunction
function! SetBinaryDebug()
	call DisableMaps()
	let bpath = getcwd() . "/target/debug/" . substitute(getcwd(), '^.*/', '', '')
	" echo bpath
	packadd termdebug
	hi debugPC term=reverse ctermbg=darkblue guibg=darkblue
	hi debugBreakpoint term=reverse ctermbg=red guibg=red

	set nu
	set splitbelow
	let g:termdebugger="rust-gdb"
	" let g:termdebug_map_K = 0
	execute "Termdebug "
				\ bpath
	call SetViewPort()
endfunction

function! InsertBP()
	let linenum = line('.')
	let filename = expand('%:t')
	let bpstring = "b ".filename.':'.linenum
	" let l:foundline = search("# Breakpoints Start") " Can return 0 on no match
	let prevbuffer = expand('%')
	" check if bp already exists
	" let grepCommand = 'grep -q "'.bpstring.'" .gdbinit && echo 1'
	let grepCommand = 'grep -n "'.bpstring.'" .gdbinit | cut -d : -f 1'
	let bpAlreadyExists  = system(grepCommand)
	if bpAlreadyExists > 0
		" no need to open vim .gdbinit buffer
		" delete breakpoint
		echo "Found"
		" execute ":".bpAlreadyExists.'d'
		let sedCommand = "sed -i '/".filename.":".linenum."/,/end/d' .gdbinit"
		echo sedCommand
		let throwaway = system(sedCommand)
		" call TermDebug :Clear
		execute ":Clear"
	else
		echo "Not Found"
		" call TermDebug :Clear
		execute ":Break"
		let l:foundHeaderLine =system('grep -n "Breakpoints\ Start" .gdbinit | cut -d : -f 1')
		edit .gdbinit
		setlocal  bufhidden=hide noswapfile nobuflisted
		call append(l:foundHeaderLine, bpstring)
		" call writefile(["foo"], "event.log", "a")
		" below not used always also was causing problems when parsing to remove bps
		" resolved using sed
		call append(l:foundHeaderLine+1, "commands")
		call append(l:foundHeaderLine+2, "end")
		w
	endif
	" wierd workaround
	execute ":buffer ".prevbuffer
endfunction
function! EvaluateGDB()
	" need to do aplhanumeric check
	let l:word = expand('<cword>')
	call TermDebugSendCommand('p .l:word.')<CR>
	" Preapre String
endfunction
function TerminateGDBSession()
	call TermDebugSendCommand('q')
	call TermDebugSendCommand('y')
	call EnableMaps()
	set nonumber
endfunction
function! MapGDBMappings()
	nnoremap q :call TerminateGDBSession()<CR> 
	nnoremap n :call TermDebugSendCommand('n')<CR> 
	nnoremap s :call TermDebugSendCommand('s')<CR> 
	nnoremap c :call TermDebugSendCommand('c')<CR> 
	nnoremap r :call TermDebugSendCommand('r')<CR> 
	nnoremap y :call TermDebugSendCommand('y')<CR> 
	nnoremap B :call InsertBP()<CR> 
	nnoremap <C-l> :call TermDebugSendCommand('shell clear')<CR> 
endfunction
function! UnMapGDBMappings()
	unmap q
	unmap n
	unmap s
	unmap c
	unmap r
	unmap y
	" need b when traversing to :Evaluate
	unmap B
	unmap <C-l>
	set nonumber
endfunction
au User TermdebugStartPre :call MapGDBMappings()
au User TermdebugStopPost :call UnMapGDBMappings()

inoremap <C-p> <C-n>
inoremap  <expr><TAB> pumvisible()? "\<C-n>" : "\<TAB>"
inoremap  <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap  <expr>; pumvisible() ? "\<C-y>" : ";"
" cancel menu
inoremap  <expr><Esc> pumvisible() ? "\<C-e>" : "\<Esc>"

" set completeopt=menuone,preview,noselect,noinsert
set completeopt=menuone,noselect,noinsert

highlight PmenuSel ctermbg=white
highlight Pmenu ctermbg=blue
" Automatically place signs based on the quickfix list.
" https://gist.github.com/BoltsJ/5942ecac7f0b0e9811749ef6e19d2176

if exists('g:loaded_qfsign')
	finish
endif
let g:loaded_qfsign=1

sign define QFErr texthl=QFErrMarker text=E
sign define QFWarn texthl=QFWarnMarker text=W
sign define QFInfo texthl=QFInfoMarker text=I

augroup qfsign
	autocmd!
	autocmd QuickFixCmdPre [^l]* call s:clear_signs()
	autocmd QuickFixCmdPost [^l]* call s:place_signs()
augroup END

nnoremap <Plug>(QfSignPlace) :silent call <SID>place_signs()<CR>
nnoremap <Plug>(QfSignClear) :silent call <SID>clear_signs()<CR>

let s:sign_count = 0

function! s:place_signs() abort
	let l:errors = getqflist()
	for l:error in l:errors
		if l:error.bufnr < 0
			continue
		endif
		let s:sign_count = s:sign_count + 1
		if l:error.type ==# 'E'
			let l:err_sign = 'sign place ' . s:sign_count
						\ . ' line=' . l:error.lnum
						\ . ' name=QFErr'
						\ . ' buffer=' . l:error.bufnr
		elseif l:error.type ==# 'W'
			let l:err_sign = 'sign place ' . s:sign_count
						\ . ' line=' . l:error.lnum
						\ . ' name=QFWarn'
						\ . ' buffer=' . l:error.bufnr
		else
			let l:err_sign = 'sign place ' . s:sign_count
						\ . ' line=' . l:error.lnum
						\ . ' name=QFInfo'
						\ . ' buffer=' . l:error.bufnr
		endif
		silent! execute l:err_sign
	endfor
endfunction

function! s:clear_signs() abort
	while s:sign_count > 0
		execute 'sign unplace ' . s:sign_count
		let s:sign_count = s:sign_count - 1
	endwhile
	redraw!
endfunction



" autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!
let g:rust_use_custom_ctags_defs = 1
let g:tagbar_type_rust = {
			\ 'ctagsbin' : '/path/to/your/universal/ctags',
			\ 'ctagstype' : 'rust',
			\ 'kinds' : [
			\ 'n:modules',
			\ 's:structures:1',
			\ 'i:interfaces',
			\ 'c:implementations',
			\ 'f:functions:1',
			\ 'g:enumerations:1',
			\ 't:type aliases:1:0',
			\ 'v:constants:1:0',
			\ 'M:macros:1',
			\ 'm:fields:1:0',
			\ 'e:enum variants:1:0',
			\ 'P:methods:1',
			\ ],
			\ 'sro': '::',
			\ 'kind2scope' : {
			\ 'n': 'module',
			\ 's': 'struct',
			\ 'i': 'interface',
			\ 'c': 'implementation',
			\ 'f': 'function',
			\ 'g': 'enum',
			\ 't': 'typedef',
			\ 'v': 'variable',
			\ 'M': 'macro',
			\ 'm': 'field',
			\ 'e': 'enumerator',
			\ 'P': 'method',
			\ },
			\ }

function! s:FindWindowByBufferName(buffername)
	let l:windowNumberToBufnameList = map(range(1, winnr('$')), '[v:val, bufname(winbufnr(v:val))]')
	let l:arrayIndex = match(l:windowNumberToBufnameList, a:buffername)
	let l:windowNumber = windowNumberToBufnameList[l:arrayIndex][0]
	return l:windowNumber
endfunction

function! s:SwitchToWindowNumber(number)
	exe a:number . "wincmd w"
endfunction

function! SwitchToWindowByName(buffername)
	let l:windowNumber = s:FindWindowByBufferName(a:buffername)
	call s:SwitchToWindowNumber(l:windowNumber)
endfunction
" set omnifunc=ale#completion#OmniFunc
" let g:ale_completion_enabled = 1
" let g:ale_completion_autoimport = 1
" let g:ale_sign_column_always = 1
" let g:ale_fix_on_save = 1

" let g:ale_linters = {'rust': ['analyzer']}

" let g:ale_fixers = { 'rust': ['rustfmt', 'trim_whitespace', 'remove_trailing_lines']  }

" let g:ale_set_quickfix = 1
" let g:ale_open_list = 1

" " let g:ale_echo_msg_error_str = 'E'
" " let g:ale_echo_msg_warning_str = 'W'
" " let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" nnoremap gd :ALEGoToDefinition<CR>
" nnoremap gr :ALEFindReferences<CR>
" nnoremap gR :ALERename<CR>
" nnoremap K :ALEHover<CR>
