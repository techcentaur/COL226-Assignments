(* Assignment-6: Toy interpreter language *)

(* OCaml data types *)
type constant = string;;
type variable = string;;
type predicate = string;;
type term = C of constant | V of variable | A of predicate*(term list);;
type atom = A of predicate*(term list);;
type head = atom;;
type body = atom list;;
type clause = Fact of head | Rule of head*body;;
type program = clause list;;
type goal = atom list;;


(* val solvedvar_pointer : '_a list ref = {contents = []} *)
let solvedvar_pointer = ref [];;

(* val unification : 'a list -> 'a list -> 'a list = <fun> *)
let rec unification s1 s2 = match s1 with
| [] -> s2
| x::x' -> if (List.mem x s2) then unification x' s2 else (x::(unification x' s2));;

(* val term2string : term -> variable = <fun> *)
let term2string term = match term with | V v -> v | C c -> c | _-> "";;

(* val printsubs : (string * term) list -> string list -> string = <fun> *)
let rec printsubs sub vars = match sub with
    | [] -> ""
    | (v, t) :: rest -> if List.exists (fun x -> x = v) vars then
        (Printf.sprintf "\n%s = %s" v (term2string t)) ^ (printsubs rest vars)
        else (printsubs rest vars) ;;

exception Not_found;;

(* val occurs : variable -> term -> bool = <fun> *)
let rec occurs var term = match term with | V v -> v = var | C _ -> false | A (_, termlist) -> List.exists (occurs var) termlist ;;

type substitution = variable*term;;
exception Not_unifiable;;

(* val mgu : term -> term -> (variable * term) list = <fun> *)
let rec mgu t1 t2 = match (t1, t2) with
	(C x, C y) -> if y = x then [] else raise Not_unifiable
	| (V x, C y) | (C y, V x) -> [(x, C y)]
	| (C _, A _) | (A _ , C _) -> raise Not_unifiable
	| (V x, V y) -> if x <> y then [(x, V y)] else []
	| (V x, (A _ as p)) | ((A _ as p), V x) -> if not (occurs x p) then [(x, p)] else raise Not_unifiable
	| (A(pred1, termlist1), A(pred2, termlist2)) -> if (pred1 = pred2) && (List.length termlist2 = List.length termlist2) then 
												List.fold_left2 (fun s t u-> unification s (mgu t u)) [] termlist1 termlist2 else raise Not_unifiable;;

(* val mgu2 : atom -> atom -> (variable * term) list = <fun> *)
let mgu2 a1 a2 = match (a1, a2) with
 (A(pred1, termlist1), A(pred2, termlist2)) -> if (pred1 = pred2) && (List.length termlist2 = List.length termlist2) then 
												List.fold_left2 (fun s t u-> unification s (mgu t u)) [] termlist1 termlist2 else raise Not_unifiable;;

(* val subst : term -> (variable * term) list -> term = <fun> *)
let rec subst term substitution = match term with
	| C c -> C c
	| V v -> (try (let x,y = List.find (fun (t1,t2) -> v = t1) substitution in y) with Not_found -> V v)
	| A(pred, termlist) -> A(pred, List.map (fun t -> subst t substitution) termlist);;

(* val subst2 : atom -> (variable * term) list -> atom = <fun> *)
let subst2 atom substitution = match atom with A(pred, termlist) -> A(pred, List.map (fun t -> subst t substitution) termlist);;

(* val substitutetobody : atom list -> (variable * term) list -> atom list =<fun> *)
let substitutetobody body substitution = List.fold_left (fun x y -> unification x [(subst2 y substitution)]) [] body;;


(* val compose : (variable * term) list -> (variable * term) list -> (variable * term) list = <fun> *)
let rec compose sub1 sub2 =
	let rec composelist sub1 sub2 sublist =( match (sub1, sub2) with
	| ([], []) -> sublist
	| (x, []) | ([], x) -> unification sublist x
	| (((v1, t1)::s1), ((v2, t2)::s2)) -> if (occurs v2 t1) then composelist s1 s2 (unification sublist [(v1, subst t1 [(v2, t2)]); (v2, t2)])
										  else composelist s1 s2 (unification [(v1, t1); (v2, t2)] sublist)) in composelist sub1 sub2 [];; 

(* val varsTerm : term -> variable list = <fun> *)
let rec varsTerm term =  match term with | C c -> []  | V v -> [v] | A(_, termlist) -> List.fold_left (fun x t -> unification x (varsTerm t)) [] termlist ;;

(* val varsGoals : atom list -> variable list = <fun> *)
let rec varsGoals goals = match goals with | [] -> [] | A(_, termlist)::a -> unification (List.fold_left (fun x t -> unification x (varsTerm t)) [] termlist) (varsGoals a) ;;

(* val clausestruct : clause -> head * body = <fun> *)
let clausestruct clause = match clause with | Fact h -> (h, []) | Rule (h,b) -> (h, b);;


(* backtracking *)

(* val process :clause list -> atom list -> (variable * term) list -> variable list -> bool =<fun> *)
(* val processg1 :clause list ->atom -> atom list -> (variable * term) list -> variable list -> bool =<fun> *)
let rec process p g answer vars = match g with | [] -> let choice =
            (let solved = printsubs answer vars in
            if answer <> [] && vars <> [] then
                    if not (List.mem solved !solvedvar_pointer) then
                        let _ = print_string solved in
                        solvedvar_pointer := solved::!solvedvar_pointer;
                        read_line()
                    else ":" else ".")
        in (if choice = ";" || choice = ":" then false else true)
    | g1::g' ->  processg1 p g1 g' answer vars
and processg1 p g1 g' answer vars =
    let _ = "nothing" in
    let rec solve pr goal = match pr with
        | [] -> false
        | clause::pr' -> ( try
                let h, b = (clausestruct clause) in
                let substi = mgu2 goal h in
                let new_goals = substitutetobody (unification g' b) substi in
                if process p new_goals (compose answer substi) vars then true
                else solve pr' goal
            with Not_unifiable -> solve pr' goal) in solve p g1 ;;

(* val solver : clause list -> atom list -> bool = <fun> *)
let solver program goals =
    solvedvar_pointer := [];
    let var = varsGoals goals in (process program goals [] var) ;;
