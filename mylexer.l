/*Definitions*/
%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>

    int line_num = 1;
%}

DIGIT [0-9]
SIGN [+-]
EXPONENT_TEN [eE]

IDENTIFIER [a-zA-Z][A-Z0-9]*

CONST_INT ({DIGIT}+)
FLOATING_POINT_CONSTANT -?({DIGIT}+\.{DIGIT}+|{DIGIT}+(?:\.{DIGIT}*)?(?:{EXPONENT_TEN}{SIGN}?{DIGIT}+)?)
BOOLEAN_CONSTANT True|False
CONSTANT_STRINGS \"(\\(n|t|r|\\|\")|[^\"\n]*)"

%x              line_comment


%%

\n              ++line_num;


"main"          {printf("token KEYWORD_MAIN: %s\n",yytext);};
"integer"       {printf("token KEYWORD_INTEGER: %s\n",yytext);};
"scalar"        {printf("token KEYWORD_SCALAR: %s\n",yytext);};
"str"           {printf("token KEYWORD_STR: %s\n",yytext);};
"bool"          {printf("token KEYWORD_BOOL: %s\n",yytext);};
"True"          {printf("token KEYWORD_TRUE: %s\n",yytext);};
"False"         {printf("token KEYWORD_FALSE: %s\n",yytext);};
"const"         {printf("token KEYWORD_CONST: %s\n",yytext);};
"if"            {printf("token KEYWORD_IF: %s\n",yytext);};
"else"          {printf("token KEYWORD_ELSE: %s\n",yytext);};
"endif"         {printf("token KEYWORD_ENDIF: %s\n",yytext);};
"for"           {printf("token KEYWORD_FOR: %s\n",yytext);};
"in"            {printf("token KEYWORD_IN: %s\n",yytext);};
"endfor"        {printf("token KEYWORD_ENDFOR: %s\n",yytext);};
"while"         {printf("token KEYWORD_WHILE: %s\n",yytext);};
"endwhile"      {printf("token KEYWORD_ENDWHILE: %s\n",yytext);};
"break"         {printf("token KEYWORD_BREAK: %s\n",yytext);};
"continue"      {printf("token KEYWORD_CONTINUE: %s\n",yytext);};
"not"           {printf("token KEYWORD_NOT: %s\n",yytext);};
"and"           {printf("token KEYWORD_AND: %s\n",yytext);};
"or"            {printf("token KEYWORD_OR: %s\n",yytext);};
"def"           {printf("token KEYWORD_DEF: %s\n",yytext);};
"enddef"        {printf("token KEYWORD_ENDDEF: %s\n",yytext);};
"return"        {printf("token KEYWORD_RETURN: %s\n",yytext);};
"comp"          {printf("token KEYWORD_COMP: %s\n",yytext);};
"endcomp"       {printf("token KEYWORD_ENDCOMP: %s\n",yytext);};
"of"            {printf("token KEYWORD_OF: %s\n",yytext);};

"+"             {printf("token ADDITION_OPERATOR: %s\n",yytext);};
"-"             {printf("token SUBTRACTION_OPERATOR: %s\n",yytext);};
"*"             {printf("token MULTIPLICATION_OPERATOR: %s\n",yytext);};
"/"             {printf("token DIVISION_OPERATOR: %s\n",yytext);};
"%"             {printf("token MODULO_OPERATOR: %s\n",yytext);};
"**"            {printf("token POWER_OPERATOR: %s\n",yytext);};

"=="            {printf("token IS_EQUAL_OPERATOR: %s\n",yytext);};
"!="            {printf("token IS_NOT_EQUAL_OPERATOR: %s\n",yytext);};
"<"             {printf("token LESS_THAN_OPERATOR: %s\n",yytext);};
"<="            {printf("token LESS_EQUAL_OPERATOR: %s\n",yytext);};
">"             {printf("token GREATER_THAN_OPERATOR: %s\n",yytext);};
">="            {printf("token GREATER_EQUAL_OPERATOR: %s\n",yytext);};

"="             {printf("token ASSIGN_OPERATOR: %s\n",yytext);};
"+="            {printf("token ADD_ASSIGN_OPERATOR: %s\n",yytext);};
"-="            {printf("token SUBTRACT_ASSIGN_OPERATOR: %s\n",yytext);};
"*="            {printf("token MULTIPLY_ASSIGN_OPERATOR: %s\n",yytext);};
"/="            {printf("token DIVIDE_ASSIGN_OPERATOR: %s\n",yytext);};
"%="            {printf("token MODULO_ASSIGN_OPERATOR: %s\n",yytext);};
":="            {printf("token ARRAY_ASSIGN_OPERATOR: %s\n",yytext);};

";"             {printf("token DELIMITER_SEMICOLON: %s\n",yytext);};
"("             {printf("token DELIMITER_RIGHT_PARENTHESIS: %s\n",yytext);};
")"             {printf("token DELIMITER_LEFT_PARENTHESIS: %s\n",yytext);};
","             {printf("token DELIMITER_COMMA: %s\n",yytext);};
"["             {printf("token DELIMITER_RIGHT_BRACKET: %s\n",yytext);};
"]"             {printf("token DELIMITER_LEFT_BRACKET: %s\n",yytext);};
":"             {printf("token DELIMITER_COLON: %s\n",yytext);};
"."             {printf("token DELIMITER_DOT: %s\n",yytext);};


.               {printf("Unrecognized token %s in line %d",yytext,line_num); exit(EXIT_FAILURE);};

%%


int main(){
    int token;
    while((token = yylex()) != 0){}
    return 0;
}
