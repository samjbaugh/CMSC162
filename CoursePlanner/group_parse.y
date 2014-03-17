%{
#include <stdio.h>
#include <string.h>
#define YYSTYPE char *
 
void yyerror(const char *str)
{
        fprintf(stderr,"such error: syntax\n",str);
}
 
int yywrap()
{
        return 1;
} 
  
main()
{
        yyparse();
} 

%}



%token PREREQ TERMS COURSE_LABEL UNITS START END COURSE_NUMBER EQUALS DASH SEMICOLON PERIOD BREAK BIG_START BIG_END AND OR WORD AUTUMN WINTER SUMMER SPRING PAGE_END GROUPS_START GROUPS_END TABLE_START TABLE_END QUOTE END_P NUMERAL TITLE GROUP_END SUMMARY_END SUMMARY_START

%start commands

%%

commands
        : 
        | command commands
        ;

command
        : trashm 
        | PAGE_END 
        | trashm group_set trashm bigstart_set
        ;

group_set
        : SUMMARY_START trashm groups trashm SUMMARY_END 
        ;

groups
        : group
        | group trashm groups
        ;

group
        : GROUPS_START words END_P table GROUPS_END {printf("\nGroup name: %s \n Table-info: %s\n",$2,$4);}
        ;


table
        : TABLE_START trashm titlenames trashm TABLE_END  {$$=strdup($3);}
        ;

titlenames
        : myname {$$=strdup($1);printf("here");}
        | myname trashm titlenames {char temp[80]; strcpy(temp,$1); strcat(temp," ! "); strcat(temp,$3); $$=strdup(temp);}
        ;

titlename
        : myname {char temp[80]; strcpy(temp,"["); strcat(temp,$1); strcat(temp,"]"); $$=strdup(temp);}
        ;

temp    : myname trashm OR trashm myname {char temp[80]; strcpy(temp,"["); strcat(temp,$1); strcat(temp," or "); strcat(temp,$5); strcat(temp,"]"); $$=strdup(temp);}
        ;

myname
        : TITLE QUOTE COURSE_LABEL COURSE_NUMBER QUOTE {char temp[80]; strcpy(temp,"("); strcat(temp,$3); strcat(temp," "); strcat(temp,$4); strcat(temp,")"); $$=strdup(temp);}
        ;















bigstart_set
        : BIG_START trashm start_set trashm term_set trashm prereq_set trashm BIG_END
        ;

term_set
        : TERMS seasons {printf("    Terms: %s\n",$2);}
        ;
seasons
        : season  {$$=strdup($1);}
        | season seasons  {char temp[80]; strcpy(temp,$1); strcat(temp," "); strcat(temp,$2);  $$=strdup(temp);}
        ;

season
        : SUMMER
        | WINTER
        | AUTUMN
        | SPRING
        ;

words
        : {$$="";}
        | WORD words {char temp[80]; strcpy(temp,$1); strcat(temp," "); strcat(temp,$2); $$=strdup(temp);}
        ; 

prereq_set
        : 
        | PREREQ prereq_courses
        | PREREQ
        ;

start_set
        : START course trashm course_stuff trashm UNITS END  {printf("%s : %s \n",$2,$4);} 
        | START trashm END 
        ;

course_stuff
        : WORD {$$=strdup($1);}
        | WORD course_stuff {char temp[80]; strcpy(temp,$1); strcat(temp," "); strcat(temp,$2); $$=strdup(temp);}
        ;

coursem
        : {$$=strdup("");}
        | course coursem  {char temp[80]; strcpy(temp,"!Q!: "); strcat(temp,$1); strcat(temp,$2); $$=strdup(temp);}
        ;
course
        : COURSE_NUMBER  {$$=strdup($1);}
        | COURSE_LABEL COURSE_NUMBER {char temp[80]; strcpy(temp,$1); strcat(temp,": "); strcat(temp,$2); $$=strdup(temp); }
        | COURSE_LABEL SEMICOLON COURSE_NUMBER {char temp[80];  strcpy(temp,$1); strcat(temp,": ");  strcat(temp,$3); $$=strdup(temp); }
        ;

prereq_courses
        : course conjphrasem trashm BREAK {printf("    prerequisite(s): %s \n",$2);}
        | course conjunction trashm BREAK {printf("    prerequisite(s): %s \n",$1);}
        | course trashm BREAK {printf("    prerequisite(s): %s \n",$1);}
        ;

conjphrasem
        : conjphrase {$$=strdup($1);}
        | conjphrase conjphrasem  {char temp[80]; strcpy(temp,$1); strcat(temp," "); strcat(temp,$2); $$=strdup(temp);}
        ;

conjphrase
        : conjunction trashm course  {char temp[80]; strcpy(temp,$1); strcat(temp," "); strcat(temp,$3); $$=strdup(temp);}   
        ;

conjunction
        : OR {$$="or";}
        | AND {$$="and";}
        ;

trashm
        :
        | trashm trash
        ;

trash
        : DASH
        | EQUALS
        | COURSE_LABEL
        | COURSE_NUMBER
        | SEMICOLON
        | PREREQ
        | TERMS
        | UNITS
        | START
        | END
        | PERIOD
        | BREAK
        | BIG_START
        | BIG_END
        | AND
        | OR
        | WORD
        | AUTUMN
        | WINTER
        | SPRING
        | SUMMER
        | GROUPS_START
        | GROUPS_END
        | SUMMARY_START
        | SUMMARY_END
        | TABLE_START
        | TABLE_END
        | QUOTE
        | END_P
        | NUMERAL
        | TITLE
        | GROUP_END
        ;



%%




