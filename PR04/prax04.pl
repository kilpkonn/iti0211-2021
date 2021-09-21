laevaga(tallinn, helsinki, 120).
laevaga(tallinn, stockholm, 480).
bussiga(tallinn, riia, 300).
rongiga(riia, berlin, 680).
lennukiga(tallinn, helsinki, 30).
lennukiga(helsinki, paris, 180).
lennukiga(paris, berlin, 120). 
lennukiga(paris, tallinn, 120).
% bussiga)berlin, tallinn, 1200).


reisi(X, Y) :- laevaga(X, Y, _); bussiga(X, Y, _); rongiga(X, Y, _); lennukiga(X, Y, _).
reisi(X, Y) :- (laevaga(X, Y, _); bussiga(X, Y, _); rongiga(X, Y, _); lennukiga(X, Y, _)), reisi(Z, Y), !.

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
  Cost is CostA + CostB,
  reisi(Z, Y, SubPath, CostB).
reisi(X, Y, Path, Cost) :- bussiga(X, Z, CostA),
  Path = mine(X, Z, bussiga, SubPath),
  Cost is CostA + CostB,
  reisi(Z, Y, SubPath, CostB).
reisi(X, Y, Path, Cost) :- rongiga(X, Z, CostA),
  Path = mine(X, Z, rongiga, SubPath),
  Cost is CostA + CostB,
  reisi(Z, Y, SubPath, CostB).
reisi(X, Y, Path, Cost) :- lennukiga(X, Z, CostA),
  Path = mine(X, Z, lennukiga, SubPath),
  Cost is CostA + CostB,
  reisi(Z, Y, SubPath, CostB).

