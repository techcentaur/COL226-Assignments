(*
 * Note: you need to change the following datatype and expressions as per your submitted code
 * Please do the changes before you come for demo.
 *)
datatype exp = Int of int
			| Bool of bool
			| Var of string
			| List of exp list
			| Add of exp * exp
			| Sub of exp * exp
			| Mul of exp * exp
			| Div of exp * exp
			| Tup of exp list
			| Proj of exp * int
			| Grt of exp * exp
			| Lst of exp * exp
			| Equ of exp * exp
			| Ifthenelse of exp * exp * exp
			| Abs of exp * exp
			| App of exp * exp
			| Assgn of exp * exp
			| Dec of exp list
			| Ctup of closure list
			| At of int
			| Bind of exp;;


let x = (Proj(Tup([Int(12);Int(121);Int(33)]), Int(2)));;
execute( compile x);;

let x = (Ifthenelse(Grt(Int(4),Int(2)),Add(Int(1),Int(3)),Sub(Int(1),Int(3))));;
execute( compile x);;

let x = (App(Abs("x",Add(Var("x"),Int(1))),Int(2)));;
execute( compile x);;

let x = (App(Abs("x", Mul(Var("x"),Add(Var("x"),Int(1)))),Int(2)));;
execute( compile x);;

let x = (App(Abs("x",App(Abs("d",Mul(Var("d"),Int(2))),Int(2))),Int(2)));;
execute( compile x);;
