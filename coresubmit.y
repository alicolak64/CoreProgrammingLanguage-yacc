%{
void yyerror (char const *s);
int yylex();
#include <stdio.h>   
#include <time.h>  
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
//default symbols
int symbols[52];
char *strings[52];
int symbolVal(char symbol);
double runTime(void (*fx)(void));
void updateSymbolVal(char symbol, int val);
void updateStringsVal(char symbol, char *val);
int computeSymbolIndex(char token);
char *stringsVal(char symbol);


//calculating functions
%}

%union {
    int num; 
    char id; 
    char *str;
}

%start program

%token START END PRINT NEWLINE COMMENT
%token ASSIGN PLUS MINUS MULTIPLY DIVIDE MOD AND OR NOT
%token EQUAL NOTEQUAL GREATER LESS GREATEREQUAL LESSEQUAL
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON COMMA
%token IF ELSE ELSEIF WHILE FUNC

%token <id> IDENTIFIER
%token <str> STRING
%token <num> NUMBER

%type <id> assignmentStatement 
%type <num> expression term arithmeticStatement
%type <str> stringTerm 

%left PLUS MINUS
%left MULTIPLY DIVIDE MOD
%left AND OR NOT ASSIGN
%left EQUALS NOTEQUAL GREATER LESS GREATEREQUAL LESSEQUAL
%left LPAREN RPAREN LBRACE RBRACE COMMA SEMICOLON NEWLINE COMMENT
 
%%



program: 
    START statements END {printf("Program is valid\n");}
;

statements: 
    statement statements {;}
    | statement {;}
;    

statement: 
    printStatement SEMICOLON {;}
    | assignmentStatement SEMICOLON {;}
    | ifStatement {;}
    | whileStatement {;}
    | callFuncStatement SEMICOLON {;}
    | arithmeticStatement SEMICOLON {;}
    | exitStatement {;}
    | funcStatement {;}
;

term: 
    NUMBER {$$ = $1;}
    | IDENTIFIER {$$ = symbolVal($1);}

stringTerm: 
    STRING {$$ = $1;}
    | IDENTIFIER {$$ = stringsVal($1);}

expression: 
    term {$$ = $1;}
    | expression PLUS expression {$$ = $1 + $3;}
    | expression MINUS expression {$$ = $1 - $3;}
    | expression MULTIPLY expression {$$ = $1 * $3;}
    | expression DIVIDE expression { 
        if ($3 == 0) {
            yyerror("Error: Cannot divide by 0\n");
        } else {
            $$ = $1 / $3; printf("Expression is valid\n"); 
        }
    }
    | expression MOD expression {$$ = $1 % $3;} 
    | expression EQUAL expression {$$ = $1 == $3;}
    | expression NOTEQUAL expression {$$ = $1 != $3;}
    | expression LESS expression {$$ = $1 < $3;}
    | expression LESSEQUAL expression {$$ = $1 <= $3;}
    | expression GREATER expression {$$ = $1 > $3;}
    | expression GREATEREQUAL expression {$$ = $1 >= $3;}
    | expression AND expression {$$ = $1 && $3;}
    | expression OR expression {$$ = $1 || $3;}
    | NOT expression {$$ = !$2;}
    | LPAREN expression RPAREN {$$ = $2;}
;
    
block:
    LBRACE statements RBRACE {;}
;

printStatement:
    PRINT stringTerm {printf("%s\n", $2);}
    | PRINT expression {printf("%d\n", $2);}
    | PRINT NEWLINE {printf("\n");}
;
      

ifStatement: IF LPAREN expression RPAREN block                                {if($3 == 1) {;} else {;} }
       | IF LPAREN expression RPAREN block ELSE block                     {if($3 == 1) {;} else {;} }
       | IF LPAREN expression RPAREN block elseifStatement ELSE block         {if($3 == 1) {;} else {;} }
       ;

elseifStatement: ELSEIF LPAREN expression RPAREN block                        {if($3 == 1) ; else ;}
           ; 


whileStatement: WHILE LPAREN expression RPAREN block                          {;}
          ;

funcStatement: FUNC IDENTIFIER LPAREN params RPAREN block              {;}
         ;

callFuncStatement: IDENTIFIER LPAREN params RPAREN                    {;}
              ;

exitStatement: END                            {printf("See you next time\n"); exit(EXIT_SUCCESS);}
         ; 
            
assignmentStatement : IDENTIFIER ASSIGN expression            {updateSymbolVal($1,$3);}
           | IDENTIFIER ASSIGN assignmentStatement     {;}
           | IDENTIFIER ASSIGN stringTerm    {updateStringsVal($1,$3);}
           ;    

arithmeticStatement : term                     {;} 
                | arithmeticStatement PLUS term {printf("%d\n", $1 + $3);}
                | arithmeticStatement MINUS term {printf("%d\n", $1 - $3);}
                | arithmeticStatement MULTIPLY term {printf("%d\n", $1 * $3);}
                | arithmeticStatement DIVIDE term {printf("%d\n", $1 / $3);}
                ;              

      

params   : param                      {;}
         | params COMMA param            {;}
         ;
                    
param : IDENTIFIER COMMA COMMA           
       
%%

int computeSymbolIndex(char token)
{
    int idx = -1;
    if(islower(token)){
        idx = token - 'a' + 26;
    }
    else if(isupper(token)){
        idx = token - 'A';
    }
    return idx;
}

int symbolVal(char symbol)
{
    int idx = computeSymbolIndex(symbol);
    if(idx == -1){
        printf("Symbol %c not found\n", symbol);
        exit(EXIT_FAILURE);
    }
    return symbols[idx];
}

char *stringsVal(char symbol)
{
    int idx = computeSymbolIndex(symbol);
    if(idx == -1){
        printf("Symbol %c not found\n", symbol);
        exit(EXIT_FAILURE);
    }
    printf("%s\n", strings[idx]);
    return strings[idx];
}


void updateSymbolVal(char symbol, int val)
{
    int idx = computeSymbolIndex(symbol);
    if(idx == -1){
        printf("Symbol %c not found\n", symbol);
        exit(EXIT_FAILURE);
    }
    symbols[idx] = val;
}
void updateStringsVal(char symbol, char *val)
{
    int idx = computeSymbolIndex(symbol);
    if(idx == -1){
        printf("Symbol %c not found\n", symbol);
        exit(EXIT_FAILURE);
    }
    strings[idx] = val;
}

int main(void){
    int i;
    for(i = 0; i < 52; i++){
        symbols[i] = 0;
        strings[i] = "";
    }
return yyparse();
}

void yyerror(char const *s)
{
    fprintf(stderr, "%s\n", s);
}