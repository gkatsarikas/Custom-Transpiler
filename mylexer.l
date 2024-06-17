/*Definitions*/
%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "cgen.h"
    #include "myanalyzer.tab.h"

    #define MACRO_MAX_LENGTH 2048

    int line_num = 1;
    int operator_flag = 1;  /*Flag used to find whether the + and - operators are sign or addition/subtraction operators*/    


    /*For macros handling, we are going to implement a linked list*/

    typedef struct macro{
        char* name;
        char* value;
        struct macro *next;
    }macro;

    macro* macros_list = NULL;

    /*Addition and search operations*/

    void add_macro_to_list(char* name,char* value){
        macro* m = (macro*)malloc(sizeof(macro));

        m->name = name;
        m->value = value;
        m->next = macros_list;

        macros_list = m;
    }

    char* search_macro(char* name){
        macro* m = macros_list; 
        while(macros_list){
            if(strcmp(macros_list->name,name) == 0){
                return macros_list->value;
            }
            m = m->next;
        }

        return NULL;
    }

    /*Frees allocated memory*/
    void free_macro(){
        macro* m = macros_list;

        while(m){
            macro* next = m->next;
            free(m->name);
            free(m->value);
            free(m);
            m = next;
        }
        macros_list = NULL;
    }

%}

DIGIT [0-9]
EXPONENT_TEN [eE]

IDENTIFIER [a-zA-Z][a-zA-Z0-9_]*
CONST_INT ({DIGIT}+)
FLOATING_POINT_CONSTANT ({DIGIT}+\.[0-9]+|{DIGIT}+\.?|{DIGIT}+(?:\.{DIGIT}*)?(?:{EXPONENT_TEN}[+-]?{DIGIT}+)?) 
BOOLEAN_CONSTANT True|False
CONSTANT_STRINGS \"(\\(n|t|r|\\|\")|[^\"\n]*)\"

%x              line_comment


%%

\n              {++line_num; operator_flag=1;}
[ \r\t]+        {/*Eat whitespace*/}



"main"          {printf("token KEYWORD_MAIN: %s\n",yytext); operator_flag=0; return KEYWORD_MAIN;};
"integer"       {printf("token KEYWORD_INTEGER: %s\n",yytext); operator_flag=0; return KEYWORD_INTEGER;};
"scalar"        {printf("token KEYWORD_SCALAR: %s\n",yytext); operator_flag=0; return KEYWORD_SCALAR;};
"str"           {printf("token KEYWORD_STR: %s\n",yytext); operator_flag=0; return KEYWORD_STR;};
"bool"          {printf("token KEYWORD_BOOL: %s\n",yytext); operator_flag=0; return KEYWORD_BOOL;};
"True"          {printf("token KEYWORD_TRUE: %s\n",yytext); operator_flag=0; return KEYWORD_TRUE;};
"False"         {printf("token KEYWORD_FALSE: %s\n",yytext); operator_flag=0; return KEYWORD_FALSE;};
"const"         {printf("token KEYWORD_CONST: %s\n",yytext); operator_flag=0; return KEYWORD_CONST;};
"if"            {printf("token KEYWORD_IF: %s\n",yytext); operator_flag=0; return KEYWORD_IF;};
"else"          {printf("token KEYWORD_ELSE: %s\n",yytext); operator_flag=0; return KEYWORD_ELSE;};
"endif"         {printf("token KEYWORD_ENDIF: %s\n",yytext); operator_flag=0; return KEYWORD_ENDIF;};
"for"           {printf("token KEYWORD_FOR: %s\n",yytext); operator_flag=0; return KEYWORD_FOR;};
"in"            {printf("token KEYWORD_IN: %s\n",yytext); operator_flag=0; return KEYWORD_IN;};
"endfor"        {printf("token KEYWORD_ENDFOR: %s\n",yytext); operator_flag=0; return KEYWORD_ENDFOR;};
"while"         {printf("token KEYWORD_WHILE: %s\n",yytext); operator_flag=0; return KEYWORD_WHILE;};
"endwhile"      {printf("token KEYWORD_ENDWHILE: %s\n",yytext); operator_flag=0; return KEYWORD_ENDWHILE;};
"break"         {printf("token KEYWORD_BREAK: %s\n",yytext); operator_flag=0; return KEYWORD_BREAK;};
"continue"      {printf("token KEYWORD_CONTINUE: %s\n",yytext); operator_flag=0; return KEYWORD_CONTINUE;};
"not"           {printf("token KEYWORD_NOT: %s\n",yytext); operator_flag=0; return KEYWORD_NOT;};
"and"           {printf("token KEYWORD_AND: %s\n",yytext); operator_flag=0; return KEYWORD_AND;};
"or"            {printf("token KEYWORD_OR: %s\n",yytext); operator_flag=0; return KEYWORD_OR;};
"def"           {printf("token KEYWORD_DEF: %s\n",yytext); operator_flag=0; return KEYWORD_DEF;};
"enddef"        {printf("token KEYWORD_ENDDEF: %s\n",yytext); operator_flag=0; return KEYWORD_ENDDEF;};
"return"        {printf("token KEYWORD_RETURN: %s\n",yytext); operator_flag=0; return KEYWORD_RETURN;};
"comp"          {printf("token KEYWORD_COMP: %s\n",yytext); operator_flag=0; return KEYWORD_COMP;};
"endcomp"       {printf("token KEYWORD_ENDCOMP: %s\n",yytext); operator_flag=0; return KEYWORD_ENDCOMP;};
"of"            {printf("token KEYWORD_OF: %s\n",yytext); operator_flag=0; return KEYWORD_OF;};

"*"             {printf("token MULTIPLICATION_OPERATOR: %s\n",yytext); operator_flag=1; return MULTIPLICATION_OPERATOR;};
"/"             {printf("token DIVISION_OPERATOR: %s\n",yytext); operator_flag=1; return DIVISION_OPERATOR;};
"%"             {printf("token MODULO_OPERATOR: %s\n",yytext); operator_flag=1; return MODULO_OPERATOR;};
"**"            {printf("token POWER_OPERATOR: %s\n",yytext); operator_flag=1; return POWER_OPERATOR;};

"=="            {printf("token IS_EQUAL_OPERATOR: %s\n",yytext); operator_flag=1;};
"!="            {printf("token IS_NOT_EQUAL_OPERATOR: %s\n",yytext); operator_flag=1;};
"<"             {printf("token LESS_THAN_OPERATOR: %s\n",yytext); operator_flag=1;};
"<="            {printf("token LESS_EQUAL_OPERATOR: %s\n",yytext); operator_flag=1;};
">"             {printf("token GREATER_THAN_OPERATOR: %s\n",yytext); operator_flag=1;};
">="            {printf("token GREATER_EQUAL_OPERATOR: %s\n",yytext); operator_flag=1;};

"="             {printf("token ASSIGN_OPERATOR: %s\n",yytext); operator_flag=1; return ASSIGN_OPERATOR;};
"#"             {printf("token HASHTAG_ASSIGN_OPERATOR: %s\n",yytext); operator_flag=1; return HASHTAG_ASSIGN_OPERATOR;};
"+="            {printf("token ADD_ASSIGN_OPERATOR: %s\n",yytext); operator_flag=1; return ADD_ASSIGN_OPERATOR;};
"-="            {printf("token SUBTRACT_ASSIGN_OPERATOR: %s\n",yytext); operator_flag=1; return SUBTRACT_ASSIGN_OPERATOR;};
"*="            {printf("token MULTIPLY_ASSIGN_OPERATOR: %s\n",yytext); operator_flag=1; return MULTIPLY_ASSIGN_OPERATOR;};
"/="            {printf("token DIVIDE_ASSIGN_OPERATOR: %s\n",yytext); operator_flag=1; return DIVIDE_ASSIGN_OPERATOR;};
"%="            {printf("token MODULO_ASSIGN_OPERATOR: %s\n",yytext); operator_flag=1; return MODULO_ASSIGN_OPERATOR;};
":="            {printf("token ARRAY_ASSIGN_OPERATOR: %s\n",yytext); operator_flag=1; return ARRAY_ASSIGN_OPERATOR;};

";"             {printf("token DELIMITER_SEMICOLON: %s\n",yytext); operator_flag=1; return DELIMITER_SEMICOLON;};
"("             {printf("token DELIMITER_LEFT_PARENTHESIS: %s\n",yytext); operator_flag=1; return DELIMITER_LEFT_PARENTHESIS;};
")"             {printf("token DELIMITER_RIGHT_PARENTHESIS: %s\n",yytext); operator_flag=1; return DELIMITER_RIGHT_PARENTHESIS;};
","             {printf("token DELIMITER_COMMA: %s\n",yytext); operator_flag=1; return DELIMITER_COMMA;};
"["             {printf("token DELIMITER_LEFT_BRACKET: %s\n",yytext); operator_flag=1; return DELIMITER_LEFT_BRACKET;};
"]"             {printf("token DELIMITER_RIGHT_BRACKET: %s\n",yytext); operator_flag=1; return DELIMITER_RIGHT_BRACKET;};
":"             {printf("token DELIMITER_COLON: %s\n",yytext); operator_flag=1; return DELIMITER_COLON;};
"."             {printf("token DELIMITER_DOT: %s\n",yytext); operator_flag=1; return DELIMITER_DOT;};

"+" {if(operator_flag){printf("token SIGN_OPERATOR_PLUS: %s\n",yytext); operator_flag=0; return SIGN_OPERATOR_PLUS;}else{printf("token ADDITION_OPERATOR:%s\n",yytext); operator_flag=0; return ADDITION_OPERATOR;}}
"-" {if(operator_flag){printf("token SIGN_OPERATOR_MINUS: %s\n",yytext); operator_flag=0; return SIGN_OPERATOR_MINUS;}else{printf("token SUBTRACTION_OPERATOR:%s\n",yytext); operator_flag=0; return SUBTRACTION_OPERATOR;}}

"->"            {printf("token ARROW_OPERATOR: %s\n",yytext); operator_flag=1; return ARROW_OPERATOR;}

{IDENTIFIER}    {printf("token IDENTIFIER: %s\n", yytext); operator_flag = 0; return IDENTIFIER;}
{CONST_INT}     {printf("token INTEGER_CONSTANT: %s\n",yytext); operator_flag = 0; return INTEGER_CONSTANT;};
{FLOATING_POINT_CONSTANT}   {printf("token SCALAR_CONSTANT: %s\n",yytext); operator_flag=0; return FLOATING_POINT_CONSTANT;};
{CONSTANT_STRINGS} {printf("token STRING_CONSTANT: %s\n", yytext); operator_flag=0; return STRING_CONSTANT;}




"--"                    {BEGIN(line_comment);};
<line_comment>[^\n]*    /*Eat line comments*/
<line_comment>\n        {++line_num;BEGIN(INITIAL);}

<<EOF>>                 return EOF;
.                       {printf("Unrecognized token %s in line %d",yytext,line_num); exit(EXIT_FAILURE);};
%%