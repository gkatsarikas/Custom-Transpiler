/*Definitions*/
%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    #include "cgen.h"
    #include "myanalyzer.tab.h"

    #define MACRO_MAX_LENGTH 2048

    int line_num = 1;

    /*Implementation of macro definition using a linked list*/
    typedef struct Macro{
        char* identifier;
        char* string;
        struct Macro* next;
    }Macro;

    Macro* macros = NULL;


    void insert(char *identifier, char *string) {
        Macro *m = (Macro *)malloc(sizeof(Macro));
        if (!m) {
            fprintf(stderr, "Memory allocation error\n");
            exit(EXIT_FAILURE);
        }

        m->identifier = strdup(identifier);
        m->string = strdup(string);
        if (!m->identifier || !m->string) {
            fprintf(stderr, "Memory allocation error\n");
            exit(EXIT_FAILURE);
        }

        m->next = macros;
        macros = m;
    }


    const char *get_macro_replacement(const char *identifier) {
        for (Macro *macro = macros; macro != NULL; macro = macro->next) {
            if (strcmp(macro->identifier, identifier) == 0) {
                return macro->string;
            }
        }
        return NULL;
    }

    char *find_macro_value(const char *identifier) {
        for (Macro *macro = macros; macro != NULL; macro = macro->next) {
            if (strcmp(macro->identifier, identifier) == 0) {
                return macro->string;
            }
        }
        return NULL;
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

\n              {++line_num;}
[ \r\t]+        {/*Eat whitespace*/}




"main"          {printf("token KEYWORD_MAIN: %s\n",yytext);  return KEYWORD_MAIN;};
"integer"       {printf("token KEYWORD_INTEGER: %s\n",yytext); return KEYWORD_INTEGER;};
"scalar"        {printf("token KEYWORD_SCALAR: %s\n",yytext); return KEYWORD_SCALAR;};
"str"           {printf("token KEYWORD_STR: %s\n",yytext); return KEYWORD_STR;};
"bool"          {printf("token KEYWORD_BOOL: %s\n",yytext); return KEYWORD_BOOL;};
"True"          {printf("token KEYWORD_TRUE: %s\n",yytext); return KEYWORD_TRUE;};
"False"         {printf("token KEYWORD_FALSE: %s\n",yytext); return KEYWORD_FALSE;};
"const"         {printf("token KEYWORD_CONST: %s\n",yytext); return KEYWORD_CONST;};
"if"            {printf("token KEYWORD_IF: %s\n",yytext); return KEYWORD_IF;};
"else"          {printf("token KEYWORD_ELSE: %s\n",yytext); return KEYWORD_ELSE;};
"endif"         {printf("token KEYWORD_ENDIF: %s\n",yytext); return KEYWORD_ENDIF;};
"for"           {printf("token KEYWORD_FOR: %s\n",yytext); return KEYWORD_FOR;};
"in"            {printf("token KEYWORD_IN: %s\n",yytext); return KEYWORD_IN;};
"endfor"        {printf("token KEYWORD_ENDFOR: %s\n",yytext); return KEYWORD_ENDFOR;};
"while"         {printf("token KEYWORD_WHILE: %s\n",yytext); return KEYWORD_WHILE;};
"endwhile"      {printf("token KEYWORD_ENDWHILE: %s\n",yytext); return KEYWORD_ENDWHILE;};
"break"         {printf("token KEYWORD_BREAK: %s\n",yytext); return KEYWORD_BREAK;};
"continue"      {printf("token KEYWORD_CONTINUE: %s\n",yytext); return KEYWORD_CONTINUE;};
"not"           {printf("token KEYWORD_NOT: %s\n",yytext); return KEYWORD_NOT;};
"and"           {printf("token KEYWORD_AND: %s\n",yytext); return KEYWORD_AND;};
"or"            {printf("token KEYWORD_OR: %s\n",yytext); return KEYWORD_OR;};
"def"           {printf("token KEYWORD_DEF: %s\n",yytext); return KEYWORD_DEF;};
"enddef"        {printf("token KEYWORD_ENDDEF: %s\n",yytext); return KEYWORD_ENDDEF;};
"return"        {printf("token KEYWORD_RETURN: %s\n",yytext); return KEYWORD_RETURN;};
"comp"          {printf("token KEYWORD_COMP: %s\n",yytext); return KEYWORD_COMP;};
"endcomp"       {printf("token KEYWORD_ENDCOMP: %s\n",yytext); return KEYWORD_ENDCOMP;};
"of"            {printf("token KEYWORD_OF: %s\n",yytext); return KEYWORD_OF;};

"*"             {printf("token MULTIPLICATION_OPERATOR: %s\n",yytext); return MULTIPLICATION_OPERATOR;};
"/"             {printf("token DIVISION_OPERATOR: %s\n",yytext); return DIVISION_OPERATOR;};
"%"             {printf("token MODULO_OPERATOR: %s\n",yytext); return MODULO_OPERATOR;};
"**"            {printf("token POWER_OPERATOR: %s\n",yytext); return POWER_OPERATOR;};

"=="            {printf("token IS_EQUAL_OPERATOR: %s\n",yytext); return IS_EQUAL_OPERATOR;};
"!="            {printf("token IS_NOT_EQUAL_OPERATOR: %s\n",yytext);return IS_NOT_EQUAL_OPERATOR;};
"<"             {printf("token LESS_THAN_OPERATOR: %s\n",yytext); return LESS_THAN_OPERATOR;};
"<="            {printf("token LESS_EQUAL_OPERATOR: %s\n",yytext); return LESS_EQUAL_OPERATOR;};
">"             {printf("token GREATER_THAN_OPERATOR: %s\n",yytext); return GREATER_THAN_OPERATOR;};
">="            {printf("token GREATER_EQUAL_OPERATOR: %s\n",yytext); return GREATER_EQUAL_OPERATOR;};

"="             {printf("token ASSIGN_OPERATOR: %s\n",yytext); return ASSIGN_OPERATOR;};
"#"             {printf("token HASHTAG_ASSIGN_OPERATOR: %s\n",yytext); return HASHTAG_ASSIGN_OPERATOR;};
"+="            {printf("token ADD_ASSIGN_OPERATOR: %s\n",yytext); return ADD_ASSIGN_OPERATOR;};
"-="            {printf("token SUBTRACT_ASSIGN_OPERATOR: %s\n",yytext); return SUBTRACT_ASSIGN_OPERATOR;};
"*="            {printf("token MULTIPLY_ASSIGN_OPERATOR: %s\n",yytext); return MULTIPLY_ASSIGN_OPERATOR;};
"/="            {printf("token DIVIDE_ASSIGN_OPERATOR: %s\n",yytext); return DIVIDE_ASSIGN_OPERATOR;};
"%="            {printf("token MODULO_ASSIGN_OPERATOR: %s\n",yytext); return MODULO_ASSIGN_OPERATOR;};
":="            {printf("token ARRAY_ASSIGN_OPERATOR: %s\n",yytext); return ARRAY_ASSIGN_OPERATOR;};

";"             {printf("token DELIMITER_SEMICOLON: %s\n",yytext); return DELIMITER_SEMICOLON;};
"("             {printf("token DELIMITER_LEFT_PARENTHESIS: %s\n",yytext); return DELIMITER_LEFT_PARENTHESIS;};
")"             {printf("token DELIMITER_RIGHT_PARENTHESIS: %s\n",yytext); return DELIMITER_RIGHT_PARENTHESIS;};
","             {printf("token DELIMITER_COMMA: %s\n",yytext); return DELIMITER_COMMA;};
"["             {printf("token DELIMITER_LEFT_BRACKET: %s\n",yytext); return DELIMITER_LEFT_BRACKET;};
"]"             {printf("token DELIMITER_RIGHT_BRACKET: %s\n",yytext); return DELIMITER_RIGHT_BRACKET;};
":"             {printf("token DELIMITER_COLON: %s\n",yytext); return DELIMITER_COLON;};
"."             {printf("token DELIMITER_DOT: %s\n",yytext); return DELIMITER_DOT;};

"+"             {printf("token OPERATOR_PLUS: %s\n",yytext); return OPERATOR_PLUS;}
"-"             {printf("token OPERATOR_MINUS: %s\n",yytext); return OPERATOR_MINUS;}

"->"            {printf("token ARROW_OPERATOR: %s\n",yytext); return ARROW_OPERATOR;}

{IDENTIFIER}    {
                        yylval.str = strdup(yytext);
                        printf("token IDENTIFIER: %s\n", yytext);
                    0;
                        return IDENTIFIER;
                }

{CONST_INT}     {yylval.int_val = atoi(strdup(yytext)); printf("token INTEGER_CONSTANT: %s\n",yytext);0; return INTEGER_CONSTANT;};
{FLOATING_POINT_CONSTANT}   {yylval.double_val =atof(strdup(yytext)); printf("token SCALAR_CONSTANT: %s\n",yytext); return SCALAR_CONSTANT;};
{CONSTANT_STRINGS} {yylval.str=strdup(yytext); printf("token STRING_CONSTANT: %s\n", yytext); return STRING_CONSTANT;}


"--"                    {BEGIN(line_comment);};
<line_comment>[^\n]*    /*Eat line comments*/
<line_comment>\n        {++line_num;BEGIN(INITIAL);}



.                       {printf("Unrecognized token %s in line %d",yytext,line_num); exit(EXIT_FAILURE);};
%%



