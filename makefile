core  : core.l core.y
		yacc -d core.y
		lex core.l
		gcc -o core lex.yy.c y.tab.c -ll

run :  core
		./core < exampleprog1.core	

clear :
			rm -f y.tab.c y.tab.h lex.yy.c core
