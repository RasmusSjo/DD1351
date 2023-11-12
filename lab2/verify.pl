
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

% Assumption rule




% Copy rule
verify_rule([_, Statement, copy(Row)], _, Previous) :-
    member([Row, Statement, _], Previous).

% And introduction rule
verify_rule([_, and(Statement1, Statement2), andint(Row1, Row2)], _, Previous) :-
    member([Row1, Statement1, _], Previous),
    member([Row2, Statement2, _], Previous).

% And elimination rules
verify_rule([_, Statement, andel1(Row)], _, Previous):-
    member([Row, and(Statement, _), _], Previous).

verify_rule([_, Statement, andel2(Row)], _, Previous) :-
    member([Row, and(_, Statement), _], Previous).

% Or introduction rules
verify_rule([_, or(Statement, _), orint1(Row)], _, Previous):-
    member([Row, Statement, _], Previous).

verify_rule([_, or(_, Statement), orint2(Row)], _, Previous) :-
    member([Row, Statement, _], Previous).

% Or elmination rule




% Implication introduction rule




% Implication elimination rule
verify_rule([_, Statement2, impel(Row1, Row2)], _, Previous) :-
    member([Row1, Statement1, _], Previous),
    member([Row2, imp(Statement1, Statement2), _], Previous).

% Negation introduction rule




% Negation elimination rule




% Contradiction elimination




% Negation negation introduction




% Negation negation elimination




% MT rule




% PBC rule




% LEM rule




