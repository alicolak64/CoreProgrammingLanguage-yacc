%{
#include "y.tab.h"
#include "string.h"
int lineCounter = 1;
void yyerror (char *s);
int yylex();

%}


START (START)([^a-zA-Z0-9])
END END
PRINT PRINT:
IDENTIFIER [a-zA-Z]
STRING  \".*\"
NUMBER [0-9]+
BOOLEAN true|false
AND AND([^a-zA-Z0-9])
OR OR([^a-zA-Z0-9])
NOT NOT([^a-zA-Z0-9])
NOTEQUAL !=
IF IF([^a-zA-Z0-9])
ELSE ELSE([^a-zA-Z0-9])
ELSEIF ELSEIF([^a-zA-Z0-9])
WHILE WHILE([^a-zA-Z0-9])
FUNC FUNC([^a-zA-Z0-9])
FUNCNAME [a-z]+[:]
FUNCCALL [a-z]+[(] 
RETURN RETURN([^a-zA-Z0-9])
EQUALS == 
GREATER >
LESS <
GREATEREQUAL >=
LESSEQUAL <=
ASSIGN =
PLUS \+
MINUS -
MULTIPLY \*
DIVIDE /
MOD %
LPAREN [(]
RPAREN [)]
LBRACE [{]
RBRACE [}]
SEMICOLON ;
COMMA ,
NEWLINE \n
WS [ \t]+
COMMENT \/\/.*\n

%%

{START} {return START;}
{END} {return END;}
{PRINT} {return PRINT;}
{AND} {return AND;}
{OR} {return OR;}
{NOT} {return NOT;}
{EQUALS} {return EQUALS;}
{NOTEQUAL} {return NOTEQUAL;}
{GREATER} {return GREATER;}
{LESS} {return LESS;}
{GREATEREQUAL} {return GREATEREQUAL;}
{LESSEQUAL} {return LESSEQUAL;}
{IF} {return IF;}
{ELSE} {return ELSE;}
{ELSEIF} {return ELSEIF;}
{WHILE} {return WHILE;}
{FUNC} {return FUNC;}
{RETURN} {return RETURN;}
{IDENTIFIER} {yylval.id = yytext[0]; return IDENTIFIER;}
{STRING} {yylval.str = strdup(yytext); return STRING;}
{NUMBER} {yylval.num = atoi(yytext); return NUMBER;}
{BOOLEAN} {yylval.boolean = (strcmp(yytext, "true") == 0) ? 1 : 0; return BOOLEAN;}
{FUNCNAME} {yylval.str = strdup(yytext); return FUNCNAME;}
{FUNCCALL} {yylval.str = strdup(yytext); return FUNCCALL;}
{ASSIGN} {return ASSIGN;}
{PLUS} {return PLUS;}
{MINUS} {return MINUS;}
{MULTIPLY} {return MULTIPLY;}
{DIVIDE} {return DIVIDE;}
{MOD} {return MOD;}
{LPAREN} {return LPAREN;}
{RPAREN} {return RPAREN;}
{LBRACE} {return LBRACE;}
{RBRACE} {return RBRACE;}
{SEMICOLON} {return SEMICOLON;}
{COMMA} {return COMMA;}
{NEWLINE} {lineCounter++; return NEWLINE;}
{WS} {;}
{COMMENT} {;}
[=+*/-] {return yytext[0];}
.       {ECHO; yyerror ("unexpected character");}

%%

int yywrap (void) {
    return 1;
}
