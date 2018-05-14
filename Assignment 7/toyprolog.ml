open Toy;;
exception InvalidInputGoal;;


let rec mapx f l = match l with
| [] ->	flush stdout
| a::[] -> f a
| x::xs -> (f x);Printf.printf ", "; flush stdout; (mapx f xs); ();;

let rec printterm t = match t with
| V a -> Printf.printf "%s" a; flush stdout;
| A (a, []) -> Printf.printf "%s" a; flush stdout
| A (a, b) -> Printf.printf "%s" a; Printf.printf "("; flush stdout; mapx printterm b; Printf.printf ")"; flush stdout;();;

let rec printans1 ans = match ans with
| [] -> Printf.printf "\n"; flush stdout
| (a, b)::rest -> Printf.printf "%s" a; Printf.printf " = "; flush stdout; printterm b; Printf.printf "\n"; flush stdout; printans1 rest;();;

let rec printans ans = match ans with
| [] -> ()
| ans1::rest -> printans1 ans1; printans rest;();;


let pr = 
	try 
		let input = Sys.argv.(1) in
		let file = open_in input in
		let lexbuf = Lexing.from_channel file in
		let rec prog acc = 
			let claus = Parser.main Lexer.token lexbuf in
				match claus with ([Fact(A("file_end", []))]) -> acc
				| _ -> (prog (claus::acc))
			in
			(prog [])
with Invalid_argument("index out of bounds") -> [];;

let _ = Printf.printf "?- "; flush stdout;
		let lexbuf = Lexing.from_channel stdin in
		while true do
			let input = Parser.goal Lexer.token lexbuf in
				(match (prolog input pr) with
				| T -> Printf.printf "true.\n"; Printf.printf "\n?- "; flush stdout;
				| F -> Printf.printf "false.\n";  Printf.printf "\n?- "; flush stdout;
				| L(ans) -> printans ans; Printf.printf "\n?- "; flush stdout;)
		 done;;

		
