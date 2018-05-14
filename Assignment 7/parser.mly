%{
  open Toy
  open Printf
%}

/*
- goal = GL of term list
- clause = term list
type clause =
    | Fact of head
    | Rule of head * body;;
type goal = atomic_formula list;;
type program = clause list;;*/


%token LP RP END COMMA EQU NOTEQ LSQ RSQ NOT OR SEP EOF
%token <string> V C
%start main
%start goal
%type <Toy.program> main
%type <Toy.goal> goal
%%
main:
  | EOF     { ([Fact(A("file_end",[]))]) }
  | clausee END { ($1) }
;
goal:
  | goal_continue END    {$1}
;
clausee:
  | myclause { [Fact($1)] }
  | myclause SEP goal_continue   {[Rule($1,$3)]}
;
myclause:
  | LSQ myclause OR myclause RSQ  {A("", [$2; $4])}
  | LSQ RSQ        { A("", []) }
  | LSQ myclause RSQ    { A("", [$2; A("", [])])}
  | LSQ myclause COMMA list RSQ   { A("", [$2; $4])}
  | V    { V($1) }
  | C           { C($1) }
  | C LP goal_continue RP     { A($1,$3)}
  | LP myclause RP      { $2 }
;
list :
  | myclause     { A ("", [$1; A("", [])]) }
  | myclause COMMA list   { A ("", [$1;$3]) }
;
goal_continue:
  | myclause            { [$1] }
  | myclause COMMA goal_continue     { ($1::$3) }
