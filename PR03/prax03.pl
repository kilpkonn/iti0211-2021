
viimane_element(X, [X]).
viimane_element(X, [_ | Xs]) :- viimane_element(X, Xs).


suurim([], []).
suurim([X], [X]).
suurim([X, Z | Xs], [X | Ys]) :- 
  X >= Z,
  suurim([Z | Xs], Ys).
suurim([X, Z | Xs], [Z | Ys]) :- 
  X < Z,
  suurim([Z | Xs], Ys).


paki([], []).
paki([X], [X]).
paki([X, Y | Xs], Ys) :-
  X == Y,
  paki([Y | Xs], Ys).
paki([X, Y | Xs], [X | Ys]) :-
  X \= Y,
  paki([Y | Xs], Ys).


duplikeeri([], []).
duplikeeri([X | Xs], [X, X | Ys]) :-
  duplikeeri(Xs, Ys).

  
kordista_acc(_, 0, Xs, Xs) :- !.
kordista_acc(X, N, Xs, [X | Ys]) :-
  M is N - 1,
  kordista_acc(X, M, Xs, Ys).

kordista([], _, []).
kordista([X | Xs], N, Ys) :-
  kordista_acc(X, N, Zs, Ys),
  kordista(Xs, N, Zs).


paaritu_arv(X) :- 1 =:= X rem 2.
paaris_arv(X) :- 0 =:= X rem 2.
suurem_kui(N, M) :- N > M.

vordle_predikaadiga([], _, []).
vordle_predikaadiga([X | Xs], [Predikaat | Args], [X | Ys]) :-
  Term =.. [Predikaat, X | Args],
  Term,
  vordle_predikaadiga(Xs, [Predikaat | Args], Ys).
vordle_predikaadiga([X | Xs], [Predikaat | Args], Ys) :-
  Term =.. [Predikaat, X | Args],
  not(Term),
  vordle_predikaadiga(Xs, [Predikaat | Args], Ys).
