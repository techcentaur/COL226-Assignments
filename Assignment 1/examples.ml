lgh (S(Marker(ref 0),[||]));;  
lgh (S(Marker(ref 0), [|"a"|]));;
lgh (S(Marker(ref 0),[|"a";"b";"c"|]));;
lgh (S(Marker(ref 0),[|"1";"2"|]));;

nonempty (S(Marker(ref 0),[||]));;
nonempty (S(Marker(ref 0),[|"a"|]));;
nonempty (S(Marker(ref 0),[|"1";"2"|]));;

let nil=(S(Marker(ref 0),[||]));;

concat nil nil;;
concat nil (S(Marker(ref 0),[|"a"|]));;
concat (S(Marker(ref 0),[|"a"|])) nil;;
concat (S(Marker(ref 0),[|"1";"A"|])) (S(Marker(ref 0),[|"a";"b";"c"|]));;

reverse nil;;
reverse (S(Marker(ref 0),[|"a";"b";"c"|]));;
reverse (S(Marker(ref 0),[|"1";"2"|]));;

first nil;;
first (S(Marker(ref 0),[|"a"|]));;
first (S(Marker(ref 0),[|"a";"b";"c"|]));;

last nil;;
last (S(Marker(ref 0),[|"a"|]));;
last (S(Marker(ref 0),[|"a";"b";"c"|]));;

let editable = create "abac12a2aAac211";;

forward editable;;
back editable;;
moveTo 10 editable;;
replace 'b' editable;;

