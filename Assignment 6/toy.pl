(* OCaml data type *)
type symbol = string
	and variable = string
		and program = clause list
			and clause = Fact of head | Rule of head*body
				and head = Atm of atom
					and body = head list
						and term = Var of variable | Str of string | Atm of atom
							and atom = symbol*(term list)
								and goal = head list;;



