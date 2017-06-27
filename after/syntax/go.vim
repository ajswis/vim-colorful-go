if !exists("g:go_highlight_fields")
  let g:go_highlight_fields = 0
endif
if g:go_highlight_fields != 0
  syn match goField                 /\(\.\)\@<=\w\+\([.\ \n\r\)\[,]\)\@=/
  " Match fields in type constructors
  syn match goField                 /\([{, ]\|\s\)\@<=\w\+\(:\)\@=/
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

hi link goReceiverOpen    ContainerChars
hi link goReceiverClose   ContainerChars
hi link goTypeOpen        ContainerChars

hi link goPointerOperator Operator

hi link goMethodCall   Function
hi link goFunctionCall Function
