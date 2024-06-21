# Custom-Transpiler
This repository contains an implementation of a source to source compiler for the imaginary language Lambda. This transpiler consists of the following parts:

## 1. Lexical analyzer
Implemented using flex. Its purpose is to recognize tokens and regular expressions. Additionally, it is used to define constants through @defmacro <identifier> <value>


## 2. Syntax analyzer
Implemented using bison. In the first part, we define operators,delimiters, keywords as well as the operation precedence and associativity. 
In the second part (rules), we define the grammar we are going to use. For the purpose of this task, we use the function template() which is
a function that maps a rule from Lambda to its C equivalent. This function is provided from the file cgen.h, a header file that includes some
helper variables and functions.


The program can be executed by simply typing the following commands:

make
./mycompiler < correct1.la
gcc -std=c99 -Wall output.c -lm
./a.out

where correct1.la is a file provided with the code. This works for any file with the extension .la .
