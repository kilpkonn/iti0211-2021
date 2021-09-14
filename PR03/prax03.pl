
viimane_element(X, [X]).
viimane_element(X, [_ | Xs]) :- viimane_element(X, Xs).


suurim([], []).
suurim([X], [X | _]).
suurim([X, Z | Xs], Ys) :- 
  X >= Z,
  Ys = [X | Zs],
  suurim([Z | Xs], Zs).
suurim([X, Z | Xs], Ys) :- 
  X < Z,
  Ys = [Z | Zs],
  suurim([Z | Xs], Zs).
