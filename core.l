%{
#include "y.tab.h"
#include "string.h"
int progCounter = 1;
void yyerror (char *s);
int yylex();
%}

text (\"[^\"]*\")
character (\'[^\']\')
integer ([-+]?[0-9]+)
float ([-+]?[0-9]*(\.)?[0-9]+)
boolean (true|false)
IO (writeFile|readFile)

INT_TYPE intel
FLOAT_TYPE float
STRING_TYPE text
BOOLEAN_TYPE flag
CHAR_TYPE char
final const

func func
void empty

comment  \(\(.|\n)?\*\)

var [a-zA-Z_$][a-zA-Z0-9_'$]*


%%
\+                      { return PLUS_OP ; }
\-                      { return MINUS_OP ; }
\*                      { return MULTIPLY_OP ; }
\/                      { return DIVIDE_OP ; }
{integer}               { return INTEGER ; }
{float}                 { return FLOAT ; }
{text}                  { return STRING ; } 
{character}             { return CHARACTER ; } 
{boolean}               { return BOOLEAN ; } 
{INT_TYPE}              { return INT_TYPE ; }
{FLOAT_TYPE}            { return FLOAT_TYPE ; }
{STRING_TYPE}           { return STRING_TYPE ; }
{BOOLEAN_TYPE}          { return BOOLEAN_TYPE ; }
{CHAR_TYPE}             { return CHAR_TYPE ; }
{final}                 { return CONSTANT ; }
{func}                  { return FUNCTION ; }
{void}                  { return VOID_TYPE ; }
return                  { return RETURN ; }
or                      { return OR_OP ; }
and                     { return AND_OP ; }
\=                      { return ASSIGN_OP ; }
mod                     { return MOD_OP ; }
\!\=                    { return NOT_EQUAL_CHECK ; }
\=\=                    { return EQUALITY_CHECK ; }
\>                      { return GREATER_OP ; }
\<                      { return SMALLER_OP ; }
\>=                     { return GREATER_OR_EQUAL_OP ; }
\<=                     { return SMALLER_OR_EQUAL_OP ; }
\!                      { return NOT_OP ; }
if                      { return IF_STMT ; }
else                    { return ELSE_STMT ; }
elif                    { return ELSE_IF_STMT ; }
for                     { return FOR_LOOP ; }
while                   { return WHILE_LOOP ; }
{IO}                    { return IO_OP ; }
{comment}               { return COMMENT ; }
print                   { return PRINT ; }
RUN                     { return RUN_PROG ; }
FINISH                  { return FINISH_PROG ; }
\{                      { return OPEN_CURLY ; }
\}                      { return CLOSE_CURLY ; }
\(                      { return OPEN_PARENTHESIS ; }
\)                      { return CLOSE_PARENTHESIS ; }
\;                      { return SEMICOLON ; }
\,                      { return COMMA ; }
{var}                   { return VARIABLE ; }
[ \t]                   /* Ignore whitespace */
.                       { return Syntax Error! ; }

%%

int yywrap (void) {return 1;}