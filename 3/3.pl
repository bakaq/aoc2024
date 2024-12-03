:- use_module(library(lists)).
:- use_module(library(dcgs)).
:- use_module(library(pio)).
:- use_module(library(clpz)).
:- use_module(library(format)).
:- use_module(library(reif)).

digit(D) --> [D], { member(D, "1234567890") }.

number(Num) --> number(Ds, D), { number_chars(Num, [D|Ds]) }.
number([], D) --> digit(D).
number([D1|D1s], D) --> digit(D), number(D1s, D1).

a(0) --> [].
a(S) -->
    ...,
    "mul(",
    number(A),
    ",",
    number(B),
    ")",
    ...,
    a(S1),
    { #S #= #S1 + #A * #B }.

b(0, _) --> [].
b(S, Do) -->
    ...,
    (
        "mul(",
        number(A),
        ",",
        number(B),
        ")",
        { 
            if_(
                Do = do,
                #S1 #= #A * #B,
                S1 = 0
            ),
            Do1 = Do
        }
    ;   "do()", { S1 = 0, Do1 = do }
    ;   "don't()", { S1 = 0, Do1 = dont }
    ),
    ...,
    b(S2, Do1),
    { #S #= #S1 + #S2 }.

main :-
    phrase_from_file(a(A), "3.in"),
    phrase_from_file(b(B, do), "3.in"),
    portray_clause(a(A)),
    portray_clause(a(B)),
    halt.

