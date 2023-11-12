
% Read the file
verify(FileName) :-
    see(FileName),
    read(Premise),
    read(Goal),
    read(Proof),
    seen,

    verify_proof().

verify_proof(Premise, Goal, Proof) :-
    verify_goal(Proof, Goal) ,
    check_proof(Proof, Premise, []), !.

last_line([Go], Go).
last_line([_|Tail], Next_line) :-
    last_line(Tail, Next_line).

verify_goal(Proof, Goal) :-
    last_line(Proof, Goal_con),
    member(Goal, Goal_con).

verify_rule()

verify_rule()

verify_rule()

verify_rule()



