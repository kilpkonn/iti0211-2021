
% Task 1

remove_even([], []).
remove_even([X], [X]).
remove_even([X, _ | Xs], [X | Ys]) :-
  remove_even(Xs, Ys), !.


% Task 2

replace_el([], _, _, []).
replace_el([X | Xs], X, Y, [Y | Ys]) :-
  replace_el(Xs, X, Y, Ys), !.
replace_el([X | Xs], A, B, [X | Ys]) :-
  X \= A,  % Not needed due to red cut in prev statement, but just in case
  replace_el(Xs, A, B, Ys).
