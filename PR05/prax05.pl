laevaga(tallinn, helsinki, 120).
laevaga(tallinn, stockholm, 480).
bussiga(tallinn, riia, 300).
rongiga(riia, berlin, 680).
lennukiga(tallinn, helsinki, 30).
lennukiga(helsinki, paris, 180).
lennukiga(paris, berlin, 120). 
lennukiga(paris, tallinn, 120).

laevaga(tallinn, helsinki, 120, time(12, 45, 0.0), time(14, 45, 0.0)). 
laevaga(tallinn, stockholm, 480, time(13, 45, 0.0), time(14, 45, 0.0)).
bussiga(tallinn, riia, 300, time(10, 10, 0.0), time(11, 11, 1.0)).
rongiga(riia, berlin, 680, time(11, 11, 10.0), time(12, 12, 10.0)).
lennukiga(tallinn, helsinki, 30, time(14, 20, 30.0), time(16, 30, 0.0)).
lennukiga(helsinki, paris, 180, time(13, 20, 0.0), time(15, 50, 0.0)).
lennukiga(paris, berlin, 120, time(13, 15, 0.0), time(16, 15, 20.0)).
lennukiga(paris, tallinn, 12, time(12, 15, 0.0), time(20, 15, 20.0)).


:- dynamic labitud/1.

reisi(X, Y) :- not(labitud(X)), laevaga(X, Y, _); bussiga(X, Y, _); rongiga(X, Y, _); lennukiga(X, Y, _), !.

reisi(X, Y) :- not(labitud(X)), asserta(labitud(X)), 
  (laevaga(X, Z, _) ; retract(labitud(X)), fail),
  reisi(Z, Y), retract(labitud(X)).
reisi(X, Y) :- not(labitud(X)), asserta(labitud(X)),
  (bussiga(X, Z, _) ; retract(labitud(X)), fail),
  reisi(Z, Y), retract(labitud(X)).
reisi(X, Y) :- not(labitud(X)), asserta(labitud(X)),
  (rongiga(X, Z, _) ; retract(labitud(X)), fail),
    reisi(Z, Y), retract(labitud(X)).
reisi(X, Y) :- not(labitud(X)), asserta(labitud(X)),
  (lennukiga(X, Z, _) ; retract(labitud(X)), fail),
  reisi(Z, Y), retract(labitud(X)).

reisi(X, Y, Path) :- not(labitud(X)), (laevaga(X, Y, _); bussiga(X, Y, _); rongiga(X, Y, _); lennukiga(X, Y, _)), Path = mine(X, Y), !.
reisi(X, Y, Path) :- 
  not(labitud(X)), asserta(labitud(X)),
  ((laevaga(X, Z, _); bussiga(X, Z, _); rongiga(X, Z, _); lennukiga(X, Z, _)) ; retract(labitud(X)), fail),
  Path = mine(X, Z, SubPath),
  reisi(Z, Y, SubPath),
  retract(labitud(X)), !.

reisi_transpordiga(X, Y, mine(X, Y, laevaga)) :- not(labitud(X)), laevaga(X, Y, _).
reisi_transpordiga(X, Y, mine(X, Y, bussiga)) :- not(labitud(X)), bussiga(X, Y, _).
reisi_transpordiga(X, Y, mine(X, Y, rongiga)) :- not(labitud(X)), rongiga(X, Y, _).
reisi_transpordiga(X, Y, mine(X, Y, lennukiga)) :- not(labitud(X)), lennukiga(X, Y, _).

reisi_transpordiga(X, Y, mine(X, Z, laevaga, SubPath)) :- laevaga(X, Z, _), 
  not(labitud(X)), asserta(labitud(X)), 
  (reisi_transpordiga(Z, Y, SubPath) ; retract(labitud(X)), fail),
  retract(labitud(X)).
reisi_transpordiga(X, Y, mine(X, Z, bussiga, SubPath)) :- bussiga(X, Z, _), 
  not(labitud(X)), asserta(labitud(X)), 
  (reisi_transpordiga(Z, Y, SubPath) ; retract(labitud(X)), fail),
  retract(labitud(X)).
reisi_transpordiga(X, Y, mine(X, Z, rongiga, SubPath)) :- rongiga(X, Z, _), 
  not(labitud(X)), asserta(labitud(X)), 
  (reisi_transpordiga(Z, Y, SubPath) ; retract(labitud(X)), fail),
  retract(labitud(X)).
reisi_transpordiga(X, Y, mine(X, Z, lennukiga, SubPath)) :- lennukiga(X, Z, _),
  not(labitud(X)), asserta(labitud(X)), 
  (reisi_transpordiga(Z, Y, SubPath) ; retract(labitud(X)), fail),
  retract(labitud(X)).


reisi(X, Y, Path, Cost) :- not(labitud(X)), laevaga(X, Y, Cost), Path = mine(X, Y, laevaga), !.
reisi(X, Y, Path, Cost) :- not(labitud(X)), bussiga(X, Y, Cost), Path = mine(X, Y, bussiga), !.
reisi(X, Y, Path, Cost) :- not(labitud(X)), rongiga(X, Y, Cost), Path = mine(X, Y, rongiga), !.
reisi(X, Y, Path, Cost) :- not(labitud(X)), lennukiga(X, Y, Cost), Path = mine(X, Y, lennukiga), !.

reisi(X, Y, mine(X, Z, laevaga, SubPath), Cost) :- laevaga(X, Z, CostA),
  not(labitud(X)), asserta(labitud(X)),
  (reisi(Z, Y, SubPath, CostB) ; retract(labitud(X)), fail),
  Cost is CostA + CostB,
  retract(labitud(X)).
reisi(X, Y, mine(X, Z, bussiga, SubPath), Cost) :- bussiga(X, Z, CostA),
  not(labitud(X)), asserta(labitud(X)),
  (reisi(Z, Y, SubPath, CostB) ; retract(labitud(X)), fail),
  Cost is CostA + CostB,
  retract(labitud(X)).
reisi(X, Y, mine(X, Z, rongiga, SubPath), Cost) :- rongiga(X, Z, CostA),
  not(labitud(X)), asserta(labitud(X)),
  (reisi(Z, Y, SubPath, CostB) ; retract(labitud(X)), fail),
  Cost is CostA + CostB,
  retract(labitud(X)).
reisi(X, Y, mine(X, Z, lennukiga, SubPath), Cost) :- lennukiga(X, Z, CostA),
  not(labitud(X)), asserta(labitud(X)),
  (reisi(Z, Y, SubPath, CostB) ; retract(labitud(X)), fail),
  Cost is CostA + CostB,
  retract(labitud(X)).

min_list([Head], Head).
min_list([Head, Next | Tail], N) :- 
  (Head =< Next, min_list([Head | Tail], N));
  (Head > Next, min_list([Next | Tail], N)).

odavaim_reis(X, Y, Path, Cost) :- 
  bagof(TmpCost, reisi(X, Y, _, TmpCost), Results),
  min_list(Results, Cost),
  reisi(X, Y, Path, Cost).


time_diff_s(time(H1, M1, S1), time(H2, M2, S2), DiffS) :- 
  Diff is (H2 - H1) * 3600 + (M2 - M1) * 60 + (S2 - S1),
  (
    Diff > 0, DiffS = Diff;
    DiffS is Diff + 24 * 60 * 60
  ).

:- dynamic eelmise_lopp/1.
eelmise_lopp(time(0, 0, 0)).

reisi(X, Y, Path, Cost, TimeS) :- 
  not(labitud(X)), 
  ( 
    laevaga(X, Y, Cost, TimeStart, TimeEnd), Path = mine(X, Y, laevaga);
    bussiga(X, Y, Cost, TimeStart, TimeEnd), Path = mine(X, Y, bussiga);
    rongiga(X, Y, Cost, TimeStart, TimeEnd), Path = mine(X, Y, rongiga);
    lennukiga(X, Y, Cost, TimeStart, TimeEnd), Path = mine(X, Y, lennukiga)
  ),
  eelmise_lopp(TimeLast),
  time_diff_s(TimeLast, TimeStart, WaitTime),
  WaitTime > 60 * 60,
  time_diff_s(TimeStart, TimeEnd, TimeS).

reisi(X, Y, Path, Cost, TimeS) :-
  not(labitud(X)),
  (
    laevaga(X, Z, CostA, TimeStart, TimeEnd), Path = mine(X, Z, laevaga, SubPath);
    bussiga(X, Z, CostA, TimeStart, TimeEnd), Path = mine(X, Z, bussiga, SubPath);
    rongiga(X, Z, CostA, TimeStart, TimeEnd), Path = mine(X, Z, rongiga, SubPath);
    lennukiga(X, Z, CostA, TimeStart, TimeEnd), Path = mine(X, Z, lennukiga, SubPath)
  ),
  eelmise_lopp(TimeLast),
  time_diff_s(TimeLast, TimeStart, WaitTime),
  WaitTime > 60 * 60,
  asserta(labitud(X)),
  abolish(eelmise_lopp/1), asserta(eelmise_lopp(TimeEnd)),
  (reisi(Z, Y, SubPath, CostB, TimeRest) ; retract(labitud(X)), abolish(eelmise_lopp/1), asserta(eelmise_lopp(TimeLast)), fail),
  retract(labitud(X)),
  Cost is CostA + CostB,
  time_diff_s(TimeStart, TimeEnd, TimeCurr),
  TimeS is TimeCurr + TimeRest,
  abolish(eelmise_lopp/1), asserta(eelmise_lopp(TimeLast)).

lyhim_reis(X, Y, Path, Cost) :-
  bagof(TmpTime, reisi(X, Y, _, _, TmpTime), Results),
  min_list(Results, MinTime),
  reisi(X, Y, Path, Cost, MinTime).
