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
%type <num> exp term arithmeticStatement
%type <str> STRING_term 

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
    statement statements {printf("Statements is valid\n");}
    | statement {printf("Statement is valid\n");}
;    

statement: 
    printStatement SEMICOLON {printf("Print statement is valid\n");}
    | assignmentStatement SEMICOLON {printf("Assignment statement is valid\n");}
    | ifStatement {printf("If statement is valid\n");}
    | whileStatement {printf("While statement is valid\n");}
    | callFuncStatement SEMICOLON {printf("Call function statement is valid\n");}
    | arithmeticStatement SEMICOLON {printf("Arithmetic statement is valid\n");}
    | exitStatement {printf("Exit statement is valid\n");}
    | funcStatement {printf("Function statement is valid\n");}
;

    
block: LBRACE statements RBRACE {;}
     ;  
      

ifStatement: IF LPAREN exp RPAREN block                                {if($3 == 1) {;} else {;} }
       | IF LPAREN exp RPAREN block ELSE block                     {if($3 == 1) {;} else {;} }
       | IF LPAREN exp RPAREN block elseifStatement ELSE block         {if($3 == 1) {;} else {;} }
       ;

elseifStatement: ELSEIF LPAREN exp RPAREN block                        {if($3 == 1) ; else ;}
           ; 


whileStatement: WHILE LPAREN exp RPAREN block                          {;}
          ;

funcStatement: FUNC IDENTIFIER LPAREN params RPAREN block              {;}
         ;

callFuncStatement: IDENTIFIER LPAREN params RPAREN                    {;}
              ;

exitStatement: END                            {printf("See you next time\n"); exit(EXIT_SUCCESS);}
         ;
//print
printStatement: PRINT STRING_term           {printf("%s\n", $2);}
          | PRINT exp                   {printf("%d\n", $2);}
          | PRINT NEWLINE               {printf("\n");}
          ;       
            
assignmentStatement : IDENTIFIER ASSIGN exp            {updateSymbolVal($1,$3);}
           | IDENTIFIER ASSIGN assignmentStatement     {;}
           | IDENTIFIER ASSIGN STRING_term    {updateStringsVal($1,$3);}
           ;    

arithmeticStatement : term                     {;} 
                | arithmeticStatement PLUS term {printf("%d\n", $1 + $3);}
                | arithmeticStatement MINUS term {printf("%d\n", $1 - $3);}
                | arithmeticStatement MULTIPLY term {printf("%d\n", $1 * $3);}
                | arithmeticStatement DIVIDE term {printf("%d\n", $1 / $3);}
                ;

exp      : term                             {$$ = $1;}
         | exp PLUS term                     {$$ = $1 + $3;}
         | exp MINUS term                     {$$ = $1 - $3;}
         | exp MULTIPLY term                     {$$ = $1 * $3;}
         | exp DIVIDE term                     {$$ = $1 / $3;}
         | exp MOD term                     {$$ = $1 % $3;} 
         | exp EQUAL term                      {$$ = $1 == $3;}
         | exp NOTEQUAL term                     {$$ = $1 != $3;}
         | exp LESS term                    {$$ = $1 < $3;}
         | exp LESSEQUAL term                 {$$ = $1 <= $3;}
         | exp GREATER term                     {$$ = $1 > $3;}
         | exp GREATEREQUAL term                  {$$ = $1 >= $3;}
         | exp AND term                     {$$ = $1 && $3;}
         | exp OR term                      {$$ = $1 || $3;}
         ;                

term     : NUMBER                           {$$ = $1;}
         | IDENTIFIER                       {$$ = symbolVal($1);}
         ;       

STRING_term  : STRING                       {$$ = $1;}
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