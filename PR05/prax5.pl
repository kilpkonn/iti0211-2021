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

reisi(X, Y) :- not(labitud(X)), abolish(labitud/1), (laevaga(X, Y, _); bussiga(X, Y, _); rongiga(X, Y, _); lennukiga(X, Y, _)), !.
reisi(X, Y) :- laevaga(X, Z, _), not(labitud(X)), asserta(labitud(X)), reisi(Z, Y).
reisi(X, Y) :- bussiga(X, Z, _), not(labitud(X)), asserta(labitud(X)), reisi(Z, Y).
reisi(X, Y) :- rongiga(X, Z, _), not(labitud(X)), asserta(labitud(X)), reisi(Z, Y).
reisi(X, Y) :- lennukiga(X, Z, _), not(labitud(X)), asserta(labitud(X)), reisi(Z, Y).

reisi(X, Y, Path) :- (laevaga(X, Y, _); bussiga(X, Y, _); rongiga(X, Y, _); lennukiga(X, Y, _)), Path = mine(X, Y), !.
reisi(X, Y, Path) :- 
  (laevaga(X, Z, _); bussiga(X, Z, _); rongiga(X, Z, _); lennukiga(X, Z, _)),
  Path = mine(X, Z, SubPath),
  reisi(Z, Y, SubPath), !.

reisi_transpordiga(X, Y, Path) :- laevaga(X, Y, _), Path = mine(X, Y, laevaga), !.
reisi_transpordiga(X, Y, Path) :- bussiga(X, Y, _), Path = mine(X, Y, bussiga), !.
reisi_transpordiga(X, Y, Path) :- rongiga(X, Y, _), Path = mine(X, Y, rongiga), !.
reisi_transpordiga(X, Y, Path) :- lennukiga(X, Y, _), Path = mine(X, Y, lennukiga), !.
reisi_transpordiga(X, Y, Path) :- laevaga(X, Z, _),
  Path = mine(X, Z, laevaga, SubPath),
  reisi_transpordiga(Z, Y, SubPath).
reisi_transpordiga(X, Y, Path) :- bussiga(X, Z, _),
  Path = mine(X, Z, bussiga, SubPath),
  reisi_transpordiga(Z, Y, SubPath).
reisi_transpordiga(X, Y, Path) :- rongiga(X, Z, _),
  Path = mine(X, Z, rongiga, SubPath),
  reisi_transpordiga(Z, Y, SubPath).
reisi_transpordiga(X, Y, Path) :- lennukiga(X, Z, _),
  Path = mine(X, Z, lennukiga, SubPath),
  reisi_transpordiga(Z, Y, SubPath).


reisi(X, Y, Path, Cost) :- laevaga(X, Y, Cost), Path = mine(X, Y, laevaga), !.
reisi(X, Y, Path, Cost) :- bussiga(X, Y, Cost), Path = mine(X, Y, bussiga), !.
reisi(X, Y, Path, Cost) :- rongiga(X, Y, Cost), Path = mine(X, Y, rongiga), !.
reisi(X, Y, Path, Cost) :- lennukiga(X, Y, Cost), Path = mine(X, Y, lennukiga), !.
reisi(X, Y, Path, Cost) :- laevaga(X, Z, CostA),
  Path = mine(X, Z, laevaga, SubPath),
  reisi(Z, Y, SubPath, CostB),
  Cost is CostA + CostB.
reisi(X, Y, Path, Cost) :- bussiga(X, Z, CostA),
  Path = mine(X, Z, bussiga, SubPath),
  reisi(Z, Y, SubPath, CostB),
  Cost is CostA + CostB.
reisi(X, Y, Path, Cost) :- rongiga(X, Z, CostA),
  Path = mine(X, Z, rongiga, SubPath),
  reisi(Z, Y, SubPath, CostB),
  Cost is CostA + CostB.
reisi(X, Y, Path, Cost) :- lennukiga(X, Z, CostA),
  Path = mine(X, Z, lennukiga, SubPath),
  reisi(Z, Y, SubPath, CostB),
  Cost is CostA + CostB.

