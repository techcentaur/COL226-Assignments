2(*Examples*)
let rho t = match t with "x1" -> I 5 | "x2" -> I 2 | "x3" -> I 7 | "y1" -> B false | "y2" -> B true;;

let ex1 = Proj(Tup([Const(1);Add(Const(3),Abs(Const(-4)));Var("x2")]),Const(2));;
eval rho ex1;;
let cmp1 = compile ex1;;
execute (rho,[],cmp1);;


let ex2 = Sub(Proj(Tup([Const(1);Add(Const(3),Abs(Const(-4)));Var("x3")]),Const(2)), Mul(Const(4),Const(3)));;
eval rho ex2;;
let cmp2 = compile ex2;;
execute (rho,[],cmp2);;

let ex3 = And(Not(Bool(true)), Not(Var("y1")));;
eval rho ex3;;
let cmp3 = compile ex3;;
execute (rho,[],cmp3);;

let ex4 = Grt(Proj(Tup([Const(2);Const(5);Var("x1")]), Abs(Const(-1))), Add(Mul(Const(2),Const(1)), Const(-2)));;
eval rho ex4;;
let cmp4 = compile ex4;;
execute (rho,[],cmp4);;

