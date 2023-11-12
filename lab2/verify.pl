
% Read the file
verify(FileName) :-
    see(FileName),
    read(Prems),
    read(Goal),
    read(Proof),
    seen,

    valid_proof().

valid_proof(Prems, Goal, Proof) :-
    verify_goal(Proof, Goal) ,
    verify_proof(Proof, Prems, []), !.

last_line([Go], Go).
last_line([_|Tail], Next_line) :-
    last_line(Tail, Next_line).

verify_goal(Proof, Goal) :-
    last_line(Proof, Goal_con),
    member(Goal, Goal_con).

verify_proof([], _, _).
verify_proof([Head|Tail], Prems, Previous) :-
    verify_rule(Head, Prems, Previous),
    verify_proof(Tail, Prems, Previous).

verify_rule([_, Statement, premise], Prems, _) :-
    member(Statement, Prems).


