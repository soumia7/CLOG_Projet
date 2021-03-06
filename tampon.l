%{
#include "tampon.tab.h"
extern YYSTYPE yylval;
#include <conio.h>
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


extern int nb_ligne; 
extern int nb_col; 

void Color(int couleurDuTexte,int couleurDeFond) // fonction d'affichage de couleurs
{HANDLE H = GetStdHandle(STD_OUTPUT_HANDLE);
SetConsoleTextAttribute(H,couleurDeFond*16+couleurDuTexte);
}

/*0 : Noir
 1 : Bleu foncé
 2 : Vert foncé
 3 : Turquoise
 4 : Rouge foncé
 5 : Violet
 6 : Vert caca d'oie
 7 : Gris clair 
 8 : Gris foncé
 9 : Bleu fluo
 10 : Vert fluo
 11 : Turquoise
 12 : Rouge fluo
 13 : Violet 2
 14 : Jaune
 15 : Blanc*/

/*====déclaration d'une structure de donnée pour la table de symbole====*/
typedef struct
{
char NomEntite[30];
char CodeEntite[30];
char TypeEntite[30];
int ValEntite;
} TypeTS;

/*===initiation d'un tableau qui va contenir les elements de la table de symbole==*/
TypeTS ts[200]; 

/*===un compteur global pour la table de symbole===*/
int CpTabSym=0;


/*==une fonctione recherche: pour chercher est ce que l'entité existe ou non déjà dans la table de symbole.==*
/*==== i: l'entite existe dejà dans la table de symbole, et sa position est i, -1: l'entité n'existe pas dans la table de symbole.====*/

int recherche(char entite[])
{
int i=0;
while(i<CpTabSym)
{
if (strcmp(entite,ts[i].NomEntite)==0) return i;
i++;
}
return -1;
}

/*========une fontion qui va insérer les entités de programme dans la table de symbole=======*/
void inserer(char entite[], char code[])
{
if ( recherche(entite)==-1)
{
strcpy(ts[CpTabSym].NomEntite,entite); 
strcpy(ts[CpTabSym].CodeEntite,code);
//printf("lentite est %s, sont type est %s %d\n",ts[CpTabSym].NomEntite,ts[CpTabSym].TypeEntite,CpTabSym);
CpTabSym++;
}
}

/*================une fonction pour afficher la table de symbole==============*/
void afficher ()
{

printf("\n                                 /*==============================================================*/\n");
printf("                                /********************Table des symboles *************************/\n");
printf("                               /*==============================================================*/\n");
Color(12,0);
printf("\t_________________________________________________________________________________________________________________________\n");
printf("\t|          NomEntite        |         CodeEntite           |         TypeEntite           |          ValeurEntite       |\n");
printf("\t_________________________________________________________________________________________________________________________\n");

int i=0;
while(i<CpTabSym)
{
if ((strcmp(ts[i].TypeEntite,"")==0)&&(strcmp(ts[i].CodeEntite,"idf")!=0))
{
printf("\t|%26s |%28s  |%27s   |---------------------------- |\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite);
}
else
{
printf("\t|%26s |%28s  |%27s   | %27d\t|\n",ts[i].NomEntite,ts[i].CodeEntite,ts[i].TypeEntite,ts[i].ValEntite);
 }
i++;
}
printf("\t_________________________________________________________________________________________________________________________\n");
}

// fonction qui change le type d'une etité une fois il va être reconu dans la syntaxe 

void insererType(char entite[], char type[])
{

int posEntite=recherche(entite);
if (posEntite!=-1)
{ 

strcpy(ts[posEntite].TypeEntite,type);

//printf("lentite est %s, sont type est %s %d\n",ts[CpTabSym].NomEntite,ts[CpTabSym].TypeEntite,CpTabSym);

}
}

//insérer la valeur d'une entité dans la table de symbole
void insereVal(char entite[], int val)
{
int posEntite=recherche(entite);
if (posEntite!=-1)
{ 
ts[posEntite].ValEntite=val;
//printf("\nval:%d",val);
//printf ("\nfunction %s %d\n",ts[posEntite].NomEntite,ts[posEntite].ValEntite );
}
}

//retourner la valeur d'une entité
int retournerVal(char entite[])
{
int posEntite=recherche(entite);

//printf ("\nfunction %s %d\n",ts[posEntite].NomEntite,ts[posEntite].ValEntite );

return ts[posEntite].ValEntite;
}

const char* returnType (char entite[])
{
int posEntite=recherche(entite);

return ts[posEntite].TypeEntite;
}

/*===================Les routines sémantiques========================*/
int Form (char entite[]){
const char* S=returnType(entite);
if (strcmp(S,"INTEGER")==0) {return 0;}
if (strcmp(S,"STRING")==0) {return 1;}
if (strcmp(S,"FLOAT")==0) {return 2;}
if (strcmp(S,"CHAR")==0) {return 3;}
}
int Compatible (char entite1[],char entite[])
{
int posEntite=recherche(entite);
int posEntite1=recherche(entite1);

if (strcmp((ts[posEntite1].TypeEntite),(ts[posEntite].TypeEntite))!=0)
return 0;
}
int doubleDeclaration (char entite[])
{
int posEntite=recherche(entite);

//printf ("\nposi %d\n",posEntite);
if (strcmp(ts[posEntite].TypeEntite,"")==0) return 1;  // j'ai pas trouvé le type associé à l'entité dans le table de symbole et donc elle est pas encore déclarée
else return 0; // le type de l'entité existe dejà dans la TS et donc c'est une double déclaration

}
int nonDeclaration (char entite[])
{
int posEntite=recherche(entite);
if (strcmp(ts[posEntite].TypeEntite,"")==0) 
return 0;  
}
 
int TabDepassBorn(int valEntite,int valEntite1)
{

//printf("valEntite : %d\t valEntite: %d \n",valEntite,valEntite1);
if (valEntite > valEntite1 ) return 0;

}

%}
/*==========================================================Partie Règle ======================================================================*/  
chiffre0[0-9]
chiffre1 [1-9]
valint ({chiffre1}{chiffre0}*|0)
valints "(-"({chiffre1}{chiffre0}*)")"
valrel ({chiffre1}{chiffre0}*|0)"."({chiffre0}*)
valrels "(-"({chiffre1}{chiffre0}*|0)"."({chiffre0}*)")"
varchar '.'
varstr \"(.)*\"
varstrdo \"(.)*\$\"
varstrpr \"(.)*%\"
varstrdz \"(.)*#\"
varstrecm \"(.)*&\"
affect =
idf [A-Z]([a-z]|{chiffre0})*
oparth [-+*/]
com "//"(.)*
%%
G {inserer(yytext,"mc_G"); return mc_G;}
L {inserer(yytext,"mc_L"); return mc_L;}
GE {inserer(yytext,"mc_GE"); return mc_GE;}
LE {inserer(yytext,"mc_LE"); return mc_LE;}
EQ {inserer(yytext,"mc_EQ"); return mc_EQ;}
DI {inserer(yytext,"mc_DI"); return mc_DI;}
AND {inserer(yytext,"mc_AND"); return mc_AND;}
OR {inserer(yytext,"mc_OR"); return mc_OR;}
NOT {inserer(yytext,"mc_NOT"); return mc_NOT;}
IF {inserer(yytext,"mc_IF"); return mc_IF;}
ELSE {inserer(yytext,"mc_ELSE"); return mc_ELSE;}
END {inserer(yytext,"mc_END"); return mc_END;}
INTEGER {yylval.str=strdup(yytext); inserer(yytext,"mc_INTEGER"); return mc_INTEGER; }
FLOAT {yylval.str=strdup(yytext); inserer(yytext,"mc_FLOAT"); return mc_FLOAT;}
CHAR {yylval.str=strdup(yytext); inserer(yytext,"mc_CHAR"); return mc_CHAR;}
STRING {yylval.str=strdup(yytext); inserer(yytext,"mc_STRING"); return mc_STRING;}
VECTOR {yylval.str=strdup(yytext); inserer(yytext,"mc_VECTOR"); return mc_VECTOR;}
CONST {yylval.str=strdup(yytext); inserer(yytext,"mc_CONST"); return mc_CONST;}
READ {inserer(yytext,"mc_READ"); return mc_READ;}
DISPLAY {inserer(yytext,"mc_DISPLAY"); return mc_DISPLAY;}
FOR {inserer(yytext,"mc_FOR"); return mc_FOR;}


{idf} {if (yyleng<=8) { yylval.str=strdup(yytext); inserer(yytext,"IDF");return idf; }
       else {printf("Erreur lexical:IDF trop long ---> ");ECHO;
	      printf("\n");
	     }
       }
{valrels} {inserer(yytext,"valeur real"); return valreal;}
{valrel} {inserer(yytext,"valeur real"); return valreal;}
{valints} {if((atoi(yytext)<=32767)&&(atoi(yytext)>=-32768)) {inserer(yytext,"valeur int");return valint; }
          else{ printf("Erreur Lexical: valeur entière erronée ---> ");ECHO;
	         printf("\n");
	       }
         }
{valint} {if((atoi(yytext)<=32767)&&(atoi(yytext)>=-32768)) {yylval.num=atoi(yytext);inserer(yytext,"valeur int");return valint; }
          else{ printf("Erreur Lexical: valeur entière erronée ---> ");ECHO;
	         printf("\n");
	       }
         }
\"\$\" {inserer(yytext,strdup(yytext)); return dollar; }
\"#\" {inserer(yytext,strdup(yytext));return dieze;}	 
\"&\" {inserer(yytext,strdup(yytext));return ecom;}	 
\"%\" {inserer(yytext,strdup(yytext));return prcent;}	 

{varchar} {yylval.str=strdup(yytext);(yytext,"un caractère"); return valchar;}
{com} {yylval.str=strdup(yytext);inserer(yytext,"un commentaire"); }
{varstrdo} {yylval.str=strdup(yytext);inserer(yytext,"une chaine de caractère");return varstrdo; }
{varstrpr} {yylval.str=strdup(yytext);inserer(yytext,"une chaine de caractère");return varstrpr; }
{varstrdz} {yylval.str=strdup(yytext);inserer(yytext,"une chaine de caractère");return varstrdz; }
{varstrecm} {yylval.str=strdup(yytext);inserer(yytext,"une chaine de caractère");return varstrecm; }
{varstr} {yylval.str=strdup(yytext);(yytext,"une chaine de caractère");return valstr; }	   
	   
"{" {inserer(yytext,strdup(yytext)); return yytext[0];}
"}" {inserer(yytext,strdup(yytext)); return yytext[0];}
"[" {inserer(yytext,strdup(yytext));return yytext[0]; }
"]" {inserer(yytext,strdup(yytext));return yytext[0]; }
"(" {inserer(yytext,strdup(yytext));return yytext[0]; }
")" {inserer(yytext,strdup(yytext));return yytext[0]; }
{oparth} {inserer(yytext,strdup(yytext)); return yytext[0];}
[;:,] return yytext[0] ;
"|" return yytext[0] ;
"@" return yytext[0] ;
"\"" return yytext[0] ;
{affect} {inserer(yytext,strdup(yytext)); return affectaion;}
[ ] {nb_col++;}
[\t]
\n {nb_ligne++;nb_col=0;}
       
. printf("erreur lexicale :entité non reconnu");
