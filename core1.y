%{

void yyerror (char *s);
int yylex();

#include <stdio.h>     
#include <stdlib.h>
#include <ctype.h>

int symbols[52];
int symbolVal(char symbol);
void updateSymbolVal(char symbol, int val);


void printFunction(void *expr);

%}

%union {int num; char id; char *str;}         

%start program

%token START, END, PRINT , AND, OR, NOT, EQUALS, NOTEQUAL, GREATER, LESS, GREATEREQUAL, LESSEQUAL, IF, ELSE, ELSEIF, WHILE, FUNC, RETURN, FUNCNAME, FUNCCALL, ASSIGN, PLUS, MINUS, MULTIPLY, DIVIDE, MOD, LPAREN, RPAREN, LBRACE, RBRACE, COMMA, SEMICOLON, NEWLINE, WS, COMMENT

%token <num> NUMBER
%token <id> IDENTIFIER
%token <str> STRING

%left PLUS, MINUS
%left MULTIPLY, DIVIDE, MOD
%left AND, OR
%left NOT
%left EQUALS, NOTEQUAL, GREATER, LESS, GREATEREQUAL, LESSEQUAL
%left ASSIGN
%left LPAREN, RPAREN, LBRACE, RBRACE, COMMA, SEMICOLON, NEWLINE, WS, COMMENT

%%

program: 
    START statements END {printf("Program is valid\n");}
;

statements:
    statements statement {printf("Statement is valid\n");}
    | statement {printf("Statement is valid\n");}
;

statement:
    printStatements SEMICOLON {printf("Print statement is valid\n");}
    | assignmentStatement SEMICOLON {printf("Assignment statement is valid\n");}
    | ifStatement {printf("If statement is valid\n");}
    | whileStatement {printf("While statement is valid\n");}
    | functionStatement {printf("Function statement is valid\n");}
    | functioncallStatement SEMICOLON {printf("Function call statement is valid\n");}
    | returnStatement SEMICOLON {printf("Return statement is valid\n");}
    | commentStatement {printf("Comment statement is valid\n");}
    | empty {printf("Empty statement is valid\n");}
;


expression:
    expression PLUS expression { $$ = $1 + $3; printf("Expression is valid\n"); }
    | expression MINUS expression { $$ = $1 - $3; printf("Expression is valid\n"); }
    | expression MULTIPLY expression { $$ = $1 * $3; printf("Expression is valid\n"); }
    | expression DIVIDE expression { $$ = $1 / $3.num; printf("Expression is valid\n"); }
    | expression MOD expression { $$ = $1 % $3; printf("Expression is valid\n"); }
    | expression AND expression { $$ = $1 && $3; printf("Expression is valid\n"); }
    | expression OR expression { $$ = $1 || $3; printf("Expression is valid\n"); }
    | expression EQUALS expression { $$ = $1 == $3; printf("Expression is valid\n"); }
    | expression NOTEQUAL expression { $$ = $1 != $3; printf("Expression is valid\n"); }
    | expression GREATER expression { $$ = $1 > $3; printf("Expression is valid\n"); }
    | expression LESS expression { $$ = $1 < $3; printf("Expression is valid\n"); }
    | expression GREATEREQUAL expression { $$ = $1 >= $3; printf("Expression is valid\n"); }
    | expression LESSEQUAL expression { $$ = $1 <= $3; printf("Expression is valid\n"); }
    | LPAREN expression RPAREN { $$ = $2; printf("Expression is valid\n"); }
    | NOT expression { $$ = !$2; printf("Expression is valid\n"); }
    | NUMBER { $$ = $1; printf("Expression is valid\n"); }
    | IDENTIFIER { $$ = symbolVal($1); printf("Expression is valid\n"); }
    | STRING { $$ = $1; printf("Expression is valid\n"); }
    | functioncallStatement { $$ = $1; printf("Expression is valid\n"); }
    | empty {printf("Expression is valid\n");}
;    

block:
    LBRACE statements RBRACE {printf("Block is valid\n");}
;

empty: 
    {printf("Empty is valid\n");}
;

printStatements:
    PRINT LPAREN printStatement RPAREN {printf("Print statement is valid\n");}
;

printStatement:
    expression {printFunction($1);};
    | NEWLINE {printf("\n"};
    | WS {printf("\t"};
    | empty {printf("Print statement is valid\n");}
;    

assignmentStatement:
    IDENTIFIER ASSIGN expression {printf("Assignment is valid\n");}
;

ifStatement:
    IF LPAREN expression RPAREN block {printf("If is valid\n");}
    | IF LPAREN expression RPAREN block ELSE block {printf("If is valid\n");}
    | IF LPAREN expression RPAREN block elseIfStatement LPAREN expression RPAREN block {printf("If is valid\n");}
    | IF LPAREN expression RPAREN block elseIfStatement LPAREN expression RPAREN block ELSE block {printf("If is valid\n");}
;

elseIfStatement:
    ELSEIF LPAREN expression RPAREN block {printf("Else if is valid\n");}
    | ELSEIF LPAREN expression RPAREN block elseIfStatement {printf("Else if is valid\n");}
;    

whileStatement:
    WHILE LPAREN expression RPAREN block {printf("While is valid\n");}
;

functionStatement:
    FUNC FUNCNAME LPAREN functionParameters RPAREN block {printf("Function is valid\n");}
;

functioncallStatement:
    FUNCNAME LPAREN functionCallParameters RPAREN {printf("Function call is valid\n");}
;

returnStatement:
    RETURN expression {printf("Return is valid\n");}
;

commentStatement:
    COMMENT {printf("Comment is valid\n");}
;

functionParameters:
    functionParameters COMMA functionParameter {printf("Function parameters is valid\n");}
    | functionParameter {printf("Function parameters is valid\n");}
;

functionParameter:
    IDENTIFIER {printf("Function parameter is valid\n");};
    | empty {printf("Function parameter is valid\n");}
;  

functionCallParameters:
    functionCallParameters COMMA functionCallParameter {printf("Function call parameters is valid\n");}
    | functionCallParameter {printf("Function call parameters is valid\n");}
;

functionCallParameter:
    expression {printf("Function call parameter is valid\n");};
    | empty {printf("Function call parameter is valid\n");}
;


%%


void printFunction(void *expr) {
    if (expr == NULL) {
        printf("Expression is empty\n");
    } else if (*(int*)expr) {
        printf("Integer: %d\n", *(int*)expr);
    } else if (*(float*)expr) {
        printf("Float: %f\n", *(float*)expr);
    } else if (*(bool*)expr) {
        printf("Boolean: %s\n", (*(bool*)expr) ? "true" : "false");
    } else if (*(char**)expr) {
        printf("String: %s\n", *(char**)expr);
    } else {
        printf("Unknown type\n");
    }
}


int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol, int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

extern int lineCounter;

void yyerror (char *s) {
    printf ("%s on line %d\n", s, lineCounter);
    fprintf (stderr, "%s\n", s);
    exit (EXIT_FAILURE);
}
