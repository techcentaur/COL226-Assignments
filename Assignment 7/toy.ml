(* Assignment-6: Toy interpreter language *)

(* OCaml data types *)
type variable = string;;
type predicate = string;;
type constant = string;;
type term =
    | V    of variable
    | C    of constant
    | A of predicate * (term list);;
type atomic_formula = A of predicate * (term list);;
type head = atomic_formula;;
type body = atomic_formula list;;
type clause =
    | Fact of head
    | Rule of head * body;;
type goal = atomic_formula list;;
type program = clause list;;

let member x s = List.mem x s;;
(* val unification : 'a list -> 'a list -> 'a list = <fun> *)
let rec unification s1 s2 =
    match s1 with
        [] -> s2
    | h::t ->
        if member h s2 then
            unification t s2
        else
            h :: (unification t s2);;
(* val term2string : term -> variable = <fun> *)
let term2string t =
    match t with
    | C c -> c
    | V v -> v
    | _   -> ""
;;

(* val solvedvar_pointer : '_a list ref = {contents = []} *)
let solvedvar_pointer = ref [];;
(* val printsubs : (string * term) list -> string list -> string = <fun> *)
let rec printsubs s to_do =
    match s with
    | [] -> ""
    | (v, t) :: rest ->
        (* Only counts if the user actually wanted value of this variable *)
        if List.exists (fun x -> x = v) to_do then
            (Printf.sprintf "\n%s = %s" v (term2string t)) ^ (printsubs rest to_do)
        else
            (printsubs rest to_do);;

let print_goal g =
    match g with
    | A (p, trm_lst) ->
        let joint =
            List.fold_left
                (fun acc x -> acc ^ ", " ^ term2string x)
                (term2string (List.hd trm_lst))
                (List.tl trm_lst)
        in
        Printf.printf "%s(%s)" p joint;;
exception NOT_UNIFIABLE;;

(* val occurs : variable -> term -> bool = <fun> *)
let rec occurs x t =
    match t with
      | V v -> v = x
      | C _ -> false
      | A (_, trm_lst) -> List.exists (occurs x) trm_lst;;

(* val mgu : term -> term -> (variable * term) list = <fun> *)
let rec mgu_of_terms p1 p2 =
    match (p1, p2) with
    | (C a, C b) ->
        if a = b then
            []
        else
            raise NOT_UNIFIABLE
    | (V v, C a) | (C a, V v) ->
        [(v, C a)]
    | (C _, A _) | (A _, C _) ->
        raise NOT_UNIFIABLE
    | (V v, V w) ->
        if v <> w then
            [(v, V w)]
        else
            []
    | (V v, (A _ as t)) | ( A _ as t, V v) ->
        if not (occurs v t) then
            [(v, t)]
        else
            raise NOT_UNIFIABLE
    | (A (f, trm_lst_1), A (g, trm_lst_2)) ->
        if (f = g) && (List.length trm_lst_1 = List.length trm_lst_2)
        then
            List.fold_left2 (fun acc c1 c2 -> unification acc (mgu_of_terms c1 c2)) [] trm_lst_1 trm_lst_2
        else
            raise NOT_UNIFIABLE;;
(* val mgu2 : atom -> atom -> (variable * term) list = <fun> *)
let mgu_of_formula f1 f2 =
    match (f1, f2) with
    (A (f, trm_lst_1), A (g, trm_lst_2)) ->
        if (f = g) && (List.length trm_lst_1 = List.length trm_lst_2)
        then
            List.fold_left2 (fun acc c1 c2 -> unification acc (mgu_of_terms c1 c2)) [] trm_lst_1 trm_lst_2
        else
            raise NOT_UNIFIABLE;;

(* val subst : term -> (variable * term) list -> term = <fun> *)
let rec subst trm sub =
    match trm with
    | C c -> C c
    | V v  ->
    (try
            let _, t = List.find (fun (x, t) -> v = x ) sub in t
        with
            Not_found -> V v)
    | A (pred, trm_lst) ->
        A (pred, List.map (fun t -> subst t sub) trm_lst);;

(* val subst2 : atom -> (variable * term) list -> atom = <fun> *)
let subst2 f sub =
    match f with
    | A (pred, trm_lst) ->
        A (pred, List.map (fun t -> subst t sub) trm_lst);;

(* val substitutetobody : atom list -> (variable * term) list -> atom list =<fun> *)
let substitutetobody body sub =
    List.fold_left (fun acc f -> unification acc [(subst2 f sub)]) [] body;;

(* val compose : (variable * term) list -> (variable * term) list -> (variable * term) list = <fun> *)
let rec compose s1 s2 =
    let rec compose_with_acc s1 s2 acc =
    ( match (s1, s2) with
        | ([], []) -> acc
        | (l, []) | ([], l) -> unification acc l
        | (((v1, t1) :: rest1), ((v2, t2) :: rest2)) ->
            if (occurs v2 t1) then
                compose_with_acc rest1 rest2
                (unification acc [(v1, subst t1 [(v2, t2)]); (v2, t2)])
            else
                compose_with_acc rest1 rest2 (unification [(v1, t1); (v2, t2)] acc)
    )in compose_with_acc s1 s2 [];;

(* val hd_body : clause -> head * body = <fun> *)
let hd_bdy cls =
    match cls with
    | Fact hd -> (hd, [])
    | Rule (hd, bdy) -> (hd, bdy);;

let rec solve program goals ans to_do =
    match goals with
    | [] ->
        let choice =
            let to_print = printsubs ans to_do in
            if ans <> [] && to_do <> [] then
                    if not (List.mem to_print !solvedvar_pointer) then
                        let _ = print_string to_print in
                        let _ = print_string " " in
                        solvedvar_pointer := to_print::!solvedvar_pointer;
                        read_line()
                    else
                        ":"
            else
                "."
        in
            if choice = ";" || choice = ":" then
                false
            else
                true
    | goal::rest ->
        solve_one program goal rest ans to_do

and solve_one program goal other_goals ans to_do =
    let _ = print_string "\nSolving Goal: "; print_goal goal; print_string "\n"; in
    let rec resolve p g =
        match p with
        | [] -> false
        |cls::rest ->
        ( try
                let hd, bdy = hd_bdy cls in
                let subst = mgu_of_formula g hd in
                let new_goals = substitutetobody (unification other_goals bdy) subst in
                if solve program new_goals (compose ans subst) to_do then
                    true
                else
                    resolve rest g
            with
                NOT_UNIFIABLE -> resolve rest g)
    in resolve program goal;;

let rec varsTerm trm =
    match trm with
    | C c -> []
    | V v -> [v]
    | A (_, trm_lst) ->
        List.fold_left (fun acc t -> unification acc (varsTerm t)) [] trm_lst;;
(* val varsGoals : atom list -> variable list = <fun> *)
let rec varsGoals goals =
    match goals with
    | [] -> []
    | A (_, trm_lst) :: rest ->
        unification
            (List.fold_left (fun acc t -> unification acc (varsTerm t)) [] trm_lst)
            (varsGoals rest);;

let solver program goals =
    solvedvar_pointer := [];
    let vars_to_do = varsGoals goals in
    solve program goals [] vars_to_do;;