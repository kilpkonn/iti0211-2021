laevaga(tallinn, helsinki, 120).
laevaga(tallinn, stockholm, 480).
bussiga(tallinn, riia, 300).
rongiga(riia, berlin, 680).
lennukiga(tallinn, helsinki, 30).
lennukiga(helsinki, paris, 180).
lennukiga(paris, berlin, 120). 
lennukiga(paris, tallinn, 120).

:- dynamic labitud/1.

reisi(X, Y) :- laevaga(X, Y, _); bussiga(X, Y, _); rongiga(X, Y, _); lennukiga(X, Y, _), !.
reisi(X, Y) :- laevaga(X, Z, _), reisi(Z, Y).
reisi(X, Y) :- bussiga(X, Z, _), reisi(Z, Y).
reisi(X, Y) :- rongiga(X, Z, _), reisi(Z, Y).
reisi(X, Y) :- lennukiga(X, Z, _), reisi(Z, Y).

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

