%======================================================
% Transitive closure
%------------------------------------------------------
% TEST1: transitive_closure(pr).
% TEST2: transitive_closure(jarjestus).
%------------------------------------------------------
:- dynamic closure/3.

transitive_closure(Relation):-
    Clause =..[Relation,X,Y],
    Clause,
    assertz(closure(1,X,Y)),fail.
transitive_closure(Predicate):-
    assert(lipp(0)),
    repeat,
    retract(lipp(_)),
    assert(lipp(0)),
    transitive_closure1(Predicate),
    lipp(0).
transitive_closure(_):- 
    !, listing(closure).
    
transitive_closure1(_):-
	closure(N,A,B),
    	closure(1,B,C), 
    	not(closure(_,A,C)),     % kas juba olemas niisugune fakt?
    	N1 is N + 1,
    	assertz(closure(N1,A,C)), 
	retract(lipp(_)),
	assert(lipp(1)),!.
transitive_closure1(_).

% Katsehulk binaarseid predikaate
pr(s,f).
pr(d,f).
pr(f,g).
pr(r,s).

%=====================================================
% Transitive closure with metrics (minimal closure)
% TEST: 
t:-
     m_transitive_closure(pr).
%=====================================================
m_transitive_closure(Relation):-
    Clause =..[Relation,D,X,Y],
    Clause,
    assertz(closure(D,X,Y)),fail.
m_transitive_closure(_):-
    closure(D1,A,B),
    closure(D2,B,C), 
    D is D1 + D2,
    m_test(A,C,D),
    assertz(closure(D,A,C)), fail.
m_transitive_closure(_):-  !, listing(closure).
    
m_test(A,A,_):- !, fail.
m_test(A,C,_):-
    not(closure(_,A,C)),!.   % kas juba olemas niisugune fakt?
m_test(A,C,D):-
    closure(DD,A,C),        % kas leidub l�hem tee?
    D < DD,
    retract(closure(DD,A,C)).

pr(6.1,'Tartu',f).
pr(1,d,f).
pr(3,f,g).
pr(2,r,'Tartu').
pr(4,'Tartu',g).
pr(5,f,r).
%=====================================================
% Ekvivalentsi klassid
% genereerib faktid: eq_class(KLASSI NIMI, BAASHULGA NIMI(ELEMENDI NIMI, ATRIBUUT mille pohjal)).
%-----------------------------------------------------

a:-
    transitive_closure(jarjestus).
b:-
    equivalence_class(inimene,2,2,1).
b:-
    listing(eq_class),!.
c:- separate.
c:- listing(eq_class).

d:- abolish(closure(_,_,_)),
    abolish(eq_class(_,_)).
    
%---------------------- Ekv. kl. leidmine baashulgal -------------------  
% Hulk - baashulga nimi; Arity-elemendi atribuutide arv; 
% Nr-atribuudi jrk nr, mille j�rgi ekv.kl. moodustatakse
%-----------------------------------------------------------------------
equivalence_class(Hulk,ArityNV,Nr,Distants):-
    functor(TermV, Hulk, ArityNV),  % moodustab termi nimega Hulk aarsusega ArityNV
    TermV,
    arg(Nr,TermV,Val),              % leiab termi TermV Nr-nda parameetri v��rtuse
    assert(eq_class(Val,TermV)),
    functor(TermV1, Hulk, ArityNV), % moodustab termi nimega Hulk aarsusega ArityNV
    TermV1,
    arg(Nr,TermV1,Val1),            % leiab termi TermV1 Nr-nda argumendi v��rtuse
    distants(Val,Val1,D),           % v�rdleb, kas tegemist on ekvival. kl. kuuluva elem-ga
    D1 is abs(D),
    D1 =< Distants,
    assert(eq_class(Val,TermV1)),fail.
%----------------------------------------------------
% V��rtuste kauguse leidmine etteantud meetrikas
% TEST: distants(noor, rauk,V).
%-----------------------------------------------------
distants(Obj1, Obj2, Val):-
    closure(_,_,_),
    (closure(Val, Obj1, Obj2); (closure(Val1,Obj2,Obj1), Val is 0 -Val1);Val=999),!.
distants(Obj1,Obj2, Val):-
    transitive_closure(jarjestus),
    distants(Obj1,Obj2, Val),!.


%------------------------------------------------------
% Hulkade ja relatsioonide esitus
%------------------------------------------------------
%------------------------------------------------------
% Inimeste hulk
%----------------------------------------------------
inimene(peeter, noor).
inimene(ain, vana).
inimene(elsa, keskealine).
inimene(reet, laps).
inimene(juuli, rauk).
inimene(agnes, kyps).
inimene(tiina, keskealine).
inimene(juljus, rauk).

tyyp(vanus,[laps,noor,kyps,keskealine,vana,rauk]).  % 
tyyp(nimi,[peeter, ain, elsa, rein, reet, juuli,maie, agnes, tiina, juljus, aadolf]).
tyyp(inimene,nimi,vanus).               

:- discontiguous jarjestus/2.

jarjestus(laps, noor).
jarjestus(noor, kyps).
jarjestus(kyps, vana).
jarjestus(noor, keskealine).
jarjestus(keskealine, vana).
jarjestus(vana, rauk).

%===============================================================================
set_union(A,B,U):-
    append(A,B,U1),
    list_to_set(U1, U),!.

join([], A, A).
join([A|B], C, [A|D]) :-
        join(B, C, D).
%--------------------------------

set_complement(_,_):-
    assert(state_set([])),
    transition(Source,Destination,_),
    retract(state_set(SS)),
    assert(state_set([Source,Destination|SS])),
    fail.
set_complement(F,FC):-
    retract(state_set(SS)),
    remove_dups(SS,S),
    set_difference(S,F,FC).
    

%-------------------------------------------------------------------
% multihulgast hulga tegemine
% TEST: multiset_set([d,g,e,r,s,d,r,s,a],Set) 
% Vaata ka s�steemsete predikaati "remove_dups(List, NoDupsListV)"
%-------------------------------------------------------------------
multiset_set([],[]).
multiset_set([El|Mset],Set):-
    multiset_set(Mset,Set1),
    ((not(l_inclusion(El,Set1)),Set=[El|Set1]);Set=Set1).


%=====================================================
% Abipredikaadid
%-----------------------------------------------------
%abs(E,A):-      % absoluutv��rtuse leidmine
%    E < 0, A is E * -1,!.
%abs(E,E):- !.

%-----------------------------------------------------
%length([], 0).      % listi pikkus leidmine
%length([S|T], M):- length(T, N), M is N + 1.

%-----------------------------------------------------
arity(CL,ArityNV):- % Predikaadi aarsuse leidmine
    (TermV=..[CL,_],call(TermV),ArityNV=1);
    (TermV=..[CL,_,_],call(TermV),ArityNV=2);
    (TermV=..[CL,_,_,_],call(TermV),ArityNV=3); 
    (TermV=..[CL,_,_,_,_],call(TermV),ArityNV=4);
    (TermV=..[CL,_,_,_,_,_],call(TermV),ArityNV=5).
%-----------------------------------------------------

:- discontiguous separate/0.
separate:-
    eq_class(Class, inimene(Nimi, _)),
    eq_class(Classx, inimene(Nimi, Attrx)),
    Class \= Classx,
    retract(eq_class(Classx, inimene(Nimi, Attrx))),
    fail.
%--------------------------------------------------------
% Hulkade vahe. Analoogne s�steemipredikaat: 
% compare_lists(List1, List2, DiffListV) - DiffList is the 
% elements of List1 that are not in List2
%--------------------------------------------------------
set_difference(S,[],S).
set_difference(S,[El|F],FC):-
    remove(El,S,S1),
    set_difference(S1,F,FC).

%-------------------------------------------------------------------
% Elemendi sisalduvus listis. Analoogne s�steemipredikaat member(El, List)
% TEST: l_inclusion(d,[f,s,e,d,a]).
%-------------------------------------------------------------------
l_inclusion(_,[]):- fail.
l_inclusion(El,[El|_]).
l_inclusion(El,[_|List]):- !,
    l_inclusion(El,List).
%-------------------------------------------------------------------
%+++++++++++++++++++++++++++++++++++
% Elemendi eemaldamine listist
% Test: remove(ats,[reet,pets, ott, ats], Uus_list).
%-----------------------------------
%  remove(S, [S|T], L):- remove(S,T,L),!.
%  remove(S, [S|T], T).
%  remove(S, [U|T], [U|L]):- remove(S,T,L).
%---------------------------------------
% Hulkade �hisosa
% TEST: intersection([a,s,d,f,g,h,g],[s,f,h],H).
%----------------------------------------
intersection([],_,[]):- !.
intersection([El|L1],L2,L3):-
    intersection(L1,L2,L),
    ((is_member(El,L2),L3=[El|L]);L3=L),!.


% =================================================
trade(eur, usd).
trade(eur, btc).
trade(usd, nok).
trade(nok, eth).
trade(usd, jpy).

% transitive_closure(trade).
% listing(closure).


loom(koer, keskmine).
loom(kass, vaike).
loom(hobune, suur).
loom(tilluke, hiir).
loom(vaike, rott).
loom(rebane, keskmine).

jarjestus(tilluke, keskmine).
jarjestus(vaike, keskmine).
jarjestus(keskmine, suur).

% transitive_closure(jarjestus).
% Arity, GropyBy, Distance
% equivalence_class(loom, 2, 2, 1).
% listing(eq_class).

separate:-
    eq_class(Class, loom(Nimi, _)),
    eq_class(Classx, loom(Nimi, Attrx)),
    Class \= Classx,
    retract(eq_class(Classx, loom(Nimi, Attrx))),
    fail.


auto("123ABC", 2000, mersu, valge, jaan).
auto("111AAA", 2001, bmw, must, peeter).
auto("122ABC", 2010, volvo, hall, mart).
auto("123AAC", 2015, bmw, roheline, siim).
auto("333ABC", 2018, mersu, valge, helen).
auto("111ABC", 2020, bmw, sinine, liis).
auto("123AAA", 2021, volvo, punane, jan).
auto("123XYZ", 2005, bmw, must, johann).
auto("123RRR", 2016, bmw, valge, johanna).
auto("123ABB", 2020, vw, valge, pets).
auto("100ABC", 2004, mersu, most, oleg).

vanus(uus, 0, 3).
vanus(suht_uus, 4, 5).
vanus(kasutatud, 6, 8).
vanus(vana, 9, 15).
vanus(romu, 16, 20).
vanus(uunikum, 21, 999).


grupeeri_autod :- grupeeri(auto, 5, 2).

grupeeri(X, Arity, ArgNr) :-
  functor(Term, X, Arity),
  Term,
  arg(ArgNr, Term, Year),
  vanus(Name, Min, Max),
  Min =< 2021 - Year,
  Max >= 2021 - Year,
  assertz(grupp(Name, Term)),
  fail.

% listing(grupp).
