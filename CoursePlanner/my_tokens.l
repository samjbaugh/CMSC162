%{
#include <stdio.h>
#include "y.tab.h"

%}

%%

"Prerequisite(s):"                                 return PREREQ;
"Terms Offered:"                                   return TERMS;
"Units."                                           return UNITS;
"Autumn"                                           yylval=strdup(yytext); return AUTUMN;
"Spring"                                           yylval=strdup(yytext); return SPRING;
"Winter"                                           yylval=strdup(yytext); return WINTER;
"Summer"                                           yylval=strdup(yytext); return SUMMER;               
"<strong>"                                         return START;
"</strong>"                                        return END;
"and"                                              return AND;
"or"                                               return OR;
[A-Z][A-Z][A-Z][A-Z]                               yylval=strdup(yytext); return COURSE_LABEL;
[0-9][0-9][0-9][0-9][0-9]                          yylval=strdup(yytext); return COURSE_NUMBER;
[A-Za-z][a-z]+                                     yylval=strdup(yytext); return WORD;
"<div class=\"courseblock main\">"                 return BIG_START;
"<div class=\"courseblock subsequence\">"          return BIG_START;
"</div>"                                           return BIG_END;
"<br />"                                           return BREAK;
"</html>"                                          return PAGE_END;
=                                                  return EQUALS;
-                                                  return DASH;
;                                                  return SEMICOLON;
\.                                                 return PERIOD;
\n                                                 /* ignore */
[ \t]+                                             /* ignore whitespace */
.                                                  /* ignore other characters */; 


%%

