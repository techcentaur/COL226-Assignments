let program2 =
[
    Fact(Atm("male", [N ("pandu", [])]));
    Fact( Atm("male", [N ("arjun", [])]) );
    Fact( Atm("male", [N ("nakul", [])]) );
    Fact( Atm("female", [N ("kunti", [])]) );
    Fact( Atm("female", [N ("madri", [])]) );
    Fact( Atm("female", [N ("draupadi", [])]) );

    Fact( Atm("married", [N ("pandu", []); N("kunti", [])] ));
    Fact( Atm("married", [N ("pandu", []); N("madri", [])] ));
    Fact( Atm("married", [N ("arjun", []); N("draupadi", [])] ));
    Fact( Atm("married", [N ("nakul", []); N("draupadi", [])] ));

    Rule(
        Atm("married", [V "P"; V "Q"]),
        [
            Atm("married", [V "Q"; V "P"])
        ]
    );

    Rule(
        Atm("wife", [V "A"; V "B"]),
        [
            Atm("married", [V "A"; V "B"]);
            Atm("male", [V "A"]);
            Atm("female", [V "B"])
        ]
    );

    Rule(
        Atm("cowife", [V "C"; V "D"]),
        [
            Atm("married", [V "E"; V "C"]);
            Atm("married", [V "E"; V "D"]);
            Atm("female", [V "C"]);
            Atm("female", [V "D"]);
            (* X \= Y *)
        ]
    );

    Rule(
        Atm("husband", [V "F"; V "G"]),
        [
            Atm("married", [V "G"; V "F"]);
            Atm("male", [V "G"]);
            Atm("female", [V "F"])
        ]
    );

    Rule(
        Atm("cohusband", [V "H"; V "I"]),
        [
            Atm("married", [N("H",[]); N("J",[])]);
            Atm("married", [N("I",[]); N("J",[])]);
            Atm("male", [N("H",[])]);
            Atm("male", [N("I",[])]);
        ]
    );
]

let query2_1 = [Atm("male", [N("krishna",[])])];;
let query2_2 = [Atm("married", [N("arjun",[]); V "X"])];;
let query2_3 = [Atm("married", [V "X"; N("draupadi",[])])];;
let query2_4 = [Atm("married", [V "X"; V "Y"])];;
let query2_5 = [Atm("cohusband", [N("arjun",[]); N("nakul",[])]); N("cowife", [N("madri",[]); N("kunti",[])])];;
let query2_6 = [Atm("cowife", [V "X"; N("kunti",[])])];;