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

%union {int num; char id; char *str;}
%start prog
%token START END PRINT LPAREN RPAREN LBRACE RBRACE
%token PLUS MINUS MULTIPLY DIVIDE MOD EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL AND OR FUNC NEWLINE 
%token IF ELSE ELSEIF WHILE
%token COMMENT ASSIGN NOT SEMICOLON COMMA
%token <id> IDENTIFIER
%token <str> STRING
%token <num> NUMBER
%type <id> assignment 
%type <num> exp term arithmetic_stmt
%type <str> STRING_term 
%left '+' '-'
%left '*' '/' 
%%



prog: START stmts END {;}
    ;

stmts: stmt stmts
     | stmt
     ;    

stmt: non_block_stmt
    | block_stmt
    ;

non_block_stmt: assignment  SEMICOLON      {;}
              | stmt_print
              | stmt_exit
              | arithmetic_stmt
              | call_func_stmt
              ;

block_stmt: if_stmt                  {}
          | while_stmt               {}
          | func_stmt                {}
          ;
    
block: LBRACE stmts RBRACE {;}
     ;  
      

if_stmt: IF LPAREN exp RPAREN block                                {if($3 == 1) {;} else {;} }
       | IF LPAREN exp RPAREN block ELSE block                     {if($3 == 1) {;} else {;} }
       | IF LPAREN exp RPAREN block elseif_stmt ELSE block         {if($3 == 1) {;} else {;} }
       ;

elseif_stmt: ELSEIF LPAREN exp RPAREN block                        {if($3 == 1) ; else ;}
           ; 


while_stmt: WHILE LPAREN exp RPAREN block                          {;}
          ;

func_stmt: FUNC IDENTIFIER LPAREN params RPAREN block              {;}
         ;

call_func_stmt: IDENTIFIER LPAREN params RPAREN                    {;}
              ;

stmt_exit: END                            {printf("See you next time\n"); exit(EXIT_SUCCESS);}
         ;
//print
stmt_print: PRINT STRING_term SEMICOLON          {printf("%s\n", $2);}
          | PRINT exp SEMICOLON                  {printf("%d\n", $2);}
          | PRINT NEWLINE SEMICOLON              {printf("\n");}
          ;       
            
assignment : IDENTIFIER ASSIGN exp            {updateSymbolVal($1,$3);}
           | IDENTIFIER ASSIGN assignment     {;}
           | IDENTIFIER ASSIGN STRING_term    {updateStringsVal($1,$3);}
           ;    

arithmetic_stmt : term                     {;} 
                | arithmetic_stmt PLUS term {printf("%d\n", $1 + $3);}
                | arithmetic_stmt MINUS term {printf("%d\n", $1 - $3);}
                | arithmetic_stmt MULTIPLY term {printf("%d\n", $1 * $3);}
                | arithmetic_stmt DIVIDE term {printf("%d\n", $1 / $3);}
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