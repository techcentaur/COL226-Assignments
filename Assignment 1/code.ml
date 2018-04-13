(**pointers**)
type 's marker = Marker of 's ref;;

(*Ques-1 : Functional Data type*)
type 's editable_str = S of (int marker)*('s array);;

(*Que-2*)
let lgh i = match i with S(Marker(a),b) -> Array.length(b);;

(*Que-3*)
let nonempty i = if lgh i = 0 then false else true;;

(*Ques-4*)
let concat i1 i2 = match (i1,i2) with (S(Marker(x),y),S(Marker(w),z)) -> S(Marker(x), (Array.append y z));;

(*Ques-5*)
let reverse i = match i with S(Marker(a),b) -> S(Marker(a),Array.of_list(List.rev(Array.to_list(b))));;

(*Ques-6*)
exception Empty;;
let first i = match i with S(Marker(a),[||]) -> raise Empty | S(Marker(a),b) -> b.(0);;

(*Ques-7*)

let last i = match i with S(Marker(a),[||]) -> raise Empty | S(Marker(a),b) -> b.((Array.length b)-1);;

(*Ques-8*)
let rec str_list s = match s with ""->[] | _ -> (str_list (String.sub s 0 ((String.length s)-1)))@[(String.get s (String.length(s)-1))];;
let create s = S(Marker(ref 0),Array.of_list(str_list s));;

(*Ques-9*)
exception AtLast;;
let forward i = match i with S(Marker(a),b) -> if ((lgh i)-1)= (!a) then raise AtLast else a:=!a+1; i;;

(*Ques-10*)
exception AtFirst;;
let back i = match i with S(Marker(a),b) -> if (!a)=(0) then raise AtFirst else a:=!a-1; i;;

(*Ques-11*)
exception TooShort;;
let moveTo n i = match i with S(Marker(a),b) -> if (n+(!a))>=(lgh i) then raise TooShort else for j=1 to n do a:=!a+1 done; i;;

(*Ques-12*)
let replace w i = match i with S(Marker(a),b) -> (b.(!a)<-w) ; i;;

(*Submitted by - Ankit Solanki [2016CS50401] *)