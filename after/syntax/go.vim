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

  " This is most likely bad... probably very bad.. and brittle?
  " mostly, it's incomplete but kinda matches gofmt, so theres that at least
  syn clear goTypeDecl
  syn clear goTypeName
  syn clear goDeclType

  syn cluster validTypeContains          contains=goComment,goNewDeclType,goDeclTypeField
  syn cluster validStructContains        contains=goComment,goNewDeclType,goDeclTypeField,goString,goRawString
  syn cluster validInterfaceContains     contains=goComment,goFunction,goNestedInterfaceType

  syn match goTypeDecl                   /\<type\>/ nextgroup=goNewDeclType,goTypeRegion skipwhite skipnl
  syn region goTypeRegion                matchgroup=goContainer start=/(/ end=/)/ contains=@validTypeContains fold contained
  syn region goDeclStructRegion          matchgroup=goContainer start=/{/ end=/}/ contains=@validStructContains fold contained
  syn region goDeclInterfaceRegion       matchgroup=goContainer start=/{/ end=/}/ contains=@validInterfaceContains fold contained
  syn match goNestedInterfaceType        /\w\+/ contained

  " I think I hate this and could be better
  syn cluster goDeclTypeContains         contains=goDeclTypeNS,goDeclTypeType,goMapKeyRegion,ContainerChars,OperatorChars,goDeclaration,goDeclStruct,goDeclInterface,goExtraType
  " Match \w+\.\w+ but only highlight lone \w+ or (?>\.)\w+
  syn match goDeclTypeW                  /\(\[.*\]\|\*\)*\(\w\+\.\)\?\w\+\(\[.*\]\S\+\)\?/ contains=@goDeclTypeContains skipwhite contained
  " this is actually horribly broken for nested maps but appears to work..
  " NOTE: I think fixing goDeclTypeW would fix mismatched brackets
  syn match goDeclTypeType               /\w\+/ contains=@goNumber nextgroup=goMapKeyRegion skipwhite contained
  syn region goMapKeyRegion              matchgroup=goContainer start=/\[/ end=/\]/ contains=goDeclTypeW,ContainerChars nextgroup=goDeclTypeW skipwhite contained
  syn match goDeclTypeNS                 /\w\+\(\.\)\@1=/ skipwhite contained

  syn keyword goMapType                  map nextgroup=goMapKeyRegion

  syn match goDeclTypeFieldPointerOp     /\*/ nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeW,goDeclStruct,goDeclInterface skipwhite contained
  syn region goDeclTypeFieldSlice        matchgroup=goContainer start=/\[/ end=/\]/ nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclTypeW,goDeclStruct,goDeclInterface skipwhite transparent contained

  syn match goDeclTypeField              /\w\+/ nextgroup=goDeclTypeW skipwhite contained

  " This is important in order to differentiate "field type" from "field struct"
  " and "field interface"
  syn match goNewDeclType                /\w\+\(\s\([*\[\] ]\)*\<\(struct\|interface\)\>\)\@=/ nextgroup=goDeclTypeFieldPointerOp,goDeclTypeFieldSlice,goDeclStruct,goDeclInterface skipwhite contained
  syn match goDeclStruct                 /\<struct\>/ nextgroup=goDeclStructRegion skipwhite skipnl
  syn match goDeclInterface              /\<interface\>/ nextgroup=goDeclInterfaceRegion skipwhite skipnl

  syn match goVarVar                     /[^, ]\+/ nextgroup=goVarSep,goDeclTypeW skipwhite contained
  syn match goVarSep                     /,/ nextgroup=goVarVar skipwhite contained
  " TODO:
  syn region goVarRegion                 matchgroup=goContainer start=/(/ end=/)/ transparent contained
  syn keyword goVarDecl                  var nextgroup=goVarVar,goVarRegion skipwhite

  " NOTE: incomplete, but good enough for now
  syn region goTypeAssertionRegion       matchgroup=goContainer start=/(/ end=/)/ contains=goDeclTypeW skipwhite contained
  syn match goTypeAssertionOp            /\.\((\)\@=/ nextgroup=goTypeAssertionRegion skipwhite
endif

if !exists("g:go_highlight_functions")
  let g:go_highlight_functions = 0
endif
if g:go_highlight_functions != 0
  syn clear goFunctionCall
  syn clear goFunction
  syn clear goReceiverType

  syn match goFunctionCall          /\(\.\)\@1<!\w\+\((\)\@1=/ nextgroup=goFuncMethCallRegion

  " This works but much like everything else, it is quite fragile. It doesn't
  " handle inline interfaces or structs (but should it, really?). Though, that
  " is probably more because of the terrible goDeclTypeW.. who knows...
  " Whatever.. it seems to fit 98% of my use cases
  " NOTE: I think fixing goDeclTypeW would fix inlined interface/structs
  syn match listOfTypes             /\(\S\+\ze[,)]\)\+/ contains=goDeclTypeW,ContainerChars contained
  syn match listOfVars              /\([,(]\s*\)\@<=\w\+\(\(, \w\+\)*, \w\+ \)\@=/ contained

  " TODO: change to "does not start with , or {"
  syn match goFunctionReturn        /[^{, ]\+/ contains=goDeclaration,goDeclTypeW skipwhite contained
  " NOTE: I think fixing goDeclTypeW would the need for "keepend extend"
  " Also transparent might help... (use only contains=listOfTypes,listOfVars ?)
  syn region goFunctionParamRegion  matchgroup=goContainer start=/(/ end=/)/ contains=goDeclaration,listOfTypes,listOfVars,ContainerChars,OperatorChars nextgroup=goFunctionReturn,goFunctionReturnRegion skipwhite keepend extend contained
  syn region goFunctionReturnRegion matchgroup=goContainer start=/(/ end=/)/ contains=goDeclaration,listOfTypes,listOfVars,ContainerChars,OperatorChars skipwhite keepend extend contained
  syn match goFunction              /\w\+\((\)\@1=/ nextgroup=goFunctionParamRegion skipwhite contained

  syn match goDeclaration           /\<func\>/ nextgroup=goReceiverRegion,goFunction,goFunctionParamRegion skipwhite skipnl
  " Use the space between func and ( to determine if the next group is a
  " receiver or an inlined function (which matches gofmt)
  syn region goReceiverRegion       matchgroup=goContainer start=/ (/ end=/)/ contains=goReceiver nextgroup=goFunction skipwhite contained
  syn match goReceiver              /\(\w\|[ *]\)\+/ contains=goReceiverVar,goPointerOperator skipwhite skipnl contained
  syn match goReceiverVar           /\w\+/ nextgroup=goPointerOperator,goDeclTypeW skipwhite skipnl contained
  syn match goPointerOperator       /\*/ nextgroup=goDeclTypeW skipwhite skipnl contained
endif

if !exists("g:go_highlight_methods")
  let g:go_highlight_methods = 0
endif
if g:go_highlight_methods != 0
  syn clear goMethodCall
  syn match goMethodCall            /\(\.\)\@1<=\w\+\((\)\@1=/ nextgroup=goFuncMethCallRegion
endif

syn region goFuncMethCallRegion   matchgroup=goContainer start=/(/ end=/)/ contained transparent

syn match goLiteralStructField /\w\+\ze:[^=]/

" Order is important, so redefine
syn match goBuiltins /\<\(append\|cap\|close\|complex\|copy\|delete\|imag\|len\)\((\)\@=/ nextgroup=goBuiltinRegion
syn match goBuiltins /\<\(make\|new\|panic\|print\|println\|real\|recover\)\((\)\@=/ nextgroup=goBuiltinRegion
syn region goBuiltinRegion matchgroup=goContainer start=/(/ end=/)/ transparent contained

hi link goPointerOperator        Operator
hi link goDeclTypeFieldPointerOp Operator
hi link goTypeAssertionOp        Operator

hi link goTypeConstructor        Type
hi link goTypeOpen               goContainer

hi link goDeclTypeFieldType      Type
hi link goNewDeclType            Type
hi link goDeclTypeType           Type
hi link goTypeVar                Type
hi link goNestedInterfaceType    Type

hi link goVarDecl                goDeclaration
hi link goVarSep                 Operator

hi link goDeclInterface          goDeclaration
hi link goDeclStruct             goDeclaration

hi link goFunction               Function
hi link goMethodCall             Function
hi link goFunctionCall           Function

hi link goContainer              ContainerChars
hi link goLiteralStructField     Special
