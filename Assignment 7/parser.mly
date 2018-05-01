/* File parser.mly */
%{
  open Toy
  open Printf
%}

%token DOT COMMA EQU NOTEQ LP RP LSQ RSQ NOT OR DEL EOF
%token EOL
%token <string> V C
%start main
%type <Toy.program> main
%type <Toy.goal> goal
%%
main:
    | EOL { [] }
    | clause main { ($1)::($2) };
goal:
    | atom_list DOT {$1};
atom_list:
  | atom { [$1] }
  | atom COMMA atom_list {($1)::($3)};
clause:
  | atom DOT { Fact(A($1,[]))}
  | atom DEL atom_list DOT { Rule(A($1,[]), [A($3,[])])};
atom:
  | NOT LP atom RP  {A("$not",[N($3)]) }
  | C LP term_list RP { A(Sym($1),$3) }
  | term EQU term  { A("$eq",[$1;$3]) }
  | term NOTEQ term { A("$neq",[$1;$3]) }
  | LP atom RP { $2 };
term_list:
  | term { [$1] }
  | term COMMA term_list { ($1)::($3) };
term:
  | V   { V($1) }
  | C   { C($1) }
  | atom   { A($1,[]) };