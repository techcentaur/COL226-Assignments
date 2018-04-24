#use"toy.ml"

let a = N("a", []);; (* constant term *)
let b = N("b", []);; (* constant term *)
let c = N("c", []);; (* constant term *)
let d = N("d", []);; (* constant term *)

let x = V "X";;
let y = V "Y";;

let f1 = Atm("Loves", [a;b]) (* an atomic formula *)
let f2 = Atm("Loves", [b;a]) (* an atomic formula *)
let f3 = Atm("Loves", [a;c])
let f4 = Atm("Loves", [a;d])

let r1 = (Atm("Loves", [x;y]),[(Atm("Loves", [y;x]))])(* another atomic formula with body *)

let goal = [f1];;
let prog = [Fact f1; Rule r1];;

process goal prog [];;

(* should return true *)
(* Printf.printf ("%b\n") (prolog goal prog);; *)
(* Printf.printf ("%b\n") (prolog [Atom ("Loves",[x;b])] prog);; *)

let goal1 = [ Atm ("Loves",[a;x])];;
let prog1 = [Fact f1; Fact f3; Fact f4];;

process goal1 prog1 [];;
