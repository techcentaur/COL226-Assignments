{
open Parser     
exception Eof
}

rule lexicon = parse
  [' ' '\t' '\n']+ { lexicon lexbuf }
  |'.' { END }
  |',' { COMMA }
  |'=' { EQU }
  |("\\=" | "\\==") {NOTEQ}
  |'(' { LP }
  |')' { RP }
  | ']' {RSQ}
  | '[' {LSQ}
  | "not" {NOT}
  | '|' {OR}
  | ":-" {SEP}
  | ['A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_' ''']* as id{ V(id)}
  | ['a'-'z' '0'-'9']['a'-'z' 'A'-'Z' '0'-'9' '_' ''']* as id{ C(id)}
  | eof {EOF}
  | "%" {oneline lexbuf}
  | "/*" {multiline lexbuf}

and oneline = parse
  | eof { lexicon lexbuf}
  | _ { oneline lexbuf}

and multiline = parse
  | "*/" {lexicon lexbuf}
  | eof { raise Eof}
  | _ {multiline lexbuf}