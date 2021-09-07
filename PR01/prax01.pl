male(tavo).
male(evo).
male(tarmo).
male(ahto).
male(mati).
male(teet).
male(kurmo).
male(ruudo).
female(liis).
female(terje).
female(malle).
female(tiiu).

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

father(Child, Father) :- mother(Child, Mother), married(Mother, Father).
brother(Child, Brother) :- mother(Child, Mother), mother(Brother, Mother), male(Brother).
brother(Child, Brother) :- father(Child, Father), father(Brother, Father), male(Brother).
sister(Child, Sister) :- mother(Child, Mother), mother(Sister, Mother), female(Sister).
sister(Child, Sister) :- father(Child, Father), father(Sister, Father), female(Sister).
aunt(Child, Aunt) :- mother(Child, Mother), sister(Mother, Aunt).
aunt(Child, Aunt) :- father(Child, Father), sister(Father, Aunt).
uncle(Child, Uncle) :- father(Child, Father), brother(Father, Uncle).
uncle(Child, Uncle) :- mother(Child, Mother), brother(Mother, Uncle).
grandfather(Child, Grandfather) :- father(Child, Father), father(Father, Grandfather).
grandfather(Child, Grandfather) :- mother(Child, Father), father(Father, Grandfather).
grandmother(Child, Grandmother) :- father(Child, Mother), mother(Mother, Grandmother).
grandmother(Child, Grandmother) :- mother(Child, Mother), mother(Mother, Grandmother).

