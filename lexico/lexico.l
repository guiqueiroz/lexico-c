%option noyywrap
%{ 
   #include<string.h>
   #include<stdio.h>
   int col=1, line=1;

void printaChar(char *c){
	int i;
	printf("CHARACTER(");
	for(i=1;i<strlen(c)-1;i++){
		printf("%c",c[i]);
		if(c[i]=='\t'){ col+= 7; }
	}
	printf(")\n");
}
void printaString(char *c){
	int i;
	printf("STRING(");
	for(i=1;i<strlen(c)-1;i++){
		printf("%c",c[i]);
		if(c[i]=='\t'){ col+= 7; }
	}
	printf(")\n");
}
%}
%x COMENTARIO
%x COMENTARIOLINHA
%% 
"/*" {col+=yyleng; BEGIN(COMENTARIO);}
<COMENTARIO>"*/" {col+=yyleng; BEGIN(INITIAL);}
<COMENTARIO>[\n] { col=1; line++;}
<COMENTARIO>[ ]+ {col+=yyleng;}
<COMENTARIO>[\t]+	{col+= (yyleng*8); }
<COMENTARIO>. {col+=yyleng; }
"//" {col+=yyleng; BEGIN(COMENTARIOLINHA); }
<COMENTARIOLINHA>[\n] { col=0; line++; BEGIN(INITIAL);}
<COMENTARIOLINHA>[ ]+ {col+=yyleng;}
<COMENTARIOLINHA>[\t]+ {col+= (yyleng*8); }
<COMENTARIOLINHA>. {col+=yyleng; }
"void"     { printf("VOID\n"); col+=yyleng; }
"int"      { printf("INT\n"); col+=yyleng; }
"char"     { printf("CHAR\n"); col+=yyleng; }
"return"   { printf("RETURN\n"); col+=yyleng; }
"break"    { printf("BREAK\n"); col+=yyleng; }
"switch"   { printf("SWITCH\n"); col+=yyleng; }
"case"     { printf("CASE\n"); col+=yyleng; }
"default"  { printf("DEFAULT\n"); col+=yyleng;}
"do"       { printf("DO\n"); col+=yyleng; }
"while"    { printf("WHILE\n"); col+=yyleng; }
"for"      { printf("FOR\n"); col+=yyleng; }
"if"       { printf("IF\n"); col+=yyleng; }
"else"     { printf("ELSE\n"); col+=yyleng; }
"+"        { printf("PLUS\n"); col+=yyleng; }
"-"        { printf("MINUS\n"); col+=yyleng; }
"*"        { printf("MULTIPLY\n"); col+=yyleng; }
"%"	   { printf("REMAINDER\n"); col+=yyleng; }
"++"       { printf("INC\n"); col+=yyleng; }
"--"       { printf("DEC\n"); col+=yyleng; }
"&"        { printf("BITEWISE_AND\n"); col+=yyleng; }
"|"        { printf("BITEWISE_OR\n"); col+=yyleng; }
"~"        { printf("BITEWISE_NOT\n"); col+=yyleng; }
"^"        { printf("BITWISE_XOR\n"); col+=yyleng; }
"!"        { printf("NOT\n"); col+=yyleng; }
"&&"       { printf("LOGICAL_AND\n"); col+=yyleng; }
"||"       { printf("LOGICAL_OR\n"); col+=yyleng; }
"=="       { printf("EQUAL\n"); col+=yyleng; }
"!="       { printf("NOT_EQUAL\n"); col+=yyleng; }
"<"        { printf("LESS_THEN\n"); col+=yyleng; }
">"        { printf("GREATER_THEN\n"); col+=yyleng; }
"<="       { printf("LESS_EQUAL\n"); col+=yyleng; }
">="       { printf("GREATER_EQUAL\n"); col+=yyleng; }
">>"       { printf("R_SHIFT\n"); col+=yyleng; }
"<<"       { printf("L_SHIFT\n"); col+=yyleng; }
"="        { printf("ASSIGN\n"); col+=yyleng; }
"+="       { printf("ADD_ASSIGN\n"); col+=yyleng; }
"-="       { printf("MINUS_ASSIGN\n"); col+=yyleng; }
";"        { printf("SEMICOLON\n"); col+=yyleng; }       
","        { printf("COMMA\n"); col+=yyleng; }
":"        { printf("COLON\n"); col+=yyleng; }
"("        { printf("L_PAREN\n"); col+=yyleng; }
")"        { printf("R_PAREN\n"); col+=yyleng; }
"{"        { printf("L_CURLY_BRACKET\n"); col+=yyleng; }
"}"        { printf("R_BRACE_BRACKET\n"); col+=yyleng; }
"?"        { printf("TERNARY_CONDITIONAL\n"); col+=yyleng; }
"#"        { printf("NUMBER_SIGN\n"); col+=yyleng; }
"printf"   { printf("PRINTF\n"); col+=yyleng; }
"scanf"    { printf("SCANF\n"); col+=yyleng; }
"define"   { printf("DEFINE\n"); col+=yyleng; }
"exit"     { printf("EXIT\n"); col+=yyleng; }
[_a-zA-Z][_a-zA-Z0-9]* { printf("IDENTIFIER(%s)\n",yytext); col+=yyleng; }
0[1-7][0-7]*	{ printf("NUM_OCTAL(%s)\n",yytext); col+=yyleng; }
[0-9]+ { printf("NUM_INTEGER(%s)\n",yytext); col+=yyleng; }
0[xX][a-fA-F0-9]+ { printf("NUM_HEXA(%s)\n",yytext); col+=yyleng; }
\"(\\.|[^"\n])*\" 	  { printaString(yytext); col+=yyleng; }
\'(\\.|[^\'\n])\' { printaChar(yytext); col+=yyleng; }
[ ]+ {col+=yyleng;}
[\t]+	{col+= (yyleng*8);}
[\n] { col=1; line++; }
.	{ printf("ERRO: LINHA: %d COLUNA: %d\n",line,col); col+=yyleng; }
%%
int main(int argc, char **argv){
	yyin = fopen(argv[1],"r");
	yylex();
	fclose(yyin);
	return 0;
}
