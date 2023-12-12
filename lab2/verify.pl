
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

last_line([[Row, Statement, Rule]], [Row, Statement, Rule]).
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
% Verifies that a box is valid, i.e. all the lines in it are valid
% With the box as an argument, each line is added to the previously seen lines. 
% When backtracking (after the last line has been checked), each line is "removed" 
% and eventually the entire box is added to the previous array in the proof iterator method
verify_rule([[Row, Statement, assumption]|Box], Prems, Previous) :-
    verify_proof(Box, Prems, [[Row, Statement, assumption]|Previous]).


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
verify_rule([_, Statement3, orel(Row1, Row2, Row3, Row4, Row5)], _, Previous) :-
    member([Row1, or(Statement1, Statement2), _], Previous), % Check if the or statement exists and what its parameters are 
    member([[Row2, Statement1, assumption]|Box1], Previous), % Check for a box that has the first parameter as statement (assumption)
    last_line([[Row2, Statement1, assumption]|Box1], Last_line_box1), % Retrieve the last line in the box
    [Row3, Statement3, _] = Last_line_box1, % Check if the excpected last line is the same as the actual last line
    member([[Row4, Statement2, assumption]|Box2], Previous), % Same as above but for the other box
    last_line([[Row4, Statement2, assumption]|Box2], Last_line_box2),
    [Row5, Statement3, _] = Last_line_box2.


% Implication introduction rule
verify_rule([_, imp(Statement1, Statement2), impint(Row1, Row2)], _, Previous) :-
    member([[Row1, Statement1, assumption]|Box], Previous), % Check if there is a box containing the line
    last_line([[Row1, Statement1, assumption]|Box], Last_line_box), % Get the last line of the box
    [Row2, Statement2, _] = Last_line_box. % Check if the line is the last line in the box


% Implication elimination rule
verify_rule([_, Statement2, impel(Row1, Row2)], _, Previous) :-
    member([Row1, Statement1, _], Previous),
    member([Row2, imp(Statement1, Statement2), _], Previous).


% Negation introduction rule
verify_rule([_, neg(Statement), negint(Row1, Row2)], _, Previous) :-
    member([[Row1, Statement, assumption]|Box], Previous),
    last_line([[Row1, Statement, assumption]|Box], Last_line_box),
    [Row2, cont, _] = Last_line_box.


% Negation elimination rule
verify_rule([_, cont, negel(Row1, Row2)], _, Previous) :-
    member([Row1, Statement, _], Previous),
    member([Row2, neg(Statement), _], Previous).


% Contradiction elimination
verify_rule([_, _, contel(Row)], _, Previous) :-
   member([Row, cont, _], Previous).


% Negation negation introduction
verify_rule([_, neg(neg(Statement)), negnegint(Row)], _, Previous) :-
    member([Row, Statement, _], Previous).


% Negation negation elimination
verify_rule([_, Statement, negnegel(Row)], _, Previous) :-
    member([Row, neg(neg(Statement)), _], Previous).


% MT rule
verify_rule([_, neg(Statement1), mt(Row1, Row2)], _, Previous) :-
    member([Row1, imp(Statement1, Statement2), _], Previous),
    member([Row2, neg(Statement2), _], Previous).


% PBC rule
verify_rule([_, Statement, pbc(Row1, Row2)], _, Previous) :-
    member([[Row1, neg(Statement), assumption]|Box], Previous),
    last_line([[Row1, neg(Statement), assumption]|Box], Last_line_box),
    [Row2, cont, _] = Last_line_box.


% LEM rule
verify_rule([_, or(Statement, neg(Statement)), lem], _, _).

