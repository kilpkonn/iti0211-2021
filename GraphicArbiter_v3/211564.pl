:- module(iapm211564, [iapm211564/3]).

:- use_module(library(lists)).

iapm211564(Color, X, Y) :-
  findall(R, (ruut(X, Y, C), R = ruut(X, Y, C)), State),
  find_matching_state(State, StateId),
  !.
iapm211564(_, _, _).


:- dynamic last_id/1.
last_id(0).


:- dynamic move_option/7.  % NOTE: FromId, ToId, FromX, FromY, ToX, ToY, Score
:- dynamic state/4.        % NOTE: Id, X, Y, Color


simulate_moves(CurrentId, Color, FromX, FromY, Depth) :-
  Depth >= 0,
  ruut(FromX, FromY, Color),  % Go over all own stones onless forced to one
  possible_simple_take(CurrentId, Color, FromX, FromY, OverX, OverY, ToX, ToY),
  last_id(Id),
  NewId is Id + 1,
  asserta(last_id(NewId)),
  retractall(last_id/1),
  do_eat(CurrentId, NewId, FromX, FromY, OverX, OverY, ToX, ToY),
  asserta(move_option(CurrentId, NewId, FromX, FromY, ToX, ToY, -1)),  % TODO: score
  (
    Color = 1, NewColor = 2;
    Color = 2, NewColor = 1
  ),
  NewDepth is Depth - 1,
  simulate_moves(NewId, NewColor, _, _, NewDepth),
  !.  % TODO: Consider multiple eats

simulate_moves(CurrentId, Color, FromX, FromY, Depth) :-
  Depth >= 0,
  ruut(FromX, FromY, Color),  % Go over all own stones onless forced to one
  possible_simple_move(CurrentId, Color, FromX, FromY, OverX, OverY, ToX, ToY),
  last_id(Id),
  NewId is Id + 1,
  retractall(last_id/1),
  asserta(last_id(NewId)),
  do_move(CurrentId, NewId, FromX, FromY, ToX, ToY),
  asserta(move_option(CurrentId, NewId, FromX, FromY, ToX, ToY, -1)),  % TODO: score
  (
    Color = 1, NewColor = 2;
    Color = 2, NewColor = 1
  ),
  NewDepth is Depth - 1,
  simulate_moves(NewId, NewColor, _, _, NewDepth),
  fail.

simulate_moves(_, _, _, _, _).



possible_simple_move(CurrentId, Color, FromX, FromY, ToX, ToY) :-
  (
    Color = 1, ToX is FromX + 1 ;
    Color = 2, ToX is FromX - 1
  ),
  (ToY is FromY - 1; ToY is FromY + 1),
  on_board(ToX, ToY),
  state(CurrentId, ToX, ToY, 0).


possible_simple_take(CurrentId, Color, FromX, FromY, OverX, OverY, ToX, ToY) :-
  (
    Color = 1, OverX is FromX + 1, ToX is FromX + 2 ;
    Color = 2, OverY is FromX - 1, ToX is FromX - 2
  ),
  (ToY is FromY - 1; ToY is FromY + 1),
  on_board(ToX, ToY),
  state(CurrentId, OverX, OverY, OtherColor),
  OtherColor \= 0,
  not(same_color(OtherColor, Color)),
  state(CurrentId, ToX, ToY, 0).

% TODO: Tamm move + take



on_board(X, Y) :-
  1 =< X, X =< 8,
  1 =< Y, Y =< 8, !.


same_color(C, C) :- !.
same_color(10, 1).
same_color(20, 2).
same_color(1, 10).
same_color(2, 20).


do_move(FromId, ToId, FromX, FromY, ToX, ToY) :-
  not(state(ToId, _, _, _)),
  state(FromId, FromX, FromY, Color),
  asserta(state(ToId, FromX, FromY, 0)),
  asserta(state(ToId, ToX, ToY, Color)),
  state(FromId, X, Y, C),
  X \= FromX, X \= ToX,
  Y \= FromY, Y \= ToY,
  asserta(state(ToId, X, Y, C)),
  fail.
do_move(_, _, _, _, _, _).

do_eat(FromId, ToId, FromX, FromY, OverX, OverY, ToX, ToY) :-
  not(state(ToId, _, _, _)),
  state(FromId, FromX, FromY, Color),
  asserta(state(ToId, FromX, FromY, 0)),
  asserta(state(ToId, OverX, OverY, 0)),
  asserta(state(ToId, ToX, ToY, Color)),
  state(FromId, X, Y, C),
  X \= FromX, X \= OverX, X \= ToX,
  Y \= FromY, Y \= OverY, Y \= ToY,
  asserta(state(ToId, X, Y, C)),
  fail.
do_eat(_, _, _, _, _, _, _, _).


stone_score(1, 1).
stone_score(2, 1).
stone_score(10, 10).
stone_score(20, 10).

evaluate_board(Id, Score) :-
  findall(Score, (state(Id, _, _, Stone), stone_score(Stone, Score)), Scores),
  sum_list(Scores, Score).


copy_board :-
  last_id(Id),
  NewId is Id + 1,
  retractall(last_id/1),
  asserta(last_id(NewId)),
  ruut(X, Y, C),
  asserta(state(NewId, X, Y, C)),
  fail.
copy_board.


find_matching_state(State, StateId) :-
  state(Id, _, _, _),
  findall(R, state_to_ruut(Id, R), Res),
  (
    unordered_list_eq(State, Res), StateId = Id ;
    copy_board, last_id(StateId)
  ).

state_to_ruut(Id, State) :-
  state(Id, X, Y, C),
  State = ruut(X, Y, C).


unordered_list_eq(Xs, Ys) :-
  length(Xs, L1),
  length(Ys, L2),
  L1 = L2,
  substract(Xs, Ys, []).

sum_list([], 0).
sum_list([H|T], Sum) :-
   sum_list(T, Rest),
   Sum is H + Rest.
  
