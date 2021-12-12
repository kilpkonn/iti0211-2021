%lihtlause --> nimisonafraas, tegusonafraas.
%nimisonafraas --> nimisona, omadussonafraas, nimisona.
%nimisonafraas --> nimisona,nimisonafraas ;[].
%nimisona -->[pakapiku];[habe];[tema];[sobimatuse];[jouluvanaks]. % terminalsümbolid esinevad reeglis paremal pool ühiklistidena
%omadussonafraas --> maarsona, omadussona.
%maarsona --> [liiga].
%omadussona --> [lyhike].
%tegusonafraas --> tegusona, nimisonafraas.
%tegusona --> [tingib];[pohjustab].

% phrase(lihtlause,[pakapiku,liiga,lyhike,habe,tingib,tema,sobimatuse,jouluvanaks]).
% phrase(lihtlause,[pakapiku,liiga,must,habe,tingib,tema,sobimatuse,jouluvanaks]).
% phrase(lihtlause,S). % genereerib lauseid.


% veerevale kivile sammal ei kasva (juursümbol: 'lihtlause') 
% uhkus ajab upakile (juursümbol: 'lihtlause')
% raha tuleb, raha laheb, volad jaavad (juursümbol: 'liitlause')

lihtlause --> tegijafraas, tegevusfraas.
tegevusfraas --> tegevus ; tegevus, tulemus.
tulemus --> [upakile]; [].
tegevus --> eitus, tegusona; tegusona.
eitus --> [ei]; [].
tegusona --> [kasva]; [ajab]; [tuleb]; [laheb]; [jaavad].

tegijafraas --> sihitisfraas, tegija; tegija.
tegija --> [sammal]; [uhkus]; [raha]; [volad].
sihitisfraas --> omadussona, sihitis. 
sihitis --> [kivile].  %# <- See vb pole sihitis aga mida iganes...
omadussona --> [veerevale] ; [].

liitlause --> lihtlause, liitlause_liitja, (lihtlause ; liitlause). 
liitlause_liitja --> [','].

% phrase(lihtlause, [veerevale, kivile, sammal, ei, kasva])
% phrase(lihtlause, [uhkus, ajab, upakile])
% phrase(liitlause, [raha, tuleb, ',', raha, laheb, ',', volad, jaavad]). % <- '' /= ""

