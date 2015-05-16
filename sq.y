%{
# include <stdio.h>
# include <stdlib.h>
extern FILE *yyin;
int flag1=0, flag2=0, count=0;
int factor=0;
FILE *fp;
char ch;
%}

%token ID NUM SELECT DELETE DISTINCT FROM WHERE LE GE EQ NE OR AND LIKE GROUP HAVING ORDER ASC DESC INTO CREATE TABLE INSERT VALUES
%right '='
%left AND OR
%left '<' '>' LE GE EQ NE

%%

S	:	ST1';'	{ if(factor==0)
                          printf("Query executed successfully.\n");
                          else{
                          factor=0;
                          }
                          flag2=0;flag1=0; }

ST1	:	CREATE TABLE ID '('parameters')'
	|	SELECT attributeList FROM ID ST2
	|	SELECT DISTINCT attributeList FROM tableList ST2
	|	INSERT INTO tableName VALUES tableList
	|	INSERT INTO tableName '('varprototype')' VALUES tableList	{ if (flag1!=flag2)
			{ printf("Wrong matching of parameters in the database...\n"); flag2=0;flag1=0;factor=1;} }
	|	DELETE FROM ID DL1
	;

DL1	:	WHERE COND
	|
	;

ST2	:	WHERE COND ST3
	|	ST3
	;

ST3	:	GROUP attributeList ST4
	|	ST4
	;

ST4	:	HAVING COND ST5
	|	ST5
	;

ST5	:	ORDER attributeList ST6
	|
	;

ST6	:	DESC
	|	ASC
	|
	;

parameters	:	ID ID','parameters
		|	ID ID
		;

attributeList	:	ID','attributeList
		|	'*'
		|	ID
		;

tableList	:	ID',' tableList {flag2+=1;$$=flag2;}
		|	ID {flag2+=1;$$=flag2;}
		;

varprototype	:	ID','varprototype {flag1+=1;$$=flag1;}
		|	ID {flag1+=1;$$=flag1;}
		;

tableName	:	ID
		;

COND	:	COND OR COND
	|	COND AND COND
	|	E
	;

E	:	F '=' F
	|	F '<' F
	|	F '>' F 
	|	F LE F
	|	F GE F
	|	F EQ F
	|	F NE F
	|	F OR F
	|	F AND F
	|	F LIKE F
	;

F	:	ID
	|	NUM 
	;

%%

int yyerror (char *msg) {
	fprintf(stderr, "%s\n", msg);
	return 0;
}

int yywrap()
{
	return 1;
} 
 
int main(int argc, char *argv[])
{
	if (argc == 2)
	{
		fp=fopen(argv[1],"r");
   		if(fp==NULL){
                printf("error opening the file\n"); 
                }
                else 
                 {
                  while( ( ch = fgetc(fp) ) != EOF ){
                  if(ch=='\n')
                  count++;
                 }
                 fclose(fp);
                }
                FILE *myfile = fopen(argv[1], "r");
		if(!myfile){
			printf("error opening the file\n"); 
		}
		else{
			yyin = myfile;
			while(count--)
			{
				yyparse();
			}
		}
	}
	else
	{
		printf("Enter the query:\n");
		yyparse();
	}
	return 0;
}
