let program2 =
[
    Fact(Atm("male", [N ("pandu", [])]));
    Fact( N("male", [N ("arjun", [])]) );
    Fact( N("male", [N ("nakul", [])]) );
    Fact( N("female", [N ("kunti", [])]) );
    Fact( N("female", [N ("madri", [])]) );
    Fact( N("female", [N ("draupadi", [])]) );

    Fact( N("married", [N ("pandu", []); N("kunti", [])] ));
    Fact( N("married", [N ("pandu", []); N("madri", [])] ));
    Fact( N("married", [N ("arjun", []); N("draupadi", [])] ));
    Fact( N("married", [N ("nakul", []); N("draupadi", [])] ));

    Rule(
        N("married", [V "P"; V "Q"]),
        [
            N("married", [V "Q"; V "P"])
        ]
    );

    Rule(
        N("wife", [V "A"; V "B"]),
        [
            N("married", [V "A"; V "B"]);
            N("male", [V "A"]);
            N("female", [V "B"])
        ]
    );

    Rule(
        N("cowife", [V "C"; V "D"]),
        [
            N("married", [V "E"; V "C"]);
            N("married", [V "E"; V "D"]);
            N("female", [V "C"]);
            N("female", [V "D"]);
            (* X \= Y *)
        ]
    );

    Rule(
        N("husband", [V "F"; V "G"]),
        [
            N("married", [V "G"; V "F"]);
            N("male", [V "G"]);
            N("female", [V "F"])
        ]
    );

    Rule(
        N("cohusband", [V "H"; V "I"]),
        [
            N("married", [C "H"; C "J"]);
            N("married", [C "I"; C "J"]);
            N("male", [C "H"]);
            N("male", [C "I"]);
            (* X \= Y *)
        ]
    );
]

let query2_1 = [N("male", [N("krishna",[])])];;
let query2_2 = [N("married", [N("arjun",[]); V "X"])];;
let query2_3 = [N("married", [V "X"; N("draupadi",[])])];;
let query2_4 = [N("married", [V "X"; V "Y"])];;
let query2_5 = [N("cohusband", [N("arjun",[]); N("nakul",[])]); N("cowife", [N("madri",[]); N("kunti",[])])];;
let query2_6 = [N("cowife", [V "X"; N("kunti",[])])];;