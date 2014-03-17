all:
	yacc -d --debug --verbose group_parse.y
	flex my_tokens.l
	cc y.tab.c lex.yy.c -o  groupparse

	yacc -d --debug --verbose classes_parse.y
	flex my_tokens.l
	cc y.tab.c lex.yy.c -o  classesparse
	    
