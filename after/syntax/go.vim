syn cluster goTypes contains=goType,goSignedInts,goUnsignedInts,goFloats,goComplexes
syn cluster goNumber contains=goDecimalInt,goHexadecimalInt,goOctalInt,goFloat,goImaginary,goImaginaryFloat

if !exists("g:go_highlight_fields")
  let g:go_highlight_fields = 0
endif
if g:go_highlight_fields != 0
  syn match goField                 /\(\.\)\@1<=\w\+\([.\ \n\r\:\)\[,+-\*}\\\]]\)\@=/
endif

if !exists("g:go_highlight_types")
  let g:go_highlight_types = 0
endif
if g:go_highlight_types != 0
  syn match goTypeConstructor      /\<\w\+\({\)\@1=/

  " TODO: handle nested interface types

  " This is most likely bad... probably very bad.. and brittle?
  syn clear goTypeDecl
  syn clear goTypeName
  syn clear goDeclType

  syn cluster validTypeContains          contains=goComment,goNewDeclType,goDeclTypeField,goDeclTypeW,goDeclTypeFieldSlice,goDeclTypeFieldPointerOp,goString,goRawString,OperatorChars,goContainer
  syn cluster validStructContains        contains=goComment,goNewDeclType,goDeclTypeField,goDeclTypeW,goString,goRawString,OperatorChars,goContainer
  syn cluster validInterfaceContains     contains=goComment,goFunctionTagLine,OperatorChars,goContainer,goType

  syn match goTypeDecl                   /\<type\>/ nextgroup=goNewDeclType,goTypeRegion skipwhite skipnl
  syn region goTypeRegion                matchgroup=goContainer start=/(/ end=/)/ contains=@validTypeContains fold contained
  syn region goDeclStructRegion          matchgroup=goContainer start=/{/ end=/}/ contains=@validStructContains fold contained
  syn region goDeclInterfaceRegion       matchgroup=goContainer start=/{/ end=/}/ contains=@validInterfaceContains fold contained

  syn match goDeclTypeFieldPointerOp     /\*/ nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeW,goDeclStruct,goDeclInterface skipwhite contained
  syn region goDeclTypeFieldSlice        matchgroup=goContainer start=/\[/ end=/\]/ contains=goDecimalInt,goHexadecimalInt,goOctalInt nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeW,goDeclStruct,goDeclInterface skipwhite contained

  " Match \w+\.\w+ but only highlight lone \w+ or (?>\.)\w+
  syn match goDeclTypeW                  /\%(\w\+\.\)\?\w\+\(\[.*\]\S\+\)\?/ contains=goDeclTypeNS,goDeclTypeType,goDeclTypeMap,ContainerChars,OperatorChars,goDeclaration skipwhite contained
  syn match goDeclTypeType               /\w\+/ nextgroup=goDeclTypeMap skipwhite contained
  syn region goDeclTypeMap               matchgroup=goContainer start=/\[/ end=/\]/ contains=goDeclTypeW,ContainerChars,OperatorChars nextgroup=goDeclTypeW skipwhite keepend contained
  syn match goDeclTypeNS                 /\w\+\(\.\)\@1=/ skipwhite contained

  syn match goDeclTypeField              /\w\+/ nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeW skipwhite contained

  syn match goNewDeclType                /\w\+\ze\s\+\<\(struct\|interface\)\>/ nextgroup=goDeclStruct,goDeclInterface skipwhite contained
  syn match goDeclStruct                 /\<struct\>/ nextgroup=goDeclStructRegion skipwhite skipnl
  syn match goDeclInterface              /\<interface\>/ nextgroup=goDeclInterfaceRegion skipwhite skipnl
endif

if !exists("g:go_highlight_functions")
  let g:go_highlight_functions = 0
endif
if g:go_highlight_functions != 0
  syn clear goFunctionCall
  syn clear goFunction

  syn match goDeclaration          /\<func\>/ nextgroup=goReceiverRegion,goFunction skipwhite skipnl
  syn region goReceiverRegion      matchgroup=goContainer start=/(/ end=/)/ contains=goReceiver nextgroup=goFunction contained
  syn match goReceiver             /\(\w\|[ *]\)\+/ contained contains=goReceiverVar,goPointerOperator skipwhite skipnl contained
  syn match goReceiverVar          /\w\+/ nextgroup=goPointerOperator,goReceiverType skipwhite skipnl contained
  syn match goPointerOperator      /\*/ nextgroup=goReceiverType contained skipwhite skipnl
  syn match goReceiverType         /\w\+/ contained

  "TODO: add goDeclTypeW
  syn cluster validFuncRegionContains contains=@goTypes,goField,goDeclaration,GoBuiltins,goDeclStruct,goDeclInterface,OperatorChars,ContainerChars,goString,goRawString,@goNumber,goTypeConstructor,goMethodCall

  syn match goFunctionTagLine       /\w\+(.*)\(\s*(.*)\|\s\S\+\)\?/ nextgroup=goFunction contains=goFunction,goFunctionParamRegion,goFunctionReturnRegion,goFunctionReturn,OperatorChars,ContainerChars,goComment
  syn region goFunctionParamRegion  matchgroup=goContainer start=/(/ end=/)/ contains=@validFuncRegionContains nextgroup=goFunctionReturnRegion,goFunctionReturn skipwhite keepend contained
  syn region goFunctionReturnRegion matchgroup=goContainer start=/(/ end=/)/ contains=@validFuncRegionContains skipwhite keepend contained
  syn match goFunctionReturn        /\w\+/ contains=@validFuncRegionContains skipwhite contained
  syn match goFunction              /\w\+\((\)\@1=/ nextgroup=goFunctionParamRegion skipwhite contained

  syn match goFunctionCall          /\(\.\)\@1<!\w\+\((\)\@1=/
endif

if g:go_highlight_methods != 0
  syn clear goMethodCall
  syn match goMethodCall            /\(\.\)\@1<=\w\+\((\)\@1=/
endif

" Order is important, so redefine
syn match goBuiltins /\<\v(append|cap|close|complex|copy|delete|imag|len)\ze\(/
syn match goBuiltins /\<\v(make|new|panic|print|println|real|recover)\ze\(/

hi link goPointerOperator        Operator
hi link goDeclTypeFieldPointerOp Operator

hi link goTypeConstructor        Type
hi link goTypeOpen               goContainer

hi link goDeclTypeFieldType      Type
hi link goNewDeclType            Type
hi link goDeclTypeType           Type

hi link goDeclInterface          Keyword
hi link goDeclStruct             Keyword

hi link goFunction               Function
hi link goMethodCall             Function
hi link goFunctionCall           Function

hi link goContainer              ContainerChars
