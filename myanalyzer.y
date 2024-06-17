%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>
    #include "cgen.h"

    extern int yylex(void);
%}


%union{
    char *str;
}

%token <str> IDENTIFIER
%token <str> INTEGER_CONSTANT FLOATING_POINT_CONSTANT STRING_CONSTANT BOOLEAN_CONSTANT

%token KEYWORD_INTEGER
%token KEYWORD_SCALAR
%token KEYWORD_STR
%token KEYWORD_BOOL
%token KEYWORD_TRUE
%token KEYWORD_FALSE
%token KEYWORD_CONST
%token KEYWORD_IF 
%token KEYWORD_ELSE
%token KEYWORD_ENDIF
%token KEYWORD_FOR
%token KEYWORD_IN 
%token KEYWORD_ENDFOR
%token KEYWORD_WHILE
%token KEYWORD_ENDWHILE
%token KEYWORD_BREAK
%token KEYWORD_CONTINUE
%token KEYWORD_NOT
%token KEYWORD_AND
%token KEYWORD_OR 
%token KEYWORD_DEF
%token KEYWORD_ENDDEF
%token KEYWORD_MAIN
%token KEYWORD_RETURN
%token KEYWORD_COMP
%token KEYWORD_ENDCOMP
%token KEYWORD_OF

%token ADDITION_OPERATOR
%token SUBTRACTION_OPERATOR
%token MULTIPLICATION_OPERATOR
%token DIVISION_OPERATOR
%token MODULO_OPERATOR
%token POWER_OPERATOR
%token SIGN_OPERATOR_PLUS
%token SIGN_OPERATOR_MINUS

%token ASSIGN_OPERATOR
%token HASHTAG_ASSIGN_OPERATOR
%token ADD_ASSIGN_OPERATOR
%token SUBTRACT_ASSIGN_OPERATOR
%token MULTIPLY_ASSIGN_OPERATOR
%token DIVIDE_ASSIGN_OPERATOR
%token MODULO_ASSIGN_OPERATOR
%token ARRAY_ASSIGN_OPERATOR
%token ARROW_OPERATOR

%token IS_EQUAL_OPERATOR
%token IS_NOT_EQUAL_OPERATOR
%token LESS_THAN_OPERATOR
%token LESS_EQUAL_OPERATOR
%token GREATER_THAN_OPERATOR
%token GREATER_EQUAL_OPERATOR

%token DELIMITER_DOT
%token DELIMITER_COLON
%token DELIMITER_SEMICOLON
%token DELIMITER_RIGHT_BRACKET
%token DELIMITER_LEFT_BRACKET
%token DELIMITER_RIGHT_PARENTHESIS
%token DELIMITER_LEFT_PARENTHESIS
%token DELIMITER_COMMA


%left DELIMITER_DOT DELIMITER_LEFT_BRACKET DELIMITER_RIGHT_BRACKET DELIMITER_LEFT_PARENTHESIS DELIMITER_RIGHT_PARENTHESIS
%right POWER_OPERATOR
%right SIGN_OPERATOR_PLUS SIGN_OPERATOR_MINUS
%left ADDITION_OPERATOR SUBTRACTION_OPERATOR MULTIPLICATION_OPERATOR DIVISION_OPERATOR MODULO_OPERATOR 
%left LESS_THAN_OPERATOR LESS_EQUAL_OPERATOR GREATER_THAN_OPERATOR GREATER_EQUAL_OPERATOR
%left IS_EQUAL_OPERATOR IS_NOT_EQUAL_OPERATOR
%right KEYWORD_NOT
%left KEYWORD_AND KEYWORD_OR
%right ASSIGN_OPERATOR ADD_ASSIGN_OPERATOR SUBTRACT_ASSIGN_OPERATOR MULTIPLY_ASSIGN_OPERATOR DIVIDE_ASSIGN_OPERATOR MODULO_ASSIGN_OPERATOR ARRAY_ASSIGN_OPERATOR


%type <str> program
%type <str> program_template



%type <str> complex_types_declarations
%type <str> const_declarations
%type <str> var_declarations
%type <str> func_definitions
%type <str> main_function



%type <str> data_type
%type <str> basic_type
%type <str> complex_type
%type <str> array_type


%type <str> constant_declaration


%type <str> variable_declaration
%type <str> variable_list


%type <str> statements
%type <str> return_statement
%type <str> empty_statement

%%
program: program_template
    {
    FILE* outputFile = fopen("correct2.c", "w");
        if (yyerror_count == 0) {
            // Print the contents of c_prologue to the file
            fputs(c_prologue, outputFile);

            // Print the value of $1 to the file
            fprintf(outputFile, "%s", $1);
        } else {
            // Print the error message and yyerror_count to the file
            fprintf(outputFile, "Error num: %d", yyerror_count);
        }

        // Close the output file
        fclose(outputFile);
    }
    ;

/*1. Program structure

Complex types declarations
constants declarations
variables declarations
function definitions
main function
*/
program_template:
    complex_types_declarations const_declarations var_declarations func_definitions main_function {$$=template("%s\n%s\n%s\n%s\n%s\n",$1,$2,$3,$4,$5);}
    | complex_types_declarations const_declarations var_declarations main_function {$$=template("%s\n%s\n%s\n%s\n",$1,$2,$3,$4);}
    | complex_types_declarations const_declarations func_definitions main_function {$$=template("%s\n%s\n%s\n%s\n",$1,$2,$3,$4);}
    | complex_types_declarations var_declarations func_definitions main_function {$$=template("%s\n%s\n%s\n%s\n",$1,$2,$3,$4);}
    | const_declarations var_declarations func_definitions main_function {$$=template("%s\n%s\n%s\n%s\n",$1,$2,$3,$4);}
    | complex_types_declarations const_declarations main_function {$$=template("%s\n%s\n%s",$1,$2,$3);}
    | complex_types_declarations var_declarations main_function {$$=template("%s\n%s\n%s",$1,$2,$3);}
    | complex_types_declarations func_definitions main_function {$$=template("%s\n%s\n%s",$1,$2,$3);}
    | const_declarations var_declarations main_function {$$=template("%s\n%s\n%s",$1,$2,$3);}
    | const_declarations func_definitions main_function {$$=template("%s\n%s\n%s",$1,$2,$3);}
    | var_declarations func_definitions main_function {$$=template("%s\n%s\n%s",$1,$2,$3);}
    | complex_types_declarations main_function {$$=template("%s\n%s\n%s",$1,$2);}
    | const_declarations main_function {$$=template("%s\n%s",$1,$2);}
    | var_declarations main_function {$$=template("%s\n%s",$1,$2);}
    | func_definitions main_function {$$=template("%s\n%s",$1,$2);}
    | main_function {$$=template("%s",$1);}
    ;

main_function:
    KEYWORD_MAIN DELIMITER_LEFT_PARENTHESIS DELIMITER_RIGHT_PARENTHESIS DELIMITER_COLON statements KEYWORD_ENDDEF DELIMITER_SEMICOLON
    {$$=template("int main(){\n%s}",$5);}
    ;


/*2. Data types

Basic types: integer,scalar,str,bool
Complex types: All types that occur from a comp 
Array types: Arrays with elements of a basic type

Note: Booleans are treated as integers (True is mapped to 0 and False is mapped to 1)
*/
data_type:
    basic_type {$$=template("%s",$1);}
    | complex_type {$$=template("%s",$1);}
    | array_type {$$=template("%s",$1);}
    ;

basic_type:
    KEYWORD_INTEGER {$$=template("int");}
    | KEYWORD_SCALAR {$$=template("double");}
    | KEYWORD_STR {$$=template("char*");}
    | KEYWORD_BOOL {$$=template("int");}
    ;

complex_type:
    KEYWORD_COMP IDENTIFIER {$$=template("struct %s",$2);}
    ;

array_type:
DELIMITER_LEFT_BRACKET INTEGER_CONSTANT DELIMITER_RIGHT_BRACKET DELIMITER_COLON data_type {$$=template("%s[%d]",$5,$2);}
| DELIMITER_LEFT_BRACKET DELIMITER_RIGHT_BRACKET DELIMITER_COLON data_type {$$=template("%s[]",$4);}
;


/*3. Variables*/
var_declarations:
    var_declarations variable_declaration DELIMITER_SEMICOLON {$$= template("%s\n%s;", $1, $2);}
    | variable_declaration DELIMITER_SEMICOLON {$$ = template("%s;", $1);}
    ;

variable_declaration:
    variable_list DELIMITER_COLON data_type {$$ = template("%s : %s", $1, $3);}
    | IDENTIFIER DELIMITER_LEFT_BRACKET INTEGER_CONSTANT DELIMITER_RIGHT_BRACKET DELIMITER_COLON data_type {$$=template("%s %s[%d]",$6,$1,$3);}
;

variable_list:
    variable_list DELIMITER_COMMA IDENTIFIER {$$ = template("%s, %s", $1, $3);}
    | IDENTIFIER{$$ = template("%s",$1);}
    ;

/*4. Constants*/
const_declarations:
    const_declarations constant_declaration DELIMITER_SEMICOLON {$$=template("%s\n%s",$1,$2);}
    | constant_declaration DELIMITER_SEMICOLON {$$ = template("%s",$1);}
    ;

constant_declaration:
    KEYWORD_CONST IDENTIFIER ASSIGN_OPERATOR INTEGER_CONSTANT DELIMITER_COLON KEYWORD_INTEGER {$$=template("const int %s = %s;",$2,$4);}
    | KEYWORD_CONST IDENTIFIER ASSIGN_OPERATOR FLOATING_POINT_CONSTANT DELIMITER_COLON KEYWORD_SCALAR {$$=template("const double %s = %s;",$2,$4);}
    | KEYWORD_CONST IDENTIFIER ASSIGN_OPERATOR STRING_CONSTANT DELIMITER_COLON KEYWORD_STR {$$=template("const char* %s = %s;",$2,$4);}
    | KEYWORD_CONST IDENTIFIER ASSIGN_OPERATOR BOOLEAN_CONSTANT DELIMITER_COLON KEYWORD_BOOL {$$=template("const int %s = %d;",$2,$4);}
    ;


/*5. Functions*/
func_definitions:
    ;


/*6. Complex structures*/
complex_types_declarations:
    ;


/*7. Expressions*/


/*8. Statements*/
statements:
    return_statement {$$=template("%s",$1);}
    |empty_statement {$$=template("%s",$1);}
    ;

return_statement:
    KEYWORD_RETURN DELIMITER_SEMICOLON {$$=template("return;");}
    ;

empty_statement:
    {$$=template("");}
    | DELIMITER_SEMICOLON
    ;

%%
int main(){
    if(yyparse == 0)
        printf("Rejected\n");
    else
        printf("Your program is syntactically correct!\n");
    return 0;
}