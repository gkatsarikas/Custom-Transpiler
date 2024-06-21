%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <math.h>
    #include "cgen.h"

    extern int yylex();

    /*Flag to determine whether a variable is from a comp*/

%}

%union{
    char *str;
    int int_val;
    double double_val;
}

%token <str> IDENTIFIER
%token <str> INTEGER_CONSTANT 
%token <double_val> SCALAR_CONSTANT 
%token <str> STRING_CONSTANT 
%token <str> BOOLEAN_CONSTANT

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

%token POWER_OPERATOR

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
%right HASHTAG_ASSIGN_OPERATOR

%nonassoc KEYWORD_ELSE

%start program


%type <str> program
%type <str> program_template

%type <str> identifiers

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
%type <str> function_definition
%type <str> function_parameters
%type <str> function_body
%type <str> complex_type_structure
%type <str> member_variables
%type <str> member_variable_declaration
%type <str> member_variable_list

%type <str> expression
%type <str> arithmetic_expression
%type <str> logical_expression
%type <str> relational_expression


%type <str> statements
%type <str> statement
%type <str> assign_statement
%type <str> if_statement
%type <str> for_loop_statement
%type <str> array_from_integer
%type <str> array_from_array
%type <str> while_loop_statement
%type <str> break_statement
%type <str> continue_statement
%type <str> return_statement
%type <str> function_call_statement
%type <str> function_arguments
%type <str> empty_statement



%%
program: program_template
    {
    FILE* outputFile = fopen("output.c", "w");
        if (yyerror_count == 0) {
            //Include necessary files for correct syntax
            fprintf(outputFile,"%s",c_prologue);

            fprintf(outputFile, "%s", $1);
        } 
        else {
            fprintf(outputFile, "Error num: %d", yyerror_count);
        }

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
    KEYWORD_DEF KEYWORD_MAIN DELIMITER_LEFT_PARENTHESIS DELIMITER_RIGHT_PARENTHESIS DELIMITER_COLON function_body KEYWORD_ENDDEF DELIMITER_SEMICOLON
    {$$=template("int main(){\n\t%s\n};",$6);}
    ;

identifiers:
    IDENTIFIER {$$=template("%s",$1);}
    | identifiers DELIMITER_COMMA IDENTIFIER {$$=template("%s,%s",$1,$3);}

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
    identifiers DELIMITER_COLON data_type {$$ = template("%s %s", $3, $1);}
    | IDENTIFIER DELIMITER_LEFT_BRACKET INTEGER_CONSTANT DELIMITER_RIGHT_BRACKET DELIMITER_COLON data_type {$$=template("%s %s[%d]",$6,$1,$3);}
;



/*4. Constants*/
const_declarations:
    const_declarations constant_declaration DELIMITER_SEMICOLON {$$=template("%s\n%s",$1,$2);}
    | constant_declaration DELIMITER_SEMICOLON {$$ = template("%s",$1);}
    ;
constant_declaration:
    KEYWORD_CONST IDENTIFIER ASSIGN_OPERATOR INTEGER_CONSTANT DELIMITER_COLON KEYWORD_INTEGER {$$=template("const int %s = %d;",$2,$4);}
    | KEYWORD_CONST IDENTIFIER ASSIGN_OPERATOR SCALAR_CONSTANT DELIMITER_COLON KEYWORD_SCALAR {$$=template("const double %s = %lf;",$2,$4);}
    | KEYWORD_CONST IDENTIFIER ASSIGN_OPERATOR STRING_CONSTANT DELIMITER_COLON KEYWORD_STR {$$=template("const char* %s = %s;",$2,$4);}
    | KEYWORD_CONST IDENTIFIER ASSIGN_OPERATOR BOOLEAN_CONSTANT DELIMITER_COLON KEYWORD_BOOL {$$=template("const int %s = %s;",$2,$4);}
    ;
/*5. Functions
Function structure in Lambda
def func_name(function parameters)->return type:
    function body (variables and constant declaration is optional but statements are mandatory)
    return expression; (also optional)
enddef;
*/
func_definitions:
    function_definition {$$=template("%s",$1);}
    | func_definitions function_definition {$$=template("%s %s",$1,$2);}
    ;
function_definition:
    KEYWORD_DEF IDENTIFIER DELIMITER_LEFT_PARENTHESIS function_parameters DELIMITER_RIGHT_PARENTHESIS ARROW_OPERATOR data_type DELIMITER_COLON
    function_body 
    KEYWORD_ENDDEF DELIMITER_SEMICOLON{$$=template("%s %s(%s){\n%s\n}",$7,$2,$4,$9);}
    | KEYWORD_DEF IDENTIFIER DELIMITER_LEFT_PARENTHESIS function_parameters DELIMITER_RIGHT_PARENTHESIS ARROW_OPERATOR data_type DELIMITER_COLON
    function_body KEYWORD_RETURN DELIMITER_SEMICOLON
    KEYWORD_ENDDEF DELIMITER_SEMICOLON{$$=template("%s %s(%s){\n%s\n}",$7,$2,$4,$9);}
    | KEYWORD_DEF IDENTIFIER DELIMITER_LEFT_PARENTHESIS function_parameters DELIMITER_RIGHT_PARENTHESIS DELIMITER_COLON 
    function_body KEYWORD_ENDDEF DELIMITER_SEMICOLON {$$=template("void %s(%s){\n%s\n}\n",$2,$4,$7);}
    ;
function_parameters:
    %empty {$$=template("");}
    | variable_declaration {$$=template("%s",$1);}
    | function_parameters DELIMITER_COMMA variable_declaration {$$=template("%s, %s",$1,$3);}
    ;
function_body:
    var_declarations constant_declaration statements {$$=template("%s\n%s\n%s\n",$1,$2,$3);}
    | var_declarations statements {$$=template("\t%s\n%s\n",$1,$2);}
    | const_declarations statements {$$=template("\t%s\n%s\n",$1,$2);}
    | statements {$$=template("\t%s\n",$1);}
    ;
/*6. Complex structures
comp comp_name:
    variables declaration (member variables, they begin with #)
    functions (methods)
endcomp;
*/
complex_types_declarations:
    complex_type_structure {$$=template("%s",$1);}
    | complex_types_declarations complex_type_structure {$$=template("%s\n%s",$1,$2);}
    ;
complex_type_structure:
    KEYWORD_COMP IDENTIFIER DELIMITER_COLON member_variables func_definitions KEYWORD_ENDCOMP DELIMITER_SEMICOLON {$$=template("typedef struct %s{\n%s\n}\n%s;\n%s",$2,$4,$2,$5);}
    | KEYWORD_COMP IDENTIFIER DELIMITER_COLON member_variables KEYWORD_ENDCOMP DELIMITER_SEMICOLON {$$=template("typedef struct %s{\n%s\n}%s;",$2,$4,$2);}
    ;
/*Similar to variables but they must begin with HASH (#)*/
member_variables:
    member_variable_declaration {$$=template("%s",$1);}
    | member_variables member_variable_declaration {$$=template("%s\n%s",$1,$2);}
    ;

member_variable_declaration:
    member_variable_list DELIMITER_COLON data_type DELIMITER_SEMICOLON {$$=template("%s %s;",$3,$1);}
    ;

member_variable_list:
    member_variable_list DELIMITER_COMMA HASHTAG_ASSIGN_OPERATOR IDENTIFIER  {$$ = template("%s, %s", $1, $4);}
    | HASHTAG_ASSIGN_OPERATOR IDENTIFIER{$$ = template("%s",$2);}
    ;




/*7. Expressions*/
expression:
    IDENTIFIER {$$=template("%s",$1);}
    | HASHTAG_ASSIGN_OPERATOR IDENTIFIER {$$=template("%s",$2);}
    | KEYWORD_TRUE {$$=template("1");}
    | KEYWORD_FALSE {$$=template("0");}
    | DELIMITER_LEFT_PARENTHESIS expression DELIMITER_RIGHT_PARENTHESIS {$$=template("(%s)",$2);}
    | DELIMITER_LEFT_BRACKET expression DELIMITER_RIGHT_BRACKET {$$=template("[%s]",$2);}
    | arithmetic_expression {$$=template("%s",$1);}
    | logical_expression {$$=template("%s",$1);}
    | relational_expression {$$=template("%s",$1);}
    | IDENTIFIER DELIMITER_LEFT_PARENTHESIS function_arguments DELIMITER_RIGHT_PARENTHESIS {$$=template("%s(%s)",$1,$3);}
    ;

arithmetic_expression:
    INTEGER_CONSTANT {$$=template("%d",$1);}
    | SCALAR_CONSTANT {$$=template("%lf",$1);}
    | STRING_CONSTANT {$$=template("%s",$1);}
    | BOOLEAN_CONSTANT {$$=$1;}
    | expression ADDITION_OPERATOR expression {$$=template("%s + %s",$1,$3);} %prec ADDITION_OPERATOR
    | expression SUBTRACTION_OPERATOR expression {$$=template("%s - %s",$1,$3);} %prec SUBTRACTION_OPERATOR
    | expression MULTIPLICATION_OPERATOR expression {$$=template("%s * %s",$1,$3);}
    | expression DIVISION_OPERATOR expression {$$=template("%s / %s",$1,$3);}
    | expression MODULO_OPERATOR expression {$$=template("%s %% %s",$1,$3);}
    | expression POWER_OPERATOR expression {$$=template("pow(%s,%s)",$1,$3);}
    | SIGN_OPERATOR_PLUS expression {$$=template("+%s",$2);} %prec SIGN_OPERATOR_PLUS
    | SIGN_OPERATOR_MINUS expression {$$=template("-%s",$2);} %prec SIGN_OPERATOR_MINUS
    ;


logical_expression:
    expression KEYWORD_AND expression {$$=template("%s && %s",$1,$3);}
    | expression KEYWORD_OR expression {$$=template("%s && %s",$1,$3);}
    | KEYWORD_NOT expression {$$=template("!%s",$2);}
    ;

relational_expression:
    expression IS_EQUAL_OPERATOR expression {$$=template("%s == %s",$1,$3);}
    | expression IS_NOT_EQUAL_OPERATOR expression {$$=template("%s != %s",$1,$3);}
    | expression LESS_THAN_OPERATOR expression {$$=template("%s < %s",$1,$3);}
    | expression LESS_EQUAL_OPERATOR expression {$$=template("%s <= %s",$1,$3);}
    | expression GREATER_THAN_OPERATOR expression {$$=template("%s > %s",$1,$3);}
    | expression GREATER_EQUAL_OPERATOR expression {$$=template("%s >= %s",$1,$3);}
    ;

/*8. Statements*/
statement:
    assign_statement {$$=template("%s",$1);}
    | if_statement {$$=template("%s",$1);}
    | for_loop_statement {$$=template("%s",$1);}
    | array_from_integer {$$=template("%s",$1);}
    | array_from_array {$$=template("%s",$1);}
    | while_loop_statement {$$=template("%s",$1);}
    | break_statement {$$=template("%s",$1);}
    | continue_statement {$$=template("%s",$1);}
    | return_statement {$$=template("%s",$1);}
    | function_call_statement {$$=template("%s",$1);}
    | empty_statement {$$=template("%s",$1);}
    ;

statements:
    statement {$$=template("%s",$1);}
    | statement statements {$$=template("%s\n%s",$1,$2);}
    ;

empty_statement:
    DELIMITER_SEMICOLON {$$=template(";");}
    ;

    

assign_statement:
    IDENTIFIER ASSIGN_OPERATOR expression DELIMITER_SEMICOLON {$$=template("%s = %s;\n", $1, $3);}
    | IDENTIFIER DELIMITER_LEFT_BRACKET IDENTIFIER DELIMITER_RIGHT_BRACKET ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s[%s] = %s;\n", $1, $3, $6); }
    | HASHTAG_ASSIGN_OPERATOR IDENTIFIER ASSIGN_OPERATOR expression DELIMITER_SEMICOLON {$$=template("%s = %s;\n", $2, $4);}
    | IDENTIFIER ADD_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s += %s;\n", $1, $3); }
    | IDENTIFIER SUBTRACT_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s -= %s;\n", $1, $3); }
    | IDENTIFIER MULTIPLY_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s *= %s;\n", $1, $3); }
    | IDENTIFIER DIVIDE_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s /= %s;\n", $1, $3); }
    | IDENTIFIER MODULO_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s %%= %s;\n", $1, $3); }
    | IDENTIFIER ARRAY_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON {$$=template("%s := [%s];\n",$1,$3);}
    | HASHTAG_ASSIGN_OPERATOR IDENTIFIER ADD_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s += %s;\n", $2, $4); }
    | HASHTAG_ASSIGN_OPERATOR IDENTIFIER SUBTRACT_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s -= %s;\n", $2, $4); }
    | HASHTAG_ASSIGN_OPERATOR IDENTIFIER MULTIPLY_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s *= %s;\n", $2, $4); }
    | HASHTAG_ASSIGN_OPERATOR IDENTIFIER DIVIDE_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s /= %s;\n", $2, $4); }
    | HASHTAG_ASSIGN_OPERATOR IDENTIFIER MODULO_ASSIGN_OPERATOR expression DELIMITER_SEMICOLON { $$ = template("%s %%= %s;\n", $2, $4); }
    | IDENTIFIER ASSIGN_OPERATOR function_call_statement DELIMITER_SEMICOLON {$$ = template("%s = %s;", $1, $3);}
    ;

if_statement:
    KEYWORD_IF DELIMITER_LEFT_PARENTHESIS expression DELIMITER_RIGHT_PARENTHESIS DELIMITER_COLON statements KEYWORD_ENDIF DELIMITER_SEMICOLON {$$=template("if(%s){\n%s\n}\n",$3,$6);}
    | KEYWORD_IF DELIMITER_LEFT_PARENTHESIS expression DELIMITER_RIGHT_PARENTHESIS DELIMITER_COLON statements KEYWORD_ELSE DELIMITER_COLON statements KEYWORD_ENDIF DELIMITER_SEMICOLON {$$=template("if(%s){\n%s\n}\nelse{\n%s\n}",$3,$6,$9);}
    ;

for_loop_statement:
    KEYWORD_FOR IDENTIFIER KEYWORD_IN DELIMITER_LEFT_BRACKET arithmetic_expression DELIMITER_COLON arithmetic_expression DELIMITER_RIGHT_BRACKET DELIMITER_COLON statements KEYWORD_ENDFOR DELIMITER_SEMICOLON 
    {$$=template("\nfor(int %s=%s;%s<=%s;%s+=1){\n\t%s\n}",$2,$5,$2,$7,$2,$10); }
    | KEYWORD_FOR IDENTIFIER KEYWORD_IN DELIMITER_LEFT_BRACKET arithmetic_expression DELIMITER_COLON arithmetic_expression DELIMITER_COLON arithmetic_expression DELIMITER_RIGHT_BRACKET DELIMITER_COLON statements KEYWORD_ENDFOR DELIMITER_SEMICOLON 
    {$$=template("\nfor(int %s=%s;%s<=%s && %s>=-%s;%s+=%s){\n\t%s\n}",$2,$5,$2,$7,$2,$7,$2,$9,$12); }  
    ;

array_from_integer:
    IDENTIFIER ARRAY_ASSIGN_OPERATOR DELIMITER_LEFT_BRACKET expression KEYWORD_FOR IDENTIFIER DELIMITER_COLON INTEGER_CONSTANT DELIMITER_RIGHT_BRACKET
    DELIMITER_COLON data_type DELIMITER_SEMICOLON
    {$$ = template("\n%s* %s = (%s*)malloc(%d*sizeof(%s));\nfor(int %s = 0; %s < %d; ++%s) {\n\t%s[%s] = %s;\n}", $11, $1, $11, $8,$11, $6, $6, $8, $6, $1, $6, $4);}
    ;

array_from_array:
    IDENTIFIER ARRAY_ASSIGN_OPERATOR DELIMITER_LEFT_BRACKET expression KEYWORD_FOR IDENTIFIER DELIMITER_COLON data_type KEYWORD_IN
    IDENTIFIER KEYWORD_OF INTEGER_CONSTANT DELIMITER_RIGHT_BRACKET DELIMITER_COLON data_type DELIMITER_SEMICOLON
    {$$=template("%s* %s = (%s*)malloc(%d*sizeof(%s));\n\nfor(int a_i=0; a_i<%d; ++a_i){\n%s[a_i]=%s;}",$15,$1,$15,$12,$15,$12,$4);}
    ;

while_loop_statement:
    KEYWORD_WHILE DELIMITER_LEFT_PARENTHESIS expression DELIMITER_RIGHT_PARENTHESIS DELIMITER_COLON statements KEYWORD_ENDWHILE
    {$$=template("while(%s){\n%s\n};\n",$3,$6);}
    ;

break_statement:
    KEYWORD_BREAK  {$$=template("break");}
    ;    

continue_statement:
    KEYWORD_CONTINUE {$$=template("continue");}
    ;

return_statement:
    KEYWORD_RETURN DELIMITER_SEMICOLON    { $$ = template("return;"); }
    | KEYWORD_RETURN expression DELIMITER_SEMICOLON    { $$ = template("return %s;", $2); }
    ;



function_call_statement:
    IDENTIFIER DELIMITER_LEFT_PARENTHESIS function_arguments DELIMITER_RIGHT_PARENTHESIS 
    {$$=template("%s(%s)",$1,$3);}
    ;

function_arguments:
    %empty {$$=template("");}
    | expression {$$=template("%s",$1);}
    | function_arguments DELIMITER_COMMA expression {$$=template("%s,%s",$1,$3);}
    ;

%%
int main() {
    if ( yyparse() == 0 )
        printf("Accepted!\n");
    else
        printf("Rejected!\n");
}