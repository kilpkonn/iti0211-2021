:- module(iapm211564, [iapm211564/3]).

:- use_module(library(lists)).

iapm211564(Color, X, Y) :-
  findall(R, (ruut(X1, Y1, C), R = ruut(X1, Y1, C)), State),
  find_matching_state(State, StateId),
  simulate_moves(StateId, Color, _, _, 3),
  write([X, Y]),
  (
    X \= 0, Y \= 0, FromX = X, FromY = Y ;
    true
  ),
  choose_best_move(StateId, Color, FromX, FromY, MoveId),
  write([StateId, "to", MoveId]),
  exec_move(StateId, MoveId),
  !.
iapm211564(_, _, _).


:- dynamic last_id/1.
last_id(0).


:- dynamic move_option/9.  % NOTE: FromId, ToId, FromX, FromY, ToX, ToY, MinScore, MaxScore, Color
:- dynamic state/4.        % NOTE: Id, X, Y, Color

% Fast-forward
simulate_moves(CurrentId, Color, FromX, FromY, Depth) :-
  (
    Color = 1, NewColor = 2;
    Color = 2, NewColor = 1
  ),
  (
    Depth > 1, NewDepth is Depth - 1 ;
    NewDepth is Depth
  ),
  bagof(_, (
    move_option(CurrentId, NextId, FromX, FromY, _, _, _, _, Color),
    simulate_moves(NextId, NewColor, _, _, NewDepth)
  ), _),
  !.

simulate_moves(CurrentId, Color, FromX, FromY, Depth) :-
  Depth >= 0,
  state(CurrentId, FromX, FromY, Color),  % Go over all own stones onless forced to one
  possible_simple_take(CurrentId, Color, FromX, FromY, OverX, OverY, ToX, ToY),
  increment_id(NewId),
  do_eat(CurrentId, NewId, FromX, FromY, OverX, OverY, ToX, ToY),
  (
    Color = 1, NewColor = 2;
    Color = 2, NewColor = 1
  ),
  NewDepth is Depth - 1,
  simulate_moves(NewId, NewColor, _, _, NewDepth),
  !.  % TODO: Consider multiple eats

simulate_moves(CurrentId, Color, FromX, FromY, Depth) :-
  Depth >= 0,
  state(CurrentId, FromX, FromY, Color),  % Go over all own stones onless forced to one
  possible_simple_move(CurrentId, Color, FromX, FromY, ToX, ToY),
  increment_id(NewId),
  do_move(CurrentId, NewId, FromX, FromY, ToX, ToY),
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
    OverX is FromX + 1, ToX is FromX + 2 ;
    OverX is FromX - 1, ToX is FromX - 2
  ),
  (ToY is FromY - 2, OverY is FromY - 1; ToY is FromY + 2, OverY is FromY + 1),
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


% do_move(FromId, ToId, _, _, _, _) :-
%   move_option(FromId, ToId, _, _, _, _, _), !.

do_move(FromId, ToId, FromX, FromY, ToX, ToY) :-
  is_new_state(ToId),
  state(FromId, FromX, FromY, Color),
  asserta(state(ToId, FromX, FromY, 0)),
  asserta(state(ToId, ToX, ToY, Color)),
  state(FromId, X, Y, C),
  not((
    X = FromX, Y = FromY ;
    X = ToX, Y = ToY
  )),
  asserta(state(ToId, X, Y, C)),
  fail.
do_move(FromId, ToId, FromX, FromY, ToX, ToY) :-
  evaluate_board(ToId, Score),
  state(ToId, ToX, ToY, Color),
  (
    same_color(Color, 1), C is 1 ;
    same_color(Color, 2), C is 2
  ),
  asserta(move_option(FromId, ToId, FromX, FromY, ToX, ToY, Score, Score, C)).

% do_eat(FromId, ToId, _, _, _, _, _, _) :-
%   move_option(FromId, ToId, _, _, _, _, _), !.

do_eat(FromId, ToId, FromX, FromY, OverX, OverY, ToX, ToY) :-
  is_new_state(ToId),
  state(FromId, FromX, FromY, Color),
  asserta(state(ToId, FromX, FromY, 0)),
  asserta(state(ToId, OverX, OverY, 0)),
  asserta(state(ToId, ToX, ToY, Color)),
  state(FromId, X, Y, C),
  not((
    X = FromX, Y = FromY ;
    X = OverX, Y = OverY ;
    X = ToX, Y = ToY)),
  asserta(state(ToId, X, Y, C)),
  fail.
do_eat(FromId, ToId, FromX, FromY, _, _, ToX, ToY) :-
  evaluate_board(ToId, Score),
  state(ToId, ToX, ToY, Color),
  (
    same_color(Color, 1), C is 1 ;
    same_color(Color, 2), C is 2
  ),
  asserta(move_option(FromId, ToId, FromX, FromY, ToX, ToY, Score, Score, C)).

is_new_state(Id) :-
  not(state(Id, _, _, _)), !.


choose_best_move(StateId, Color, FromX, FromY, MoveId) :-
  (
    same_color(Color, 1), C is 1 ;
    same_color(Color, 2), C is 2
  ),
  evaluate_moves_tree(StateId, MaxScore, MinScore, C),
  write([StateId, Color, MinScore, MaxScore]),
  (
    same_color(Color, 1), move_option(StateId, MoveId, FromX, FromY, _, _, _, MaxScore, 1) ;
    same_color(Color, 2), move_option(StateId, MoveId, FromX, FromY, _, _, MinScore, _, 2)
  ).


stone_score(1, 1).
stone_score(2, -1).
stone_score(10, 10).
stone_score(20, -10).

evaluate_board(Id, Score) :-
  findall(Score, (state(Id, _, _, Stone), stone_score(Stone, Score)), Scores),
  sum_list(Scores, Score).

evaluate_moves_tree_step(FromId, ToId, Min, Max, Color) :-
  not(move_option(ToId, _, _, _, _, _, _, _, Color)),
  move_option(FromId, ToId, _, _, _, _, Min, Max, Color), !.

evaluate_moves_tree_step(FromId, ToId, Min, Max, Color) :-
  (
    same_color(Color, 1), C is 2 ;
    same_color(Color, 2), C is 1
  ),
  evaluate_moves_tree(ToId, Max, Min, C),
  retract(move_option(FromId, ToId, FromX, FromY, ToX, ToY, _, _, Color)),
  asserta(move_option(FromId, ToId, FromX, FromY, ToX, ToY, Min, Max, Color)), !.

evaluate_moves_tree(Id, MaxScore, MinScore, Color) :-
  findall(Tmp, 
    (
      move_option(Id, ToOptionId, _, _, _, _, _, _, Color),
      evaluate_moves_tree_step(Id, ToOptionId, Min, Max, Color),
      Tmp = minmax(Min, Max)
    ), Res),
  % write([Id, Res]), write("\n"),
  min_and_max(Res, MinScore, MaxScore),
  % write([MinScore, MaxScore]),
  !.

copy_board :-
  increment_id(NewId),
  ruut(X, Y, C),
  asserta(state(NewId, X, Y, C)),
  fail.
copy_board.

exec_move(FromId, ToId) :-
  move_option(FromId, ToId, FromX, FromY, ToX, ToY, _, _, _),
  write(["move", FromX, FromY, ToX, ToY]),
  retract(ruut(FromX, FromY, C)),
  asserta(ruut(FromX, FromY, 0)),
  retract(ruut(ToX, ToY, _)),
  asserta(ruut(ToX, ToY, C)),
  eat_in_between(FromX, FromY, ToX, ToY).

eat_in_between(FromX, FromY, ToX, ToY) :-
  % write([FromX, FromY, ToX, ToY]),
  ruut(X, Y, _),
  (
    FromX < X, X < ToX ;
    ToX < X, X < FromX
  ),
  (
    FromY < Y, Y < ToY ;
    ToY < Y, Y < FromY
  ),
  retract(ruut(X, Y, _)),
  asserta(ruut(X, Y, 0)),
  fail.
eat_in_between(_, _, _, _).


find_matching_state(State, StateId) :-
  state(Id, _, _, _),
  findall(R, state_to_ruut(Id, R), Res),
  unordered_list_eq(State, Res),
  StateId = Id.

find_matching_state(_, StateId) :-
  copy_board, last_id(StateId), !.

state_to_ruut(Id, State) :-
  state(Id, X, Y, C),
  State = ruut(X, Y, C).


increment_id(NewId) :-
  last_id(Id),
  NewId is Id + 1,
  retractall(last_id/1),
  asserta(last_id(NewId)), !.

unordered_list_eq(Xs, Ys) :-
  length(Xs, L1),
  length(Ys, L2),
  L1 = L2,
  subtract(Xs, Ys, []).

sum_list([], 0).
sum_list([H|T], Sum) :-
   sum_list(T, Rest),
   Sum is H + Rest.

 % Last-call optimization from: https://hpincket.com/prolog-exercise-min-and-max-of-a-list.html 
min_and_max([minmax(Min, Max)], Min, Max).
min_and_max([minmax(MinSoFar, MaxSoFar)|R], Min, Max) :-
    min_and_max_helper(R, MinSoFar, MaxSoFar, Min, Max).

min_and_max_helper([], A, B, A, B).
min_and_max_helper([minmax(Min, Max)|R], MinSoFar, MaxSoFar, FinalMin, FinalMax) :-
  MinSoFar1 is min(MinSoFar, Min),
  MaxSoFar1 is max(MaxSoFar, Max),
  min_and_max_helper(R, MinSoFar1, MaxSoFar1, FinalMin, FinalMax).
  
