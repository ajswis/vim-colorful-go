if !exists("g:go_highlight_fields")
  let g:go_highlight_fields = 0
endif
if g:go_highlight_fields != 0
  syn match goField                 /\(\.\)\@<=\w\+\([.\ \n\r\:\)\[,]\)\@=/
endif

if !exists("g:go_highlight_functions")
  let g:go_highlight_functions = 0
endif
if g:go_highlight_functions != 0
  syn match goReceiver          /(\(\w\|[ *]\)\+)/ contained nextgroup=goFunction contains=goReceiverOpen,goReceiverVar,goReceiverClose skipwhite skipnl
  syn match goReceiverOpen      /(/ contained
  syn match goReceiverClose     /)/ contained
endif

if !exists("g:go_highlight_types")
  let g:go_highlight_types = 0
endif
if g:go_highlight_types != 0
  syn match goTypeConstructor      /\<\w\+{/he=e-1 contains=goTypeOpen
  syn match goTypeOpen             /{/ contained

  " Redefine so interface and struct isn't falsely matched as a type constructor
  syn match goDeclType             /\<\(interface\|struct\)\>/ skipwhite skipnl
endif

hi link goReceiverOpen    Operator
hi link goReceiverClose   Operator
hi link goPointerOperator Operator
hi link goTypeOpen        Operator

hi link goMethodCall   Function
hi link goFunctionCall Function
