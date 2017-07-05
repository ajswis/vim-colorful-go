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

  syn cluster validTypeContains          contains=goComment,goNewDeclType,goDeclTypeField,goDeclTypeW,goDeclTypeFieldSlice,goDeclTypeFieldPointerOp,goString,goRawString,OperatorChars,goContainer
  syn cluster validStructContains        contains=goComment,goNewDeclType,goDeclTypeField,goDeclTypeW,goString,goRawString,OperatorChars,goContainer
  syn cluster validInterfaceContains     contains=goComment,goFunctionTagLine,OperatorChars,goContainer,goType,goNestedInterfaceType

  syn match goTypeDecl                   /\<type\>/ nextgroup=goNewDeclType,goTypeRegion skipwhite skipnl
  syn region goTypeRegion                matchgroup=goContainer start=/(/ end=/)/ contains=@validTypeContains fold contained
  syn region goDeclStructRegion          matchgroup=goContainer start=/{/ end=/}/ contains=@validStructContains fold contained
  syn region goDeclInterfaceRegion       matchgroup=goContainer start=/{/ end=/}/ contains=@validInterfaceContains fold contained
  syn match goNestedInterfaceType        /\w\+/ contained

  " I think I hate this
  syn cluster goDeclTypeContains         contains=goDeclTypeNS,goDeclTypeType,goDeclTypeMapType,goDeclTypeMap,ContainerChars,OperatorChars,goDeclaration,goDeclStruct,goDeclInterface
  " Match \w+\.\w+ but only highlight lone \w+ or (?>\.)\w+
  syn match goDeclTypeW                  /\(\[.*\]\|\*\)*\(\w\+\.\)\?\w\+\(\[.*\]\S\+\)\?/ contains=@goDeclTypeContains skipwhite contained
  " this is actually horribly broken for nested maps but appears to work.. 🤷
  syn match goDeclTypeType               /\w\+/ contains=@goNumber nextgroup=goDeclTypeMap skipwhite contained
  syn region goDeclTypeMap               matchgroup=goContainer start=/\[/ end=/\]/ contains=goDeclTypeW,ContainerChars nextgroup=goDeclTypeW skipwhite contained
  syn match goDeclTypeNS                 /\w\+\(\.\)\@1=/ skipwhite contained

  syn match goDeclTypeField              /\w\+/ nextgroup=goDeclTypeW skipwhite contained

  syn match goNewDeclType                /\w\+\(\s\([\*\[\] ]\)*\<\(struct\|interface\)\>\)\@=/ nextgroup=goDeclStruct,goDeclInterface skipwhite contained
  syn match goDeclStruct                 /\<struct\>/ nextgroup=goDeclStructRegion skipwhite skipnl
  syn match goDeclInterface              /\<interface\>/ nextgroup=goDeclInterfaceRegion skipwhite skipnl

  syn match goVarVar                     /[^, ]\+/ nextgroup=goVarSep,goDeclTypeW skipwhite contained
  syn match goVarSep                     /,/ nextgroup=goVarVar skipwhite contained
  syn keyword goVarDecl                  var nextgroup=goVarVar skipwhite
endif

if !exists("g:go_highlight_functions")
  let g:go_highlight_functions = 0
endif
if g:go_highlight_functions != 0
  syn clear goFunctionCall
  syn clear goFunction
  syn clear goReceiverType

  syn match goFunctionCall          /\(\.\)\@1<!\w\+\((\)\@1=/

  syn match goFunctionTagLine       /\w\+(.*)\s*\((.*)\|\S\+\)\?/ nextgroup=goFunction contains=goFunction,goDeclaration,goFunctionParamRegion,goFunctionReturnRegion,goFunctionReturn,OperatorChars,ContainerChars,goComment contained

  " This works but much like everything else, it is quite fragile. It doesn't
  " handle inline interfaces or structs (but should it, really?). Though, that
  " is probably more because of the terrible goDeclTypeW.. who knows...
  " Whatever.. it seems to fit 98% of my use cases
  syn match listOfVars              /\(\w\+, \)*\w\+ / contained
  syn match listOfTypes             /\(\S\+\ze[,)]\)\+/ contains=goDeclTypeW,ContainerChars contained
  syn match listOfVars              /\(, \|(\)\@<=\w\+\(\(, \w\+\)*, \w\+ \)\@=/ contained

  syn match goFunctionReturn        /[^{, ]\+/ contains=goDeclaration,goDeclTypeW skipwhite contained
  syn region goFunctionParamRegion  matchgroup=goContainer start=/(/ end=/)/ contains=goDeclaration,listOfTypes,listOfVars,ContainerChars,OperatorChars nextgroup=goFunctionReturn,goFunctionReturnRegion skipwhite contained
  syn region goFunctionReturnRegion matchgroup=goContainer start=/(/ end=/)/ contains=goDeclaration,listOfTypes,listOfVars,ContainerChars,OperatorChars skipwhite contained
  syn match goFunction              /\w\+\((\)\@1=/ nextgroup=goFunctionParamRegion skipwhite contained

  syn match goDeclaration           /\<func\>/ nextgroup=goReceiverRegion,goFunction,goFunctionParamRegion skipwhite skipnl
  " Use the space between func and ( to determine if the next group is a
  " receiver or an inlined function
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
