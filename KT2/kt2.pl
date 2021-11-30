% 1.
% noor ja osav mees sepistab kirvest => phrase(lause, [noor, ja, osav, mees, sepistab, kirvest]).
% naine ütleb, et noor mees sepistab kirvest => phrase(lause, [naine, ütleb, ',', et, noor, mees, sepistab, kirvest]).

lause --> lihtlause ; liitlause.

lihtlause --> niminsonafraas, tegusonafraas.
liitlause --> lihtlause, sidesona, lihtlause.
liitlause --> lihtlause, sidesona, sidesona, liitlause.

niminsonafraas --> nimisona.
niminsonafraas --> omadussonafraas, nimisona.

omadussonafraas --> omadussona.
omadussonafraas --> omadussona, sidesona, omadussonafraas.

tegusonafraas --> tegusona, sihitis.

omadussona --> [noor] ; [osav] ; [].
nimisona --> [naine] ; [mees].
sidesona --> [ja] ; [',', et].
tegusona --> [sepistab] ; [ütleb].
sihitis --> [kirvest] ; [].


% 2.
:- use_module(library(lists)).

% Juhuks kui listide library pole lubatud
% append([],L,L).
% append([X | Xs], Ys, [X | Res]) :- append(XS, Ys, Res).

paarid([], _, []).
paarid([A | As], B, [[A, B] | Res]) :-
  paarid(As, B, Res).

ristkorrutis([], _, []).
ristkorrutis(_, [], []).
ristkorrutis(As, [B | Bs], Res) :-
  paarid(As, B, BPaarid),
  ristkorrutis(As, Bs, MuudPaarid),
  append(BPaarid, MuudPaarid, Res).


% 3.

:- dynamic hulk/2.
:- dynamic paar/2.

hulk(h,1).
hulk(h,2).
hulk(h,3).
hulk(h,4).

generate_pairs(HulgaNimi) :-
  hulk(HulgaNimi, N1),
  hulk(HulgaNimi, N2),
  N1 < N2,
  assertz(paar(N1, N2)),
  fail.

generate_pairs(_).


% 4. v siis 2.? :p

loe_ja_eemalda([], _, 0, []).
loe_ja_eemalda([X | Xs], Y, N, Out) :-
  X = Y,
  loe_ja_eemalda(Xs, Y, M, Out),
  N is 1 + M.
loe_ja_eemalda([X | Xs], Y, N, [X | Out]) :-
  X \= Y,
  N = M,
  loe_ja_eemalda(Xs, Y, M, Out).



kk([], []).
kk([A | As], [[A, N] | Out]) :-
  loe_ja_eemalda([A | As], A, N, Bs),
  kk(Bs, Out).

