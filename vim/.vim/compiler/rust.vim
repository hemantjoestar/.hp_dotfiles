if exists("current_compiler")
	finish
endif
let current_compiler = 'rust'
CompilerSet makeprg=cargo\ build
" CompilerSet errorformat=%f\|%l\ col\ %c\ %t\|\ %m


" let &efm = ''
" " Random non issue stuff

" let &efm .= '%-G%.%#aborting due to previous error%.%#,'
" let &efm .= '%-G%.%#test failed, to rerun pass%.%#,'
" " Capture enter directory events for doc tests
" let &efm .= '%D%*\sDoc-tests %f%.%#,'
" " Doc Tests
" let &efm .= '%E---- %f - %o (line %l) stdout ----,'
" let &efm .= '%Cerror%m,'
" let &efm .= '%-Z%*\s--> %f:%l:%c,'
" " Unit tests && `tests/` dir failures
" " This pattern has to come _after_ the doc test one
" let &efm .= '%E---- %o stdout ----,'
" let &efm .= '%Zthread %.%# panicked at %m\, %f:%l:%c,'
" let &efm .= '%Cthread %.%# panicked at %m,'
" let &efm .= '%+C%*\sleft: %.%#,'
" let &efm .= '%+Z%*\sright: %.%#\, %f:%l:%c,'
" " Compiler Errors and Warnings
" let &efm .= '%Eerror%m,'
" let &efm .= '%Wwarning: %m,'
" let &efm .= '%-Z%*\s--> %f:%l:%c,'
