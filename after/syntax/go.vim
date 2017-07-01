syn cluster goTypes contains=goType,goSignedInts,goUnsignedInts,goFloats,goComplexes
syn cluster goNumber contains=goDecimalInt,goHexadecimalInt,goOctalInt,goFloat,goImaginary,goImaginaryFloat

if !exists("g:go_highlight_fields")
  let g:go_highlight_fields = 0
endif
if g:go_highlight_fields != 0
  syn match goField                 /\(\.\)\@1<=\w\+\([.\ \n\r\:\)\[,+-\*\\\]]\)\@=/
endif

if !exists("g:go_highlight_functions")
  let g:go_highlight_functions = 0
endif
if g:go_highlight_functions != 0
  syn clear goFunctionCall
  syn clear goFunction

  syn match goDeclaration          /\<func\>/ nextgroup=goReceiverRegion,goFunction skipwhite skipnl
  syn region goReceiverRegion      matchgroup=ContainerChars start=/(/ end=/)/ contains=goReceiver nextgroup=goFunction contained
  syn match goReceiver             /\(\w\|[ *]\)\+/ contained contains=goReceiverVar skipwhite skipnl contained

  syn cluster validFuncRegionContains contains=@goTypes,goField,goDeclaration,GoBuiltins,goDeclStruct,goDeclInterface,OperatorChars,ContainerChars,goString,goRawString,@goNumber,goTypeConstructor

  " fix comment
  syn match goFunctionTagLine       /\w\+(.\{-})\(\s*(.\{-})\|\s\S\+\)\?\(\s*\|$\)/ nextgroup=goFunction contains=goFunction,goFunctionParamRegion,goFunctionReturnRegion,goFunctionReturn,OperatorChars,ContainerChars,goComment
  syn region goFunctionParamRegion  matchgroup=ContainerChars start=/(/ end=/)/ contains=@validFuncRegionContains nextgroup=goFunctionReturnRegion,goFunctionReturn skipwhite contained
  syn region goFunctionReturnRegion matchgroup=ContainerChars start=/(/ end=/)/ contains=@validFuncRegionContains skipwhite contained
  syn match goFunctionReturn        /\w\+/ contains=@validFuncRegionContains skipwhite contained
  syn match goFunction              /\w\+\ze(/ nextgroup=goFunctionParamRegion skipwhite contained
endif

if !exists("g:go_highlight_types")
  let g:go_highlight_types = 0
endif
if g:go_highlight_types != 0
  syn match goTypeConstructor      /\<\w\+{/he=e-1 contains=goTypeOpen
  syn match goTypeOpen             /{/ contained
  "syn match goTypeClose            /}/ contained

  " TODO (maybe): handle only Type-highlighting things like xml.Name ignoring
  " the first \w+\. and highlighting the remaining \w+
  "
  " This is most likely bad... probably very bad.. and brittle?
  syn clear goTypeDecl
  syn clear goTypeName
  syn clear goDeclType

  syn cluster validTypeContains          contains=goComment,goNewDeclType,goDeclTypeField,goDeclTypeFieldType,goDeclTypeFieldSlice,goDeclTypeFieldPointerOp,goString,goRawString,OperatorChars,ContainerChars
  syn cluster validStructContains        contains=goComment,goNewDeclType,goDeclTypeField,goDeclTypeFieldType,goString,goRawString,OperatorChars,ContainerChars
  syn cluster validInterfaceContains     contains=goComment,goFunctionTagLine,OperatorChars,ContainerChars

  syn match goTypeDecl                   /\<type\>/ nextgroup=goNewDeclType,goTypeRegion skipwhite skipnl
  syn region goTypeRegion                matchgroup=ContainerChars start=/(/ end=/)/ contains=@validTypeContains fold contained
  syn region goDeclStructRegion          matchgroup=ContainerChars start=/{/ end=/}/ contains=@validStructContains fold contained
  syn region goDeclInterfaceRegion       matchgroup=ContainerChars start=/{/ end=/}/ contains=@validInterfaceContains fold contained

  syn match goDeclTypeFieldPointerOp     /\*/ nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeFieldType,goDeclStruct,goDeclInterface skipwhite contained
  syn region goDeclTypeFieldSlice        matchgroup=ContainerChars start=/\[/ end=/\]/ contains=goDecimalInt,goHexadecimalInt,goOctalInt nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeFieldType,goDeclStruct,goDeclInterface skipwhite contained
  syn match goDeclTypeFieldType          /\(\w\|\.\)\+/ skipwhite contained
  syn match goDeclTypeField              /\w\+/ nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeFieldType skipwhite contained
  syn match goNewDeclType                /\w\+\ze\s\+\<\(struct\|interface\)\>/ nextgroup=goDeclStruct,goDeclInterface skipwhite contained

  syn match goDeclStruct                 /\<struct\>/ nextgroup=goDeclStructRegion skipwhite skipnl
  syn match goDeclInterface              /\<interface\>/ nextgroup=goDeclInterfaceRegion skipwhite skipnl
endif

hi link goPointerOperator        Operator
hi link goDeclTypeFieldPointerOp Operator

hi link goTypeConstructor        Type
hi link goTypeOpen               ContainerChars

hi link goDeclTypeFieldType      Type
hi link goNewDeclType            Type

hi link goDeclInterface          Keyword
hi link goDeclStruct             Keyword

hi link goFunction               Function
hi link goMethodCall             Function
hi link goFunctionCall           Function
