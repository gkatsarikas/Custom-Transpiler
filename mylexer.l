/*Definitions*/
%{
    #include <stdio.h>
    #include <string.h>

    int line_num = 1;
}%

DIGIT [0-9]
SIGN [+-]
EXPONENT_TEN [eE]

IDENTIFIER [a-zA-Z][A-Z0-9]*

CONST_INT ({DIGIT}+)
FLOATING_POINT_CONSTANT -?({DIGIT}+\.{DIGIT}+|{DIGIT}+(?:\.{DIGIT}*)?(?:{EXPONENT_TEN}{SIGN}?{DIGIT}+)?)
BOOLEAN_CONSTANT True|False

CONSTANT_STRINGS \"(\\(n|t|r|\\|\")|[^\"\n]*)"


%%
/*Keywords*/
"integer"       {printf("token KEYWORD_INTEGER: %s\n",yytext);};
"scalar"        {printf("token KEYWORD_SCALAR: %s\n",yytext);};
"str"           {printf("token KEYWORD_STR: %s\n",yytext);};
"bool"          {printf("token KEYWORD_BOOL: %s\n",yytext);};
"True"          {printf("token KEYWORD_TRUE: %s\n",yytext);};
"False"         {printf("token KEYWORD_FALSE: %s\n",yytext);};
"const"         {printf("token KEYWORD_CONST: %s\n",yytext);};
"if"            {printf("token KEYWORD_IF: %s\n",yytext);};
"else"          {printf("token KEYWORD_ELSE: %s\n",yytext);;}
"endif"         {printf("token KEYWORD_ENDIF: %s\n",yytext);;}
"for"           {printf("token KEYWORD_FOR: %s\n",yytext);};
"in"            {printf("token KEYWORD_IN: %s\n",yytext);};
"endfor"        {printf("token KEYWORD_ENDFOR: %s\n",yytext;)};
"while"         {printf("token KEYWORD_WHILE: %s\n",yytext);};
"endwhile"      {printf("token KEYWORD_ENDWHILE: %s\n",yytext);};
"break"         {printf("token KEYWORD_BREAK: %s\n",yytext);};
"continue"      {printf("token KEYWORD_CONTINUE: %s\n",yytext);};
"not"           {printf("token KEYWORD_NOT: %s\n",yytext);};
"and"           {printf("token KEYWORD_AND: %s\n",yytext);};
"or"            {printf("token KEYWORD_OR: %s\n",yytext);};
"def"           {printf("token KEYWORD_DEF: %s\n",yytext);};
"enddef"        {printf("token KEYWORD_ENDDEF: %s\n",yytext);};
"main"          {printf("token KEYWORD_MAIN: %s\n",yytext);};
"return"        {printf("token KEYWORD_RETURN: %s\n",yytext);};
"comp"          {printf("token KEYWORD_COMP: %s\n",yytext);};
"endcomp"       {printf("token KEYWORD_ENDCOMP: %s\n",yytext);};
"of"            {printf("token KEYWORD_OF: %s\n",yytext);};