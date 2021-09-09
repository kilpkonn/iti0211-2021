
male(tavo).
male(evo).
male(tarmo).
male(ahto).
male(mati).
male(teet).
male(kurmo).
male(ruudo).
male(matiIsa).
male(ahtoIsa).
female(liis).
female(terje).
female(malle).
female(tiiu).
female(tiiuEma).
female(malleEma).

married(terje, tarmo).
married(malle, ahto).
married(tiiu, mati).

mother(tavo, terje).
mother(evo, terje).
mother(liis, terje).
mother(terje, tiiu).
mother(teet, tiiu).
mother(kurmo, malle).
mother(ruudo, malle).
mother(tarmo, malle).
mother(tiiu, tiiuEma).
mother(malle, malleEma).

father(Child, Father) :- mother(Child, Mother), married(Mother, Father).
brother(Child, Brother) :- mother(Child, Mother), mother(Brother, Mother), male(Brother), Brother \= Child.
%# brother(Child, Brother) :- father(Child, Father), father(Brother, Father), male(Brother).
sister(Child, Sister) :- mother(Child, Mother), mother(Sister, Mother), female(Sister), Sister \= Child.
%# sister(Child, Sister) :- father(Child, Father), father(Sister, Father), female(Sister).
aunt(Child, Aunt) :- mother(Child, Mother), sister(Mother, Aunt).
aunt(Child, Aunt) :- father(Child, Father), sister(Father, Aunt).
uncle(Child, Uncle) :- father(Child, Father), brother(Father, Uncle).
uncle(Child, Uncle) :- mother(Child, Mother), brother(Mother, Uncle).
grandfather(Child, Grandfather) :- father(Child, Father), father(Father, Grandfather).
grandfather(Child, Grandfather) :- mother(Child, Father), father(Father, Grandfather).
grandmother(Child, Grandmother) :- father(Child, Mother), mother(Mother, Grandmother).
grandmother(Child, Grandmother) :- mother(Child, Mother), mother(Mother, Grandmother).

anchestor(Child, Parent) :- father(Child, Parent) ; mother(Child, Parent).
anchestor(Child, Parent) :- father(Child, X), anchestor(X, Parent).
anchestor(Child, Parent) :- mother(Child, X), anchestor(X, Parent).

male_ancestor(Child, Parent) :- male(Parent), anchestor(Child, Parent).
female_ancestor(Child, Parent) :- female(Parent), anchestor(Child, Parent).

anchestor1(Child, Parent, N) :- father(Child, Parent), N = 1.
anchestor1(Child, Parent, N) :- mother(Child, Parent), N = 1.
anchestor1(Child, Parent, N) :- father(Child, X), anchestor1(X, Parent, M), N is M + 1.
anchestor1(Child, Parent, N) :- mother(Child, X), anchestor1(X, Parent, M), N is M + 1.

has_children(Parent, X) :- findall(Child, (father(Child, Parent) ; mother(Child, Parent)), List), length(List, X).

anchestor2(Child, Parent, X) :- anchestor(Child, Parent), has_children(Parent, Y), X < Y.
