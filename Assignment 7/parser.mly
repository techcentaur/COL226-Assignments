/* File parser.mly */
%{
  open Tree
%}

%token LP RP EOL IFF COMMA EOF
%token <bool> BOOL
%token <string> VAR
%token <string> ID
%start main             /* the entry point */
%type <Tree.clause> main
%%
main:
    clausee EOL { $1 }
    | EOF {(Node(S("file_end",0),[]),[])}
;
clausee:
    atom { ($1,[]) }
    | atom IFF body { ($1,$3) }
;
atom:
     ID { Node(S($1,0),[]) }
    | LP atom RP  {$2}
    | ID LP termlist RP { Node(S($1,(List.length $3)),$3)}
;
term:
    ID { Node(S($1,0),[])}
    | VAR { V(T($1)) }
    | ID LP termlist RP { Node(S($1,(List.length $3)),$3)}

termlist:
     term     { [$1] }
    | term COMMA termlist { $1::$3 }
;
body:
     atom   { [$1] }
    | atom COMMA body       { $1::$3 } 