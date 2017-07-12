if !exists("g:go_highlight_fields")
  let g:go_highlight_fields = 0
endif
if g:go_highlight_fields != 0
  syn match goField /\(\.\)\@1<=\w\+\([.\ \n\r\:\)\[,+-\*}\\\]]\)\@=/
endif

" Order matters...
if !exists("g:go_highlight_functions")
  let g:go_highlight_functions = 0
endif
if g:go_highlight_functions != 0
  " FIXME: This is too greedy
  syn match listOfTypes /\(\S\+\ze[,)]\)\+/ contains=@goDeclarations,@goDeclTypeBegin,goMapKeyRegion,goFunctionParamRegion,goFunctionReturnRegion,goDeclStructRegion,goDeclInterfaceRegion contained
  syn match listOfVars  /\([,(]\s*\)\@<=\w\+\(\(, \w\+\)*, \w\+ \)\@=/ contained
endif

if !exists("g:go_highlight_types")
  let g:go_highlight_types = 0
endif
if g:go_highlight_types != 0
  syn clear goTypeDecl
  syn clear goTypeName
  syn clear goDeclType

  syn match goTypeConstructor         /\<\w\+\({\)\@1=/

  syn cluster validTypeContains       contains=goComment,goDeclSIName,goDeclTypeField,goDeclTypeName
  " FIXME: not sure I _need_ to state goDecl_Region
  syn cluster validStructContains     contains=goComment,goDeclSIName,goDeclTypeField,goString,goRawString,goMapType,goMapKeyRegion,goDeclStructRegion,goDeclInterfaceRegion
  syn cluster validInterfaceContains  contains=goComment,goFunction,goNestedInterfaceType

  syn match goDeclTypeField           /\w\+/ nextgroup=@goDeclTypeBegin skipwhite contained
  syn match goDeclTypeName            /\w\+/ nextgroup=@goDeclTypeBegin skipwhite contained

  syn match goTypeDecl                /\<type\>/ nextgroup=goDeclTypeName,goTypeRegion skipwhite skipnl
  syn region goTypeRegion             matchgroup=goContainer start=/(/ end=/)/ contains=@validTypeContains skipwhite fold contained
  syn region goDeclStructRegion       matchgroup=goContainer start=/{/ end=/}/ contains=@validStructContains skipwhite fold contained
  syn region goDeclInterfaceRegion    matchgroup=goContainer start=/{/ end=/}/ contains=@validInterfaceContains skipwhite fold contained
  syn match goNestedInterfaceType     /\w\+/ contained

  syn match goDeclTypeStart           /\*/ contains=OperatorChars nextgroup=goDeclTypeStart,goDeclTypeNamespace,goDeclTypeType,goMapType,@goDeclarations skipwhite contained
  syn region goDeclTypeStart          matchgroup=goContainer start=/\[/ end=/\]/ contains=@goNumbers nextgroup=goDeclTypeStart,goDeclTypeNamespace,goDeclTypeType,goMapType,@goDeclarations skipwhite transparent contained
  syn match goDeclTypeType            /\w\+/ contains=goMapType,@goDeclarations skipwhite contained
  syn match goDeclTypeNamespace       /\w\+\./ contains=OperatorChars nextgroup=goDeclTypeType skipwhite contained
  syn cluster goDeclTypeBegin         contains=goDeclTypeStart,goDeclTypeType,goDeclTypeNamespace,goDeclaration

  syn region goMapKeyRegion           matchgroup=goContainer start=/\[/ end=/\]/ contains=@goDeclTypeBegin,goDeclaration nextgroup=@goDeclTypeBegin skipwhite contained
  syn keyword goMapType               map nextgroup=goMapKeyRegion skipwhite

  " This is important in order to differentiate "field type" from "field struct"
  " and "field interface"
  " FIXME: seems fishy, see @validStructContains
  syn match goDeclSIName              /\w\+\(\s\([*\[\] ]\)*\<\(struct\|interface\)\>\)\@=/ nextgroup=@goDeclTypeBegin,goDeclStruct,goDeclInterface skipwhite contained
  syn match goDeclStruct              /\<struct\>/ nextgroup=goDeclStructRegion skipwhite skipnl
  syn match goDeclInterface           /\<interface\>/ nextgroup=goDeclInterfaceRegion skipwhite skipnl

  syn match goVarName                 /[^, ]\+/ nextgroup=goVarSep,@goDeclTypeBegin,goMapType skipwhite contained
  syn match goVarSep                  /,/ nextgroup=goVarName skipwhite contained
  syn region goVarRegion              matchgroup=goContainer start=/(/ end=/)/ transparent contained
  syn keyword goVarDecl               var nextgroup=goVarName,goVarRegion skipwhite

  syn region goTypeAssertionRegion    matchgroup=goContainer start=/(/ end=/)/ contains=@goDeclTypeBegin,goMapType,goMapKeyRegion skipwhite contained
  syn match goTypeAssertionOp         /\.\((\)\@=/ nextgroup=goTypeAssertionRegion skipwhite
endif

if g:go_highlight_functions != 0
  syn clear goFunctionCall
  syn clear goFunction
  syn clear goReceiverType

  syn match goFunctionCall          /\(\.\)\@1<!\w\+\((\)\@1=/ nextgroup=goFuncMethCallRegion

  " FIXME: ^{\], is a lazy hack-fix
  syn match goFunctionReturn        /[^{\]), ]\+/ contains=@goDeclarations,@goDeclTypeBegin skipwhite contained
  syn region goFunctionParamRegion  matchgroup=goContainer start=/(/ end=/)/ contains=@goDeclarations,listOfTypes,listOfVars,OperatorChars nextgroup=goFunctionReturn,goFunctionReturnRegion skipwhite transparent contained
  syn region goFunctionReturnRegion matchgroup=goContainer start=/(/ end=/)/ contains=@goDeclarations,listOfTypes,listOfVars,OperatorChars skipwhite transparent contained
  syn match goFunction              /\w\+\((\)\@1=/ nextgroup=goFunctionParamRegion skipwhite contained

  syn match goDeclaration           /\<func\>/ nextgroup=goReceiverRegion,goFunction,goFunctionParamRegion skipwhite skipnl
  " Use the space between func and ( to determine if the next group is a
  " receiver or an inlined function (which matches gofmt)
  syn region goReceiverRegion       matchgroup=goContainer start=/ (/ end=/)/ contains=goReceiver nextgroup=goFunction skipwhite contained
  syn match goReceiver              /\(\w\|[ *]\)\+/ contains=goReceiverVar,goPointerOperator skipwhite skipnl contained
  syn match goReceiverVar           /\w\+/ nextgroup=goPointerOperator,@goDeclTypeBegin skipwhite skipnl contained
  syn match goPointerOperator       /\*/ nextgroup=@goDeclTypeBegin skipwhite skipnl contained
endif

if !exists("g:go_highlight_methods")
  let g:go_highlight_methods = 0
endif
if g:go_highlight_methods != 0
  syn clear goMethodCall
  syn match goMethodCall            /\(\.\)\@1<=\w\+\((\)\@1=/ nextgroup=goFuncMethCallRegion
endif

syn cluster goDeclarations          contains=goDeclaration,goDeclStruct,goDeclInterface
syn cluster goTypes                 contains=goType,goSignedInts,goUnsignedInts,goFloats,goComplexes
syn cluster goNumbers               contains=goDecimalInt,goHexadecimalInt,goOctalInt,goFloat,goImaginary,goImaginaryFloat

syn region goFuncMethCallRegion     matchgroup=goContainer start=/(/ end=/)/ transparent contained

syn match goLiteralStructField      /\w\+\ze:[^=]/

" Order is important, so redefine
syn match goBuiltins /\<\(append\|cap\|close\|complex\|copy\|delete\|imag\|len\)\((\)\@=/ nextgroup=goBuiltinRegion
syn match goBuiltins /\<\(make\|new\|panic\|print\|println\|real\|recover\)\((\)\@=/ nextgroup=goBuiltinRegion
syn region goBuiltinRegion matchgroup=goContainer start=/(/ end=/)/ transparent contained

hi link goPointerOperator        Operator
hi link goTypeAssertionOp        Operator
hi link goVarSep                 Operator

hi link goTypeConstructor        Type
hi link goDeclSIName             Type
hi link goDeclTypeType           Type
hi link goNestedInterfaceType    Type
hi link goMapType                Type
hi link goDeclTypeName           Type

hi link goVarDecl                goDeclaration
hi link goDeclInterface          goDeclaration
hi link goDeclStruct             goDeclaration

hi link goFunction               Function
hi link goMethodCall             Function
hi link goFunctionCall           Function

hi link goContainer              ContainerChars
hi link goLiteralStructField     Special
