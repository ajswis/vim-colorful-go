syn cluster goTypes contains=goType,goSignedInts,goUnsignedInts,goFloats,goComplexes
syn cluster goNumber contains=goDecimalInt,goHexadecimalInt,goOctalInt,goFloat,goImaginary,goImaginaryFloat

if !exists("g:go_highlight_fields")
  let g:go_highlight_fields = 0
endif
if g:go_highlight_fields != 0
  syn match goField                 /\(\.\)\@<=\w\+\([.\ \n\r\:\)\[,+-\*\\\]]\)\@=/
endif

if !exists("g:go_highlight_functions")
  let g:go_highlight_functions = 0
endif
if g:go_highlight_functions != 0
  syn match goDeclaration          /\<func\>/ nextgroup=goReceiverRegion,goFunctionTagLine skipwhite skipnl
  syn region goReceiverRegion      matchgroup=ContainerChars start=/(/ end=/)/ contains=goReceiver nextgroup=goFunction contained
  syn match goReceiver             /\(\w\|[ *]\)\+/ contained contains=goReceiverVar skipwhite skipnl contained

  syn clear goFunctionCall
  syn clear goFunction

  syn cluster validFuncRegionContains contains=@goTypes,goField,goDeclaration,GoBuiltins,goDeclStruct,goDeclInterface,OperatorChars,ContainerChars,goString,goRawString,@goNumber

  syn match goFunctionTagLine       /\w\+(.\{-})\s*\((.\{-})\|\(\w\|\*\|\.\)\+\)\?/ nextgroup=goFunction contains=goFunction,goFunctionParamRegion,goFunctionReturnRegion,goFunctionReturn,OperatorChars,ContainerChars
  syn region goFunctionParamRegion  matchgroup=ContainerChars start=/(/ end=/)/ contains=@validFuncRegionContains nextgroup=goFunctionReturnRegion,goFunctionReturn contained
  syn region goFunctionReturnRegion matchgroup=ContainerChars start=/(/ end=/)/ contains=@validFuncRegionContains contained
  syn match goFunctionReturn        /\w\+/ contains=@goTypes,goField,goDeclaration,GoBuiltins,goDeclStruct,goDeclInterface,OperatorChars,ContainerChars skipwhite contained
  syn match goFunction              /\w\+\((\)\@=/  nextgroup=goFunctionParamRegion contained
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

  syn cluster validTypeContains          contains=goComment,goTypeField,goSTypeDefinition,goITypeDefinition,goString,goRawString,OperatorChars,ContainerChars
  syn cluster validStructContains        contains=goComment,goTypeField,goSTypeDefinition,goITypeDefinition,goString,goRawString,@goTypes,goDeclStructRegion,OperatorChars,ContainerChars
  syn cluster validInterfaceContains     contains=goComment,goFunctionTagLine,OperatorChars,ContainerChars

  syn match goTypeDecl                   /\<type\>/ nextgroup=goSTypeDefinition,goITypeDefinition,goTypeRegion skipwhite skipnl
  syn region goTypeRegion                matchgroup=ContainerChars start=/(/ end=/)/ contains=@validTypeContains fold contained
  syn region goDeclStructRegion          matchgroup=ContainerChars start=/{/ end=/}/ contains=@validStructContains fold contained
  syn region goDeclInterfaceRegion       matchgroup=ContainerChars start=/{/ end=/}/ contains=@validInterfaceContains fold contained

  syn match goTypeField                  /\w\+\s\+\(\*\|\[.\{-}\]\)*\(\w\|\.\)\+/ contains=goDeclTypeField,goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeFieldType skipwhite contained
  syn match goDeclTypeFieldPointerOp     /\*/ nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeFieldType skipwhite contained
  syn region goDeclTypeFieldSlice        matchgroup=ContainerChars start=/\[/ end=/\]/ contains=goDecimalInt,goHexadecimalInt,goOctalInt nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeFieldType skipwhite contained
  syn match goDeclTypeFieldType          /\(\w\+\s\+\(\*\|\[.\{-}\]\)*\)\@<=\(\w\|\.\)\+/ skipwhite contained
  syn match goDeclTypeField              /\w\+/ nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeFieldType skipwhite contained

  syn match goSTypeDefinition            /\w\+\s\+\(\*\|\[.\{-}\]\)*\<struct\>/ nextgroup=goDeclStructRegion contains=goSTypeName,goSTypeDefPointerOp,goSTypeDefSlice,goDeclStruct skipwhite skipnl contained
  syn match goSTypeName                  /\w\+/ nextgroup=goSTypeDefPointerOp,goSTypeDefSlice,goDeclStruct skipwhite contained
  syn match goSTypeDefPointerOp          /\*/ nextgroup=goSTypeDefPointerOp,goSTypeDefSlice,goDeclStruct skipwhite contained
  syn region goSTypeDefSlice             matchgroup=ContainerChars start=/\[/ end=/\]/ contains=goDecimalInt,goHexadecimalInt,goOctalInt nextgroup=goSTypeDefPointerOp,goSTypeDefSlice,goDeclStruct skipwhite contained
  syn match goDeclStruct                 /\<struct\>/ nextgroup=goDeclStructRegion skipwhite skipnl

  syn match goITypeDefinition            /\w\+\s\+\(\*\|\[.\{-}\]\)*\<interface\>/ nextgroup=goDeclInterfaceRegion contains=goITypeName,goITypeDefPointerOp,goITypeDefSlice,goDeclInterface skipwhite skipnl contained
  syn match goITypeName                  /\w\+/ nextgroup=goITypeDefPointerOp,goITypeDefSlice,goDeclInterface skipwhite contained
  syn match goITypeDefPointerOp          /\*/ nextgroup=goITypeDefPointerOp,goITypeDefSlice,goDeclInterface skipwhite contained
  syn region goITypeDefSlice             matchgroup=ContainerChars start=/\[/ end=/\]/ contains=goDecimalInt,goHexadecimalInt,goOctalInt nextgroup=goITypeDefPointerOp,goITypeDefSlice,goDeclInterface skipwhite contained
  syn match goDeclInterface              /\<interface\>/ nextgroup=goDeclInterfaceRegion skipwhite skipnl
endif

hi link goPointerOperator        Operator
hi link goITypeDefPointerOp      Operator
hi link goSTypeDefPointerOp      Operator
hi link goDeclTypeFieldPointerOp Operator

hi link goTypeConstructor        Type
hi link goTypeOpen               ContainerChars

hi link goSTypeName              Type
hi link goITypeName              Type
hi link goDeclTypeFieldType      Type

hi link goDeclInterface          Keyword
hi link goDeclStruct             Keyword

hi link goFunction               Function
hi link goMethodCall             Function
hi link goFunctionCall           Function
