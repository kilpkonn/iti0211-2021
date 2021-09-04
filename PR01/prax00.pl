kass(miisu).
kass(ants).
kass(peedu).
koer(muki).
koer(pontu).
koer(reks).
rott(ruudi).

lemmik(tiina,koer,pontu).
lemmik(tiina,kass,miisu).
lemmik(tiina,papagoi,kiki).
lemmik(tiina,rott,ruudi).
lemmik(piret,koer,muki).
lemmik(piret,kass,peedu).
lemmik(peeter,kass,ants).
lemmik(peeter,koer,reks).

maja(ants,punane).
mängib(jüri, korvpall).
omab(X, kana) :- maja(X, sinine).
omab(X, kanaarilind) :- maja(X, roheline).
trenn(X, jalka) :- omab(X, koer).

lendab(lind).
