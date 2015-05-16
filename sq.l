%{
# include "y.tab.h"
extern yylval;
%}

alpha [A-Za-z]
digit [0-9]

%%

\n		{ return 0; }
[ \t]		{ ; }
create		{ return CREATE; }
table		{ return TABLE; }
insert		{ return INSERT; }
delete		{ return DELETE; }
into		{ return INTO; }	
select		{ return SELECT; }
values		{ return VALUES; }
distinct	{ return DISTINCT; }
from		{ return FROM; }
where		{ return WHERE; }
like		{ return LIKE; }
desc		{ return DESC; }
asc		{ return ASC; }
"group by"	{ return GROUP; }
having		{ return HAVING; }
"order by"	{ return ORDER; }
or		{ return OR; }
and		{ return AND; }
{digit}+	{ return NUM; }
{alpha}({alpha}|{digit})*	{ return ID; }
"<="		{ return LE; }
">="		{ return GE; }
"=="		{ return EQ; }
"!="		{ return NE; }
.		{ return yytext[0]; }

%%
