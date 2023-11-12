
% Read the file
verify(FileName) :-
    see(FileName),
    read(Prems),
    read(Goal),
    read(Proof),
    seen,

    valid_proof(Prems, Goal, Proof).

valid_proof(Prems, Goal, Proof) :-
    verify_goal(Proof, Goal) ,
    verify_proof(Proof, Prems, []), !.

verify_goal(Proof, Goal) :-
    last_line(Proof, Goal_contender),
    member(Goal, Goal_contender).

last_line([Statement], Statement).
last_line([_|Tail], Next_line) :-
    last_line(Tail, Next_line).

% Proof iterator
verify_proof([], _, _).
verify_proof([Head|Tail], Prems, Previous) :-
    verify_rule(Head, Prems, Previous),
    verify_proof(Tail, Prems, [Head|Previous]).

% Premise rule
verify_rule([_, Statement, premise], Prems, _) :-
    member(Statement, Prems).

% Copy rule
verify_rule([_, Statement, copy(X)], _, Previous) :-
    member([X, Statement, _], Previous).

% And introduction rule
verify_rule([_, and(Statement1, Statement2), andint(X, Y)], _, Previous) :-
    member([X, Statement1, _], Previous),
    member([Y, Statement2, _], Previous).


