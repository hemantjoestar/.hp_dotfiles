
" set makeprg=vyper\ %\ 2>&1\ \\\|\ sed\ \'s,\<unknown\>,%,'
if exists("current_compiler")
	finish
endif
let current_compiler = 'vyper'
CompilerSet makeprg=vyper\ %
CompilerSet errorformat=%E%.%#vyper.exceptions.UndeclaredDefinition:\ %m
CompilerSet errorformat+=%E%.%#vyper.exceptions.SyntaxException:\ %m
CompilerSet errorformat+=%E%.%#vyper.exceptions.TypeMismatch:\ %m
CompilerSet errorformat+=%E%.%#vyper.exceptions.FunctionDeclarationException:\ %m
CompilerSet errorformat+=%E%.%#vyper.exceptions.ArgumentException:\ %m
CompilerSet errorformat+=%E%.%#vyper.exceptions.UnknownType:\ %m
CompilerSet errorformat+=%E%.%#vyper.exceptions.VariableDeclarationException:\ %m
CompilerSet errorformat+=%E%.%#vyper.exceptions.InvalidType:\ %m
" dont catch this all ways come unable to handle it now
" CompilerSet errorformat+=%E%.%#vyper.exceptions.VyperException:\ %m
CompilerSet errorformat+=%E%.%#UndeclaredDefinition:\ %m
" vyper.exceptions.SyntaxException: invalid syntax (<unknown>, line 4)
CompilerSet errorformat+=%E%.%#vyper.exceptions.SyntaxException:\ %m%.%#\/%f,\ line\ %l
CompilerSet errorformat+=%E%.%#ArgumentException:\ %m
CompilerSet errorformat+=%E%.%#FunctionDeclarationException:\ %m
CompilerSet errorformat+=%E%.%#NamespaceCollision:\ %m
CompilerSet errorformat+=%E%.%#StructureException:\ %m
CompilerSet errorformat+=%E%.%#IndentationError:\ %m%.%#line\ %l%.%#
CompilerSet errorformat+=%E%.%#IndentationError:\ %m
CompilerSet errorformat+=%E%.%#InvalidReference:\ %m
CompilerSet errorformat+=%E%.%#TypeMismatch:\ %m
CompilerSet errorformat+=%Z%.%#File\ %.%#line\ %l
CompilerSet errorformat+=%Z%.%#contract\ \"%f\"%.%#line\ %l:%c%.%#
CompilerSet errorformat+=%-G%.%#
" let &errorformat = 
"     \ '%E%.%#vyper.exceptions.ArgumentException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.CallViolation:\ %m,' .
"     \ '%E%.%#vyper.exceptions.ArrayIndexException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.EventDeclarationException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.EvmVersionException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.FunctionDeclarationException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.ImmutableViolation:\ %m,' .
"     \ '%E%.%#vyper.exceptions.InterfaceViolation:\ %m,' .
"     \ '%E%.%#vyper.exceptions.InvalidAttribute:\ %m,' .
"     \ '%E%.%#vyper.exceptions.InvalidLiteral:\ %m,' .
"     \ '%E%.%#vyper.exceptions.InvalidOperation:\ %m,' .
"     \ '%E%.%#vyper.exceptions.InvalidReference:\ %m,' .
"     \ '%E%.%#vyper.exceptions.InvalidType:\ %m,' .
"     \ '%E%.%#vyper.exceptions.IteratorException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.JSONError:\ %m,' .
"     \ '%E%.%#vyper.exceptions.NamespaceCollision:\ %m,' .
"     \ '%E%.%#vyper.exceptions.NatSpecSyntaxException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.NonPayableViolation:\ %m,' .
"     \ '%E%.%#vyper.exceptions.OverflowException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.StateAccessViolation:\ %m,' .
"     \ '%E%.%#vyper.exceptions.StructureException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.TypeMismatch:\ %m,' .
"     \ '%E%.%#vyper.exceptions.UndeclaredDefinition:\ %m,' .
"     \ '%E%.%#vyper.exceptions.VariableDeclarationException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.VersionException:\ %m,' .
"     \ '%E%.%#vyper.exceptions.ZeroDivisionException:\ %m,' .
