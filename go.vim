if !exists("g:go_highlight_types")
  let g:go_highlight_types = 0
endif

" Some plugin is swallowing first braces. use this for now
" FIXME: Find meddling plugin
if g:go_highlight_types != 0
  syn match goTypeConstructor      /\<\w\+\({\)\@=/
endif

" I like green, ok? And these are functions.. not types. Jeez
hi def link goFunctionCall Function
hi def link goMethodCall   Function
