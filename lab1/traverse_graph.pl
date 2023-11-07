%
%     a----b--
%    /    /    \
%   c    e      g
%    \    \    /
%     d----f--
%  

% Defining of nodes


% Defning of edges
edge(a, c).
edge(c, a).

edge(a,d).
edge(d,a).

edge(c, d).
edge(d, c).

edge(d, f).
edge(f, d).

edge(a, b).
edge(b, a).

edge(b, e).
edge(e, b).

edge(e, f).
edge(f, e).

edge(b, g).
edge(g, b).

edge(f, g).
edge(g, f).

% Helper method
member(X, [X|_]) :- !.
member(X, [_|T]) :- member(X, T).

% Method for reversing a list
reverse_list([],[]).
reverse_list([H|T], Reversed) :-
    reverse_list(T, RevTail),
    append(RevTail, [H], Reversed).

% Traverse graph method
traverse(Start, End, Path) :- 
    traverse(Start, End, [Start], RevPath), % Finds paths if there are any
    reverse_list(RevPath, Path). % Reverses the path to be in right order

traverse(End, End, Visited, Visited). % Base case
traverse(Start, End, Visited, Path) :-
    edge(Start, Middle), 
    \+ member(Middle, Visited),
    traverse(Middle, End, [Middle|Visited], Path).


