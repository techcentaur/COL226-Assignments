
(* let t1 = ("wizard", [A("harry", [])]) *)
let wz1 = Fact( A( "wizard", [C "harry"]) );;
let wz2 = Fact( A( "wizard", [C "ron"]) );;
let wz3 = Fact( A( "wizard", [C "arthur"]) );;
let wz4 = Fact( A( "wizard", [C "bill"]) );;
let wz5 = Fact( A( "wizard", [C "james"]) );;
let wz6 = Fact( A( "wizard", [C "snape"]) );;

let wt1 = Fact( A( "witch", [C "hermione"]) );;
let wt2 = Fact( A( "witch", [C "ginny"]) );;
let wt3 = Fact( A( "witch", [C "molly"]) );;
let wt4 = Fact( A( "witch", [C "fleur"]) );;
let wt5 = Fact( A( "witch", [C "lilly"]) );;

let mr1 = Fact( A( "married", [C "harry"; C "ginny"]) );;
let mr2 = Fact( A( "married", [C "ron"; C "hermione"]) );;
let mr3 = Fact( A( "married", [C "arthur"; C "molly"]) );;
let mr4 = Fact( A( "married", [C "james"; C "lilly"]) );;
let mr5 = Fact( A( "married", [C "bill"; C "fleur"]) );;

let lv1 = Fact( A( "loves", [C "james"; C "lilly"]) );;
let lv2 = Fact( A( "loves", [C "snape"; C "lilly"]) );;
let lv3 = Fact( A( "loves", [C "harry"; C "ginny"]) );;
let lv4 = Fact( A( "loves", [C "ron"; C "hermione"]) );;

let pt1 = Fact( A( "parent", [C "arthur"; C "ron"]) );;
let pt2 = Fact( A( "parent", [C "arthur"; C "ginny"]) );;
let pt3 = Fact( A( "parent", [C "arthur"; C "bill"]) );;
let pt4 = Fact( A( "parent", [C "molly"; C "ron"]) );;
let pt5 = Fact( A( "parent", [C "molly"; C "ginny"]) );;
let pt6 = Fact( A( "parent", [C "molly"; C "bill"]) );;
let pt7 = Fact( A( "parent", [C "james"; C "harry"]) );;
let pt8 = Fact( A( "parent", [C "lilly"; C "harry"]) );;

let r1 = Rule(
    A("father", [V "F1"; V "C1"]),
    [
        A("wizard", [V "F1"]);
        A("parent", [V "F1"; V "C1"])
    ]
);;

let r2 = Rule(
    A("mother", [V "M2"; V "C2"]),
    [
        A("witch", [V "M2"]);
        A("parent", [V "M2"; V "C2"])
    ]
);;

let r3 = Rule(
    A("son", [V "S3"; V "P3"]),
    [
        A("wizard", [V "S3"]);
        A("parent", [V "P3"; V "S3"])
    ]
);;

let r4 = Rule(
    A("daughter", [V "D4"; V "P4"]),
    [
        A("witch", [V "D4"]);
        A("parent", [V "P4"; V "D4"])
    ]
);;

let r5 = Rule(
    A("loves", [V "H5"; V "W5"]),
    [
        A("married", [V "H5"; V "W5"])
    ]
)

(* Programs *)

let p1 = [
    wz1; wz2; wz3; wz4; wz5; wz6;
    wt1; wt2; wt3; wt4; wt5;
    mr1; mr2; mr3; mr4; mr5;
    lv1; lv2; lv3; lv4;
    pt1; pt2; pt3; pt4; pt5; pt6; pt7; pt8;
    r1; r2; r3; r4; r5
];;

let g0 = A("loves", [C "snape"; C "lilly"])
let g1 = A("loves", [V "Z"; C "lilly"]);;
let g2 = A("loves", [V "Z"; V "T"]);;
let g3 = A("father", [V "X"; C "harry"]);;
let g4 = A("loves", [C "bill"; C "fleur"]);;
let g5 = A("daughter", [C "ginny"; C "molly"]);;
let g6 = A("daughter", [C "ginny"; C "james"]);;
let g7 = A("married", [V "X"; V "Y"]);;
