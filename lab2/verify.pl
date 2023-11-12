
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
verify_rule([_, Statement, copy(Row)], _, Previous) :-
    member([Row, Statement, _], Previous).

% And introduction rule
verify_rule([_, and(Statement1, Statement2), andint(Row1, Row2)], _, Previous) :-
    member([X, Statement1, _], Previous),
    member([Y, Statement2, _], Previous).

% And elimination rules
verify_rule([_, Statement, andel1(Row)], _, Previous):-
    member([Row, and(Statement, _), _], Previous).

verify_rule([_, Statement, andel2(Row)], _, Previous) :-
    member([Row, and(_, Statement), _], Previous).

