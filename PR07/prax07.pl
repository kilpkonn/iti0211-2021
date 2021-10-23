:- use_module(library(lists)).

% is_a(SubClass, Class).
is_a(roovloomad,elusolend).
is_a(mitte-roovloomad,elusolend).
is_a(veeimetajad,roovloomad).
is_a(kalad,roovloomad).
is_a(saarmas,veeimetajad).
is_a(kobras,veeimetajad).
is_a(ahven,kalad).
is_a(haug,kalad).
is_a(zooplankton,mitte-roovloomad).
is_a(veetaimed,mitte-roovloomad).
is_a(vesikatk,veetaimed).
is_a(vetikas,veetaimed).


% eats(Who, Whom).
eats(zooplankton,veetaimed).
eats(kalad,zooplankton).
eats(veeimetajad,kalad).


% count_terminals(Node, Terminals, Count),
count_terminals(Node, [Node], 1) :-
  not(is_a(_, Node)), !.
count_terminals(Node, Terminals, Count) :-
  findall(X, (is_a(NextNode, Node), count_terminals(NextNode, X, _)), NestedTerminals),
  flatten(NestedTerminals, Terminals),
  length(Terminals, Count).


% extinction(Node, OtherNodes, Count).
extinction(Node, OtherNodes, Count) :-
  not(eats(_, Node)),
  count_terminals(Node, OtherNodes, Count), !.

extinction(Node, OtherNodes, Count) :-
  findall(X, (eats(NextNode, Node), extinction(NextNode, X, _)), DeadNext),
  flatten(DeadNext, DeadFuture),
  count_terminals(Node, DeadNow, _),
  append(DeadNow, DeadFuture, OtherNodes),
  length(OtherNodes, Count).


% find_most_sensitive_species(Node, Count, DeadList).

:- dynamic max/3.
max(x, [], 0).  % Dummy data

see_what_happens :-
  (is_a(Node, _); is_a(_, Node)),
  extinction(Node, WillDie, KillCount),
  max(_, _, MaxDead),
  (KillCount > MaxDead, retractall(max(_,_,_)), asserta(max(Node, WillDie, KillCount))).

find_most_sensitive_species(Node, Count, DeadList) :-
   findall(_, see_what_happens, _),
   max(Node, DeadList, Count),
   Count > 0.
