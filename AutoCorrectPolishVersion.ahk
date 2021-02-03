;------------------------------------------------------------------------------
; CHANGELOG:

; INTRODUCTION
; because of Polish characters it needs to be saved as UTF-8-BOM encoding

; SOURCES
; 

; CONTENTS
; 
;------------------------------------------------------------------------------
; To Do

;------------------------------------------------------------------------------
; Settings
;------------------------------------------------------------------------------
#NoEnv ; For security
#SingleInstance force

;------------------------------------------------------------------------------
; AUto-COrrect TWo COnsecutive CApitals.
; Disabled by default to prevent unwanted corrections such as IfEqual->Ifequal.
; To enable it, remove the /*..*/ symbols around it.
; From Laszlo's script at http://www.autohotkey.com/forum/topic9689.html
;------------------------------------------------------------------------------
/*
; The first line of code below is the set of letters, digits, and/or symbols
; that are eligible for this type of correction.  Customize if you wish:
keys = abcdefghijklmnopqrstuvwxyz
Loop Parse, keys
    HotKey ~+%A_LoopField%, Hoty
Hoty:
    CapCount := SubStr(A_PriorHotKey,2,1)="+" && A_TimeSincePriorHotkey<999 ? CapCount+1 : 1
    if CapCount = 2
        SendInput % "{BS}" . SubStr(A_ThisHotKey,3,1)
    else if CapCount = 3
        SendInput % "{Left}{BS}+" . SubStr(A_PriorHotKey,3,1) . "{Right}"
Return
*/

SetCapsLockState, AlwaysOff ;just as it says

;------------------------------------------------------------------------------
; Ctrl+; to insert current date
;------------------------------------------------------------------------------
^;::
FormatTime, CurrentDateTime,, dd/MMM/yy
SendInput %CurrentDateTime%
return
;------------------------------------------------------------------------------
; Ctrl+Shift+; to insert current time (24h mode, use lowercase hh for 12
;     hour mode)
;------------------------------------------------------------------------------
^+;::
FormatTime, CurrentTime,, HH:mm
SendInput %CurrentTime%
return


;------------------------------------------------------------------------------
; Win+A to enter misspelling correction.  It will be added to this script.
;------------------------------------------------------------------------------
#a::
; Get the selected text. The clipboard is used instead of "ControlGet Selected"
; as it works in more editors and word processors, java apps, etc. Save the
; current clipboard contents to be restored later.
AutoTrim Off  ; Retain any leading and trailing whitespace on the clipboard.
ClipboardOld = %ClipboardAll%
Clipboard =  ; Must start off blank for detection to work.
Send ^c
ClipWait 1
if ErrorLevel  ; ClipWait timed out.
    return
; Replace CRLF and/or LF with `n for use in a "send-raw" hotstring:
; The same is done for any other characters that might otherwise
; be a problem in raw mode:
StringReplace, Hotstring, Clipboard, ``, ````, All  ; Do this replacement first to avoid interfering with the others below.
StringReplace, Hotstring, Hotstring, `r`n, ``r, All  ; Using `r works better than `n in MS Word, etc.
StringReplace, Hotstring, Hotstring, `n, ``r, All
StringReplace, Hotstring, Hotstring, %A_Tab%, ``t, All
StringReplace, Hotstring, Hotstring, `;, ```;, All
Clipboard = %ClipboardOld%  ; Restore previous contents of clipboard.
; This will move the InputBox's caret to a more friendly position:
SetTimer, MoveCaret, 10
; Show the InputBox, providing the default hotstring:
InputBox, Hotstring, New Hotstring, Provide the corrected word on the right side. You can also edit the left side if you wish.`n`nExample entry:`n::teh::the,,,,,,,, ::%Hotstring%::%Hotstring%

if ErrorLevel <> 0  ; The user pressed Cancel.
    return
; Otherwise, add the hotstring and reload the script:
FileAppend, `n%Hotstring%, %A_ScriptFullPath%  ; Put a `n at the beginning in case file lacks a blank line at its end.
Reload
Sleep 200 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
MsgBox, 4,, The hotstring just added appears to be improperly formatted.  Would you like to open the script for editing? Note that the bad hotstring is at the bottom of the script.
IfMsgBox, Yes, Edit
return

MoveCaret:
IfWinNotActive, New Hotstring
    return
; Otherwise, move the InputBox's insertion point to where the user will type the abbreviation.
Send {HOME}
Loop % StrLen(Hotstring) + 4
    SendInput {Right}
SetTimer, MoveCaret, Off
return

#Hotstring R  ; Set the default to be "raw mode" (might not actually be relied upon by anything yet).

:*?R0:,::,{Space} ;Send the replacement text raw; that is, without translating {Enter} to Enter, ^c to Control+C, etc. This option is put into effect automatically for hotstrings that have a continuation section. Use R0 to turn this option back off.
;:*?R0:.::.{Space}
:*?R0:;::;{Space}

; Accented English words, from, amongst others,
; http://en.wikipedia.org/wiki/List_of_English_words_with_diacritics
; I have included all the ones compatible with reasonable codepages, and placed
; those that may often not be accented either from a clash with an unaccented 
; word (resume), or because the unaccented version is now common (cafe).
::aesop::Æsop
::a bas::à bas
::a la::à la
::ancien regime::Ancien Régime
::angstrom::Ångström
::angstroms::Ångströms
::anime::animé
::animes::animés
::ao dai::ào dái
::apertif::apértif
::apertifs::apértifs
::applique::appliqué
::appliques::appliqués
::apres::après
::arete::arête
::attache::attaché
::attaches::attachés
::auto-da-fe::auto-da-fé
::belle epoque::belle époque
::bete noire::bête noire
::betise::bêtise
::Bjorn::Bjørn
::blase::blasé
::boite::boîte
::boutonniere::boutonnière
::canape::canapé
::canapes::canapés
::celebre::célèbre
::celebres::célèbres
::chaines::chaînés
::cinema verite::cinéma vérité
::cinemas verite::cinémas vérité
::cinema verites::cinéma vérités
::champs-elysees::Champs-Élysées
::charge d'affaires::chargé d'affaires
::chateau::château
::chateaux::châteaux
::chateaus::châteaus
::cliche::cliché
::cliched::clichéd
::cliches::clichés
::cloisonne::cloisonné
::consomme::consommé
::consommes::consommés
::communique::communiqué
::communiques::communiqués
::confrere::confrère
::confreres::confrères
::cortege::cortège
::corteges::cortèges
::coup d'etat::coup d'état
::coup d'etats::coup d'états
::coup de tat::coup d'état
::coup de tats::coup d'états
::coup de grace::coup de grâce
::creche::crèche
::creches::crèches
::coulee::coulée
::coulees::coulées
::creme brulee::crème brûlée
::creme brulees::crème brûlées
::creme caramel::crème caramel
::creme caramels::crème caramels
::creme de cacao::crème de cacao
::creme de menthe::crème de menthe
::crepe::crêpe
::crepes::crêpes
::creusa::Creüsa
::crouton::croûton
::croutons::croûtons
::crudites::crudités
::curacao::curaçao
::dais::daïs
::daises::daïses
::debacle::débâcle
::debacles::débâcles
::debutante::débutante
::debutants::débutants
::declasse::déclassé
::decolletage::décolletage
::decollete::décolleté
::decor::décor
::decors::décors
::decoupage::découpage
::degage::dégagé
::deja vu::déjà vu
::demode::démodé
::denoument::dénoument
::derailleur::dérailleur
::derriere::derrière
::deshabille::déshabillé
::detente::détente
::diamante::diamanté
::discotheque::discothèque
::discotheques::discothèques
::divorcee::divorcée
::divorcees::divorcées
::doppelganger::doppelgänger
::doppelgangers::doppelgängers
::eclair::éclair
::eclairs::éclairs
::eclat::éclat
::el nino::El Niño
::elan::élan
::emigre::émigré
::emigres::émigrés
::entree::entrée
::entrees::entrées
::entrepot::entrepôt
::entrecote::entrecôte
::epee::épée
::epees::épées
::etouffee::étouffée
::facade::façade
::facades::façades
::fete::fête
::fetes::fêtes
::faience::faïence
::fiance::fiancé
::fiances::fiancés
::fiancee::fiancée
::fiancees::fiancées
::filmjolk::filmjölk
::fin de siecle::fin de siècle
::flambe::flambé
::flambes::flambés
::fleche::flèche
::Fohn wind::Föhn wind
::folie a deux::folie à deux
::folies a deux::folies à deux
::fouette::fouetté
::frappe::frappé
::frappes::frappés
:?*:fraulein::fräulein
:?*:fuhrer::Führer
::garcon::garçon
::garcons::garçons
::gateau::gâteau
::gateaus::gâteaus
::gateaux::gâteaux
::gemutlichkeit::gemütlichkeit
::glace::glacé
::glogg::glögg
::gewurztraminer::Gewürztraminer
::gotterdammerung::Götterdämmerung
::grafenberg spot::Gräfenberg spot
::habitue::habitué
::ingenue::ingénue
::jager::jäger
::jalapeno::jalapeño
::jalapenos::jalapeños
::jardiniere::jardinière
::krouzek::kroužek
::kummel::kümmel
::kaldolmar::kåldolmar
::landler::ländler
::langue d'oil::langue d'oïl
::la nina::La Niña
::litterateur::littérateur
::lycee::lycée
::macedoine::macédoine
::macrame::macramé
::maitre d'hotel::maître d'hôtel
::malaguena::malagueña
::manana::mañana
::manege::manège
::manque::manqué
::materiel::matériel
::matinee::matinée
::matinees::matinées
::melange::mélange
::melee::mêlée
::melees::mêlées
::menage a trois::ménage à trois
::menages a trois::ménages à trois
::mesalliance::mésalliance
::metier::métier
::minaudiere::minaudière
::mobius strip::Möbius strip
::mobius strips::Möbius strips
::moire::moiré
::moireing::moiréing
::moires::moirés
::motley crue::Mötley Crüe
::motorhead::Motörhead
::naif::naïf
::naifs::naïfs
::naive::naïve
::naiver::naïver
::naives::naïves
::naivete::naïveté
::nee::née
::negligee::negligée
::negligees::negligées
::neufchatel cheese::Neufchâtel cheese
::nez perce::Nez Percé
::noël::Noël
::noëls::Noëls
::número uno::número uno
::objet trouve::objet trouvé
::objets trouve::objets trouvé
::ombre::ombré
::ombres::ombrés
::omerta::omertà
::opera bouffe::opéra bouffe
::operas bouffe::opéras bouffe
::opera comique::opéra comique
::operas comique::opéras comique
::outre::outré
::papier-mache::papier-mâché
::passe::passé
::piece de resistance::pièce de résistance
::pied-a-terre::pied-à-terre
::plisse::plissé
::pina colada::Piña Colada
::pina coladas::Piña Coladas
::pinata::piñata
::pinatas::piñatas
::pinon::piñon
::pinons::piñons
::pirana::piraña
::pique::piqué
::piqued::piquéd
::più::più
::plie::plié
::precis::précis
::polsa::pölsa
::pret-a-porter::prêt-à-porter
::protoge::protégé
::protege::protégé
::proteged::protégéd
::proteges::protégés
::protegee::protégée
::protegees::protégées
::protegeed::protégéed
::puree::purée
::pureed::puréed
::purees::purées
::Quebecois::Québécois
::raison d'etre::raison d'être
::recherche::recherché
::reclame::réclame
::résume::résumé
::resumé::résumé
::résumes::résumés
::resumés::résumés
::retrousse::retroussé
::risque::risqué
::riviere::rivière
::roman a clef::roman à clef
::roue::roué
::saute::sauté
::sauted::sautéd
::seance::séance
::seances::séances
::senor::señor
::senors::señors
::senora::señora
::senoras::señoras
::senorita::señorita
::senoritas::señoritas
::sinn fein::Sinn Féin
::smorgasbord::smörgåsbord
::smorgasbords::smörgåsbords
::smorgastarta::smörgåstårta
::soigne::soigné
::soiree::soirée
::soireed::soiréed
::soirees::soirées
::souffle::soufflé
::souffles::soufflés
::soupcon::soupçon
::soupcons::soupçons
::surstromming::surströmming
::tete-a-tete::tête-à-tête
::tete-a-tetes::tête-à-têtes
::touche::touché
::tourtiere::tourtière
::ubermensch::Übermensch
::ubermensches::Übermensches
::ventre a terre::ventre à terre
::vicuna::vicuña
::vin rose::vin rosé
::vins rose::vins rosé
::vis a vis::vis à vis
::vis-a-vis::vis-à-vis
::voila::voilà 
; Common Misspellings - the main list
::htp:::http:
::http:\\::http://
::httpL::http:
::herf::href

#space::Suspend  ; Assign the toggle-suspend function to WIN+SPACE combination, useful in other scripts.

::nrsvp::Żadna odpowiedź ani potwierdzenie nie są konieczne (aby zaoszczędzić czas spędzony na pisaniu / czytaniu / odbieraniu powiadomień).
CapsLock::Send {BackSpace}
::phds::PhDs
::phd::PhD

; Male names. Auto generated in Excel. Source: https://www.babble.com/pregnancy/1000-most-popular-boy-names/ 15/Nov/19. Added by Conrad
::liam::Liam
::noah::Noah
::william::William
::james::James
::logan::Logan
::benjamin::Benjamin
::mason::Mason
::elijah::Elijah
::oliver::Oliver
::jacob::Jacob
::lucas::Lucas
::michael::Michael
::alexander::Alexander
::ethan::Ethan
::daniel::Daniel
::matthew::Matthew
::aiden::Aiden
::henry::Henry
::joseph::Joseph
::jackson::Jackson
::samuel::Samuel
::sebastian::Sebastian
::david::David
::carter::Carter
::wyatt::Wyatt
::jayden::Jayden
::john::John
::owen::Owen
::dylan::Dylan
::luke::Luke
::gabriel::Gabriel
::anthony::Anthony
::isaac::Isaac
::grayson::Grayson
::jack::Jack
::julian::Julian
::levi::Levi
::christopher::Christopher
::joshua::Joshua
::andrew::Andrew
::lincoln::Lincoln
::mateo::Mateo
::ryan::Ryan
::jaxon::Jaxon
::nathan::Nathan
::aaron::Aaron
::isaiah::Isaiah
::thomas::Thomas
::charles::Charles
::caleb::Caleb
::josiah::Josiah
::christian::Christian
::hunter::Hunter
::eli::Eli
::jonathan::Jonathan
::connor::Connor
::landon::Landon
::adrian::Adrian
::asher::Asher
::cameron::Cameron
::leo::Leo
::theodore::Theodore
::jeremiah::Jeremiah
::hudson::Hudson
::robert::Robert
::easton::Easton
::nolan::Nolan
::nicholas::Nicholas
::ezra::Ezra
::colton::Colton
;::angel::Angel
::brayden::Brayden
::jordan::Jordan
::dominic::Dominic
::austin::Austin
::ian::Ian
::adam::Adam
::elias::Elias
::jaxson::Jaxson
::greyson::Greyson
::jose::Jose
::ezekiel::Ezekiel
::carson::Carson
::evan::Evan
::maverick::Maverick
::bryson::Bryson
::jace::Jace
::cooper::Cooper
::xavier::Xavier
::parker::Parker
::roman::Roman
::jason::Jason
::santiago::Santiago
::chase::Chase
::sawyer::Sawyer
::gavin::Gavin
::leonardo::Leonardo
::kayden::Kayden
::ayden::Ayden
::jameson::Jameson
::kevin::Kevin
::bentley::Bentley
::zachary::Zachary
::everett::Everett
::axel::Axel
::tyler::Tyler
::micah::Micah
::vincent::Vincent
::weston::Weston
;::miles::Miles
::wesley::Wesley
::nathaniel::Nathaniel
::harrison::Harrison
::brandon::Brandon
::cole::Cole
::declan::Declan
::luis::Luis
::braxton::Braxton
::damian::Damian
::silas::Silas
::tristan::Tristan
::ryder::Ryder
::bennett::Bennett
::george::George
::emmett::Emmett
::justin::Justin
::kai::Kai
;::max::Max
::diego::Diego
::luca::Luca
::ryker::Ryker
::carlos::Carlos
::maxwell::Maxwell
::kingston::Kingston
::ivan::Ivan
::maddox::Maddox
::juan::Juan
::ashton::Ashton
::jayce::Jayce
::rowan::Rowan
::kaiden::Kaiden
::giovanni::Giovanni
::eric::Eric
::jesus::Jesus
::calvin::Calvin
::abel::Abel
;::king::King
::camden::Camden
::amir::Amir
::blake::Blake
::alex::Alex
::brody::Brody
::malachi::Malachi
::emmanuel::Emmanuel
::jonah::Jonah
::beau::Beau
::jude::Jude
::antonio::Antonio
::alan::Alan
::elliott::Elliott
::elliot::Elliot
::waylon::Waylon
::xander::Xander
::timothy::Timothy
::victor::Victor
::bryce::Bryce
::finn::Finn
::brantley::Brantley
::edward::Edward
::abraham::Abraham
::patrick::Patrick
;::grant::Grant
::karter::Karter
::hayden::Hayden
::richard::Richard
::miguel::Miguel
::joel::Joel
::gael::Gael
::tucker::Tucker
::rhett::Rhett
::avery::Avery
::steven::Steven
::graham::Graham
::kaleb::Kaleb
::jasper::Jasper
::jesse::Jesse
::matteo::Matteo
::dean::Dean
::zayden::Zayden
::preston::Preston
::oscar::Oscar
::jeremy::Jeremy
::alejandro::Alejandro
::marcus::Marcus
::dawson::Dawson
::lorenzo::Lorenzo
::messiah::Messiah
::zion::Zion
::maximus::Maximus
;::river::RiverRiver 
::zane::Zane
;::mark::Mark
::brooks::Brooks
::nicolas::Nicolas
::paxton::Paxton
::judah::Judah
::emiliano::Emiliano
::kaden::Kaden
::bryan::Bryan
::kyle::Kyle
::myles::Myles
::peter::Peter
::charlie::Charlie
::kyrie::Kyrie
::thiago::Thiago
;::brian::Brian
::kenneth::Kenneth
::andres::Andres
::lukas::Lukas
::aidan::Aidan
::jax::Jax
::caden::Caden
::milo::Milo
::paul::Paul
::beckett::Beckett
::brady::Brady
::colin::Colin
::omar::Omar
::bradley::Bradley
::javier::Javier
::knox::Knox
::jaden::Jaden
::barrett::Barrett
::israel::Israel
::matias::Matias
::jorge::Jorge
::zander::Zander
::derek::Derek
::josue::Josue
::cayden::Cayden
::holden::Holden
::griffin::Griffin
::arthur::Arthur
::leon::Leon
::felix::Felix
::remington::Remington
::jake::Jake
::killian::Killian
::clayton::Clayton
::sean::Sean
::adriel::Adriel
::riley::Riley
;::archer::Archer
;::legend::Legend
::erick::Erick
::enzo::Enzo
::corbin::Corbin
::francisco::Francisco
::dallas::Dallas
::emilio::Emilio
;::gunner::Gunner
::simon::Simon
::andre::Andre
::walter::Walter
::damien::Damien
;::chance::Chance
::phoenix::Phoenix
::colt::Colt
::tanner::Tanner
::stephen::Stephen
::kameron::Kameron
::tobias::Tobias
::manuel::Manuel
::amari::Amari
::emerson::Emerson
::louis::Louis
::cody::Cody
::finley::Finley
::iker::Iker
::martin::Martin
::rafael::Rafael
::nash::Nash
::beckham::Beckham
;::cash::Cash
::karson::Karson
::rylan::Rylan
::reid::Reid
::theo::Theo
::ace::Ace
::eduardo::Eduardo
::spencer::Spencer
::raymond::Raymond
::maximiliano::Maximiliano
::anderson::Anderson
::ronan::Ronan
::lane::Lane
::cristian::Cristian
::titus::Titus
::travis::Travis
::jett::Jett
::ricardo::Ricardo
::bodhi::Bodhi
::gideon::Gideon
::jaiden::Jaiden
::fernando::Fernando
::mario::Mario
::conor::Conor
::keegan::Keegan
::ali::Ali
::cesar::Cesar
::ellis::Ellis
::jayceon::Jayceon
::walker::Walker
::cohen::Cohen
::arlo::Arlo
::hector::Hector
::dante::Dante
::kyler::Kyler
::garrett::Garrett
::donovan::Donovan
::seth::Seth
::jeffrey::Jeffrey
::tyson::Tyson
::jase::Jase
::desmond::Desmond
::caiden::Caiden
::gage::Gage
::atlas::Atlas
;::major::Major
::devin::Devin
::edwin::Edwin
::angelo::Angelo
::orion::Orion
::conner::Conner
::julius::Julius
::marco::Marco
::jensen::Jensen
::daxton::Daxton
::peyton::Peyton
::zayn::Zayn
::collin::Collin
::jaylen::Jaylen
::dakota::Dakota
::prince::Prince
::johnny::Johnny
::kayson::Kayson
::cruz::Cruz
::hendrix::Hendrix
::atticus::Atticus
::troy::Troy
::kane::Kane
::edgar::Edgar
::sergio::Sergio
::kash::Kash
::marshall::Marshall
::johnathan::Johnathan
::romeo::Romeo
::shane::Shane
::warren::Warren
::joaquin::Joaquin
::wade::Wade
::leonel::Leonel
::trevor::Trevor
::dominick::Dominick
::muhammad::Muhammad
::erik::Erik
::odin::Odin
::quinn::Quinn
::jaxton::Jaxton
::dalton::Dalton
::nehemiah::Nehemiah
::frank::Frank
::grady::Grady
::gregory::Gregory
::andy::Andy
::solomon::Solomon
::malik::Malik
::rory::Rory
::clark::Clark
::reed::Reed
::harvey::Harvey
::zayne::Zayne
::jay::Jay
::jared::Jared
::noel::Noel
::shawn::Shawn
::fabian::Fabian
::ibrahim::Ibrahim
::adonis::Adonis
::ismael::Ismael
::pedro::Pedro
::leland::Leland
::malakai::Malakai
::malcolm::Malcolm
::alexis::Alexis
::kason::Kason
::porter::Porter
::sullivan::Sullivan
::raiden::Raiden
::allen::Allen
::ari::Ari
::russell::Russell
::princeton::Princeton
::winston::Winston
::kendrick::Kendrick
::roberto::Roberto
::lennox::Lennox
::hayes::Hayes
::finnegan::Finnegan
::nasir::Nasir
::kade::Kade
::nico::Nico
::emanuel::Emanuel
::landen::Landen
::moises::Moises
::ruben::Ruben
::hugo::Hugo
::abram::Abram
::adan::Adan
::khalil::Khalil
::zaiden::Zaiden
::augustus::Augustus
::marcos::Marcos
::philip::Philip
::phillip::Phillip
::cyrus::Cyrus
::esteban::Esteban
::braylen::Braylen
::albert::Albert
::bruce::Bruce
::kamden::Kamden
::lawson::Lawson
::jamison::Jamison
::sterling::Sterling
::damon::Damon
::gunnar::Gunnar
::kyson::Kyson
::luka::Luka
::franklin::Franklin
::ezequiel::Ezequiel
::pablo::Pablo
::derrick::Derrick
::zachariah::Zachariah
::cade::Cade
::jonas::Jonas
::dexter::Dexter
::kolton::Kolton
::remy::Remy
::hank::Hank
::tate::Tate
::trenton::Trenton
::kian::Kian
::drew::Drew
::mohamed::Mohamed
::dax::Dax
::rocco::Rocco
::bowen::Bowen
::mathias::Mathias
::ronald::Ronald
::francis::Francis
::matthias::Matthias
::milan::Milan
::maximilian::Maximilian
::royce::Royce
::skyler::Skyler
::corey::Corey
::kasen::Kasen
::drake::Drake
::gerardo::Gerardo
::jayson::Jayson
::sage::Sage
::braylon::Braylon
::benson::Benson
::moses::Moses
::alijah::Alijah
::rhys::Rhys
::otto::Otto
::oakley::Oakley
::armando::Armando
::jaime::Jaime
::nixon::Nixon
::saul::Saul
::scott::Scott
::brycen::Brycen
::ariel::Ariel
::enrique::Enrique
::donald::Donald
::chandler::Chandler
::asa::Asa
::eden::Eden
::davis::Davis
::keith::Keith
::frederick::Frederick
::rowen::Rowen
::lawrence::Lawrence
::leonidas::Leonidas
::aden::Aden
::julio::Julio
::darius::Darius
::johan::Johan
::deacon::Deacon
::cason::Cason
::danny::Danny
::nikolai::Nikolai
::taylor::Taylor
::alec::Alec
::royal::Royal
::armani::Armani
::kieran::Kieran
::luciano::Luciano
::omari::Omari
::rodrigo::Rodrigo
::arjun::Arjun
::ahmed::Ahmed
::brendan::Brendan
::cullen::Cullen
::raul::Raul
::raphael::Raphael
::ronin::Ronin
::brock::Brock
::pierce::Pierce
::alonzo::Alonzo
::casey::Casey
::dillon::Dillon
::uriel::Uriel
::dustin::Dustin
::gianni::Gianni
::roland::Roland
::landyn::Landyn
::kobe::Kobe
::dorian::Dorian
::emmitt::Emmitt
::ryland::Ryland
::apollo::Apollo
::aarav::Aarav
::roy::Roy
::duke::Duke
::quentin::Quentin
::sam::Sam
::lewis::Lewis
::tony::Tony
::uriah::Uriah
::dennis::Dennis
::moshe::Moshe
::isaias::Isaias
::braden::Braden
::quinton::Quinton
::cannon::Cannon
::ayaan::Ayaan
::mathew::Mathew
::kellan::Kellan
::niko::Niko
::edison::Edison
::izaiah::Izaiah
::jerry::Jerry
::gustavo::Gustavo
::jamari::Jamari
::marvin::Marvin
::mauricio::Mauricio
::ahmad::Ahmad
::mohammad::Mohammad
::justice::Justice
::trey::Trey
::elian::Elian
::mohammed::Mohammed
::sincere::Sincere
::yusuf::Yusuf
::arturo::Arturo
::callen::Callen
::rayan::Rayan
::keaton::Keaton
::wilder::Wilder
::mekhi::Mekhi
::memphis::Memphis
::cayson::Cayson
::conrad ::Conrad ;with extra space, so that it doesn't get replaced in email addresses
::kaison::Kaison
::kyree::Kyree
::soren::Soren
::colby::Colby
::bryant::Bryant
::lucian::Lucian
::alfredo::Alfredo
::cassius::Cassius
::marcelo::Marcelo
::nikolas::Nikolas
::brennan::Brennan
::darren::Darren
::jasiah::Jasiah
::jimmy::Jimmy
::lionel::Lionel
::reece::Reece
;::ty::Ty
::chris::Chris
::forrest::Forrest
::korbin::Korbin
::tatum::Tatum
::jalen::Jalen
::santino::Santino
::leonard::Leonard
::alvin::Alvin
::issac::Issac
::quincy::Quincy
::mack::Mack
::samson::Samson
::rex::Rex
::alberto::Alberto
::callum::Callum
::curtis::Curtis
::hezekiah::Hezekiah
::finnley::Finnley
::briggs::Briggs
::kamari::Kamari
::zeke::Zeke
::raylan::Raylan
::neil::Neil
::titan::Titan
::julien::Julien
::kellen::Kellen
::devon::Devon
::kylan::Kylan
::roger::Roger
::axton::Axton
::carl::Carl
::douglas::Douglas
::larry::Larry
::crosby::Crosby
::fletcher::Fletcher
::makai::Makai
::nelson::Nelson
::hamza::Hamza
::lance::Lance
::alden::Alden
::gary::Gary
::wilson::Wilson
::alessandro::Alessandro
::ares::Ares
::kashton::Kashton
::bruno::Bruno
::jakob::Jakob
::stetson::Stetson
::zain::Zain
::cairo::Cairo
::nathanael::Nathanael
::byron::Byron
::harry::Harry
::harley::Harley
::mitchell::Mitchell
::maurice::Maurice
::orlando::Orlando
::kingsley::Kingsley
::kaysen::Kaysen
::sylas::Sylas
::trent::Trent
::ramon::Ramon
::boston::Boston
::lucca::Lucca
::noe::Noe
::jagger::Jagger
::reyansh::Reyansh
::vihaan::Vihaan
::randy::Randy
::thaddeus::Thaddeus
::lennon::Lennon
::kannon::Kannon
::kohen::Kohen
::tristen::Tristen
::valentino::Valentino
::maxton::Maxton
::salvador::Salvador
::abdiel::Abdiel
::langston::Langston
::rohan::Rohan
::kristopher::Kristopher
::yosef::Yosef
::rayden::Rayden
::lee::Lee
::callan::Callan
::tripp::Tripp
::deandre::Deandre
::joe::Joe
::morgan::Morgan
::dariel::Dariel
::colten::Colten
::reese::Reese
::jedidiah::Jedidiah
::ricky::Ricky
::bronson::Bronson
::terry::Terry
::eddie::Eddie
::jefferson::Jefferson
::lachlan::Lachlan
::layne::Layne
::clay::Clay
::madden::Madden
::jamir::Jamir
::tomas::Tomas
::kareem::Kareem
::stanley::Stanley
::brayan::Brayan
::amos::Amos
::kase::Kase
::kristian::Kristian
::clyde::Clyde
::ernesto::Ernesto
::tommy::Tommy
::casen::Casen
::ford::Ford
::crew::Crew
::braydon::Braydon
::brecken::Brecken
::hassan::Hassan
::axl::Axl
::boone::Boone
::leandro::Leandro
::samir::Samir
::jaziel::Jaziel
::magnus::Magnus
::abdullah::Abdullah
::yousef::Yousef
::branson::Branson
::jadiel::Jadiel
::jaxen::Jaxen
::layton::Layton
::franco::Franco
::ben::Ben
::kelvin::Kelvin
::chaim::Chaim
::demetrius::Demetrius
::blaine::Blaine
::ridge::Ridge
::colson::Colson
::melvin::Melvin
::anakin::Anakin
::aryan::Aryan
::lochlan::Lochlan
::jon::Jon
::canaan::Canaan
::zechariah::Zechariah
::alonso::Alonso
::otis::Otis
::zaire::Zaire
::marcel::Marcel
::brett::Brett
::stefan::Stefan
::aldo::Aldo
::jeffery::Jeffery
::baylor::Baylor
::talon::Talon
::dominik::Dominik
::flynn::Flynn
::carmelo::Carmelo
::dane::Dane
::jamal::Jamal
::kole::Kole
::enoch::Enoch
::graysen::Graysen
::kye::Kye
::vicente::Vicente
::fisher::Fisher
::ray::Ray
::fox::Fox
::jamie::Jamie
::rey::Rey
::zaid::Zaid
::allan::Allan
::emery::Emery
::gannon::Gannon
::joziah::Joziah
::rodney::Rodney
::juelz::Juelz
::sonny::Sonny
::terrance::Terrance
::zyaire::Zyaire
::augustine::Augustine
::cory::Cory
::felipe::Felipe
::aron::Aron
::jacoby::Jacoby
::harlan::Harlan
::marc::Marc
::bobby::Bobby
::joey::Joey
::anson::Anson
::huxley::Huxley
::marlon::Marlon
::anders::Anders
::guillermo::Guillermo
::payton::Payton
::castiel::Castiel
::damari::Damari
::shepherd::Shepherd
::azariah::Azariah
::harold::Harold
::harper::Harper
::henrik::Henrik
::houston::Houston
::kairo::Kairo
::willie::Willie
::elisha::Elisha
::ameer::Ameer
::emory::Emory
::skylar::Skylar
::sutton::Sutton
::alfonso::Alfonso
::brentley::Brentley
::toby::Toby
::blaze::Blaze
::eugene::Eugene
::shiloh::Shiloh
::wayne::Wayne
::darian::Darian
::gordon::Gordon
::london::London
::bodie::Bodie
::jordy::Jordy
::jermaine::Jermaine
::denver::Denver
::gerald::Gerald
::merrick::Merrick
::musa::Musa
::vincenzo::Vincenzo
::kody::Kody
::yahir::Yahir
::brodie::Brodie
; ::trace::Trace
::darwin::Darwin
::tadeo::Tadeo
::bentlee::Bentlee
::billy::Billy
::hugh::Hugh
::reginald::Reginald
::vance::Vance
::westin::Westin
::cain::Cain
::arian::Arian
::dayton::Dayton
::javion::Javion
::terrence::Terrence
::brysen::Brysen
::jaxxon::Jaxxon
::thatcher::Thatcher
::landry::Landry
::rene::Rene
::westley::Westley
::miller::Miller
::alvaro::Alvaro
::cristiano::Cristiano
::eliseo::Eliseo
::ephraim::Ephraim
::adrien::Adrien
::jerome::Jerome
::khalid::Khalid
::aydin::Aydin
::mayson::Mayson
::alfred::Alfred
::duncan::Duncan
;::junior::Junior
::kendall::Kendall
::zavier::Zavier
::koda::Koda
::maison::Maison
::caspian::Caspian
::maxim::Maxim
::kace::Kace
::zackary::Zackary
::rudy::Rudy
::coleman::Coleman
::keagan::Keagan
::kolten::Kolten
::maximo::Maximo
::dario::Dario
::davion::Davion
::kalel::Kalel
::briar::Briar
::jairo::Jairo
::misael::Misael
::rogelio::Rogelio
::terrell::Terrell
::heath::Heath
::micheal::Micheal
::wesson::Wesson
::aaden::Aaden
::brixton::Brixton
::draven::Draven
::xzavier::Xzavier
::darrell::Darrell
::keanu::Keanu
::ronnie::Ronnie
::konnor::Konnor
;::will::Will
::dangelo::Dangelo
::frankie::Frankie
::kamryn::Kamryn
::salvatore::Salvatore
::santana::Santana
::shaun::Shaun
::coen::Coen
::leighton::Leighton
::mustafa::Mustafa
::reuben::Reuben
::ayan::Ayan
::blaise::Blaise
::dimitri::Dimitri
::keenan::Keenan
::van::Van
::achilles::Achilles
::channing::Channing
::ishaan::Ishaan
::wells::Wells
::benton::Benton
::lamar::Lamar
::nova::Nova
::yahya::Yahya
::dilan::Dilan
::gibson::Gibson
::camdyn::Camdyn
::ulises::Ulises
::alexzander::Alexzander
::valentin::Valentin
::shepard::Shepard
::alistair::Alistair
::eason::Eason
::kaiser::Kaiser
::leroy::Leroy
::zayd::Zayd
::camilo::Camilo
::markus::Markus
::foster::Foster
::davian::Davian
::dwayne::Dwayne
::jabari::Jabari
::judson::Judson
::koa::Koa
::yehuda::Yehuda
::lyric::Lyric
::tristian::Tristian
::agustin::Agustin
::bridger::Bridger
::vivaan::Vivaan
::brayson::Brayson
::emmet::Emmet
::marley::Marley
::mike::Mike
::nickolas::Nickolas
::kenny::Kenny
::leif::Leif
::bjorn::Bjorn
::ignacio::Ignacio
::rocky::Rocky
::chad::Chad
::gatlin::Gatlin
::greysen::Greysen
::kyng::Kyng
::randall::Randall
::reign::Reign
::vaughn::Vaughn
::jessie::Jessie
::louie::Louie
::shmuel::Shmuel
::zahir::Zahir
::ernest::Ernest
::javon::Javon
::khari::Khari
::reagan::Reagan
::avi::Avi
::ira::Ira
::ledger::Ledger
::simeon::Simeon
::yadiel::Yadiel
::maddux::Maddux
::seamus::Seamus
::jad::Jad
::jeremias::Jeremias
::kylen::Kylen
::rashad::Rashad
::santos::Santos
::cedric::Cedric
::craig::Craig
::dominique::Dominique
::gianluca::Gianluca
::jovanni::Jovanni
::bishop::Bishop
::brenden::Brenden
::anton::Anton
::camron::Camron
::giancarlo::Giancarlo
::lyle::Lyle
::alaric::Alaric
::decker::Decker
::eliezer::Eliezer
::ramiro::Ramiro
::yisroel::Yisroel
::howard::Howard
::jaxx::Jaxx
; Female names. Auto generated in Excel. Source: https://www.babble.com/pregnancy/1000-most-popular-girl-names/ Accessed 15/Nov/19. Added by Conrad
::emma::Emma
::olivia::Olivia
::ava::Ava
::isabella::Isabella
::sophia::Sophia
::mia::Mia
::charlotte::Charlotte
::amelia::Amelia
::evelyn::Evelyn
::abigail::Abigail
::emily::Emily
::elizabeth::Elizabeth
::sofia::Sofia
::ella::Ella
::madison::Madison
::scarlett::Scarlett
::victoria::Victoria
::aria::Aria
::grace::Grace
::chloe::Chloe
::camila::Camila
::penelope::Penelope
::layla::Layla
::lillian::Lillian
::nora::Nora
::zoey::Zoey
::mila::Mila
::aubrey::Aubrey
::hannah::Hannah
::lily::Lily
::addison::Addison
::eleanor::Eleanor
::natalie::Natalie
::luna::Luna
::savannah::Savannah
::brooklyn::Brooklyn
::leah::Leah
::zoe::Zoe
::stella::Stella
::hazel::Hazel
::ellie::Ellie
::paisley::Paisley
::audrey::Audrey
::violet::Violet
::claire::Claire
::bella::Bella
::aurora::Aurora
::lucy::Lucy
::anna::Anna
::samantha::Samantha
::caroline::Caroline
::genesis::Genesis
::aaliyah::Aaliyah
::kennedy::Kennedy
::kinsley::Kinsley
::allison::Allison
::maya::Maya
::sarah::Sarah
::madelyn::Madelyn
::adeline::Adeline
::alexa::Alexa
::ariana::Ariana
::elena::Elena
::gabriella::Gabriella
::naomi::Naomi
::alice::Alice
::sadie::Sadie
::hailey::Hailey
::eva::Eva
::emilia::Emilia
;::autumn::Autumn
::nevaeh::Nevaeh
::piper::Piper
::ruby::Ruby
::serenity::Serenity
::willow::Willow
::everly::Everly
::cora::Cora
::kaylee::Kaylee
::lydia::Lydia
::aubree::Aubree
::arianna::Arianna
::eliana::Eliana
::melanie::Melanie
::gianna::Gianna
::isabelle::Isabelle
::julia::Julia
::valentina::Valentina
::clara::Clara
::vivian::Vivian
::mackenzie::Mackenzie
::madeline::Madeline
::brielle::Brielle
::delilah::Delilah
::isla::Isla
::rylee::Rylee
::katherine::Katherine
::sophie::Sophie
::josephine::Josephine
::ivy::Ivy
::liliana::Liliana
::jade::Jade
::maria::Maria
::hadley::Hadley
::kylie::Kylie
::adalynn::Adalynn
::natalia::Natalia
::annabelle::Annabelle
::faith::Faith
::alexandra::Alexandra
::ximena::Ximena
::ashley::Ashley
::brianna::Brianna
::raelynn::Raelynn
::bailey::Bailey
::mary::Mary
::athena::Athena
::andrea::Andrea
::leilani::Leilani
::jasmine::Jasmine
::lyla::Lyla
::margaret::Margaret
::alyssa::Alyssa
::adalyn::Adalyn
::arya::Arya
::norah::Norah
::khloe::Khloe
::kayla::Kayla
::eliza::Eliza
::rose::Rose
::melody::Melody
::isabel::Isabel
::sydney::Sydney
::juliana::Juliana
::lauren::Lauren
::iris::Iris
::lilly::Lilly
::aliyah::Aliyah
::valeria::Valeria
::arabella::Arabella
::sara::Sara
::trinity::Trinity
::ryleigh::Ryleigh
::jordyn::Jordyn
::jocelyn::Jocelyn
::kimberly::Kimberly
::esther::Esther
::molly::Molly
::valerie::Valerie
::cecilia::Cecilia
::anastasia::Anastasia
::daisy::Daisy
::laila::Laila
::mya::Mya
::amy::Amy
::teagan::Teagan
::amaya::Amaya
::elise::Elise
::harmony::Harmony
::paige::Paige
::adaline::Adaline
::fiona::Fiona
::alaina::Alaina
::nicole::Nicole
::genevieve::Genevieve
::lucia::Lucia
::alina::Alina
::mckenzie::Mckenzie
::callie::Callie
::eloise::Eloise
::brooke::Brooke
::londyn::Londyn
::mariah::Mariah
::julianna::Julianna
::rachel::Rachel
::daniela::Daniela
::gracie::Gracie
::catherine::Catherine
::angelina::Angelina
::presley::Presley
::josie::Josie
::adelyn::Adelyn
::vanessa::Vanessa
::makayla::Makayla
::juliette::Juliette
::amara::Amara
::lila::Lila
::ana::Ana
::alana::Alana
::michelle::Michelle
::malia::Malia
::rebecca::Rebecca
::brooklynn::Brooklynn
::brynlee::Brynlee
;::summer::Summer
::sloane::Sloane
::leila::Leila
::sienna::Sienna
::adriana::Adriana
::juliet::Juliet
::destiny::Destiny
::alayna::Alayna
::elliana::Elliana
::diana::Diana
::ayla::Ayla
::angela::Angela
::noelle::Noelle
::rosalie::Rosalie
::joanna::Joanna
::jayla::Jayla
::alivia::Alivia
::lola::Lola
::emersyn::Emersyn
::georgia::Georgia
::selena::Selena
::daleyza::Daleyza
::tessa::Tessa
::maggie::Maggie
::jessica::Jessica
::remi::Remi
::delaney::Delaney
::camille::Camille
::vivienne::Vivienne
;::hope::Hope
::mckenna::Mckenna
::gemma::Gemma
::olive::Olive
::alexandria::Alexandria
::blakely::Blakely
::izabella::Izabella
::catalina::Catalina
::raegan::Raegan
::journee::Journee
::gabrielle::Gabrielle
::lucille::Lucille
::ruth::Ruth
::amiyah::Amiyah
::evangeline::Evangeline
::thea::Thea
::amina::Amina
::giselle::Giselle
::lilah::Lilah
::melissa::Melissa
;::river::River
::kate::Kate
::adelaide::Adelaide
::charlee::Charlee
::vera::Vera
::leia::Leia
::gabriela::Gabriela
::zara::Zara
::jane::Jane
::journey::Journey
::elaina::Elaina
::miriam::Miriam
::briella::Briella
::stephanie::Stephanie
::cali::Cali
::ember::Ember
::lilliana::Lilliana
::aniyah::Aniyah
::kamila::Kamila
::brynn::Brynn
::ariella::Ariella
::makenzie::Makenzie
::annie::Annie
::mariana::Mariana
::kali::Kali
::haven::Haven
::elsie::Elsie
::nyla::Nyla
::paris::Paris
::lena::Lena
::freya::Freya
::adelynn::Adelynn
::camilla::Camilla
::jennifer::Jennifer
::paislee::Paislee
::talia::Talia
::alessandra::Alessandra
::juniper::Juniper
::fatima::Fatima
::raelyn::Raelyn
::amira::Amira
::arielle::Arielle
::phoebe::Phoebe
::kinley::Kinley
::ada::Ada
::nina::Nina
::ariah::Ariah
::samara::Samara
::myla::Myla
::brinley::Brinley
::cassidy::Cassidy
::maci::Maci
::aspen::Aspen
::allie::Allie
::keira::Keira
::kaia::Kaia
::makenna::Makenna
::amanda::Amanda
::heaven::Heaven
::joy::Joy
::lia::Lia
::madilyn::Madilyn
::gracelyn::Gracelyn
::laura::Laura
::evelynn::Evelynn
::lexi::Lexi
::haley::Haley
::miranda::Miranda
::kaitlyn::Kaitlyn
::daniella::Daniella
::felicity::Felicity
::jacqueline::Jacqueline
::evie::Evie
::angel::Angel
::danielle::Danielle
::ainsley::Ainsley
::kiara::Kiara
::millie::Millie
::maddison::Maddison
::rylie::Rylie
::alicia::Alicia
::maeve::Maeve
::margot::Margot
::kylee::Kylee
::heidi::Heidi
::zuri::Zuri
::alondra::Alondra
::lana::Lana
::madeleine::Madeleine
::gracelynn::Gracelynn
::kenzie::Kenzie
::miracle::Miracle
::shelby::Shelby
::elle::Elle
::adrianna::Adrianna
::bianca::Bianca
::addilyn::Addilyn
::kira::Kira
::veronica::Veronica
::gwendolyn::Gwendolyn
::esmeralda::Esmeralda
::chelsea::Chelsea
::alison::Alison
::magnolia::Magnolia
::daphne::Daphne
::jenna::Jenna
::everleigh::Everleigh
::kyla::Kyla
::braelynn::Braelynn
::harlow::Harlow
::annalise::Annalise
::mikayla::Mikayla
::dahlia::Dahlia
::maliyah::Maliyah
::averie::Averie
::scarlet::Scarlet
::kayleigh::Kayleigh
::luciana::Luciana
::kelsey::Kelsey
::nadia::Nadia
;::amber::Amber
::gia::Gia
::yaretzi::Yaretzi
::carmen::Carmen
::jimena::Jimena
::erin::Erin
::christina::Christina
::katie::Katie
::viviana::Viviana
::alexia::Alexia
::anaya::Anaya
::serena::Serena
::katelyn::Katelyn
::ophelia::Ophelia
::regina::Regina
::helen::Helen
::camryn::Camryn
::cadence::Cadence
::royalty::Royalty
::kathryn::Kathryn
::skye::Skye
::emely::Emely
::jada::Jada
::ariyah::Ariyah
::aylin::Aylin
::saylor::Saylor
::kendra::Kendra
::cheyenne::Cheyenne
::fernanda::Fernanda
::sabrina::Sabrina
::francesca::Francesca
::eve::Eve
::mckinley::Mckinley
::frances::Frances
::sarai::Sarai
::carolina::Carolina
::kennedi::Kennedi
::nylah::Nylah
::alani::Alani
::raven::Raven
::zariah::Zariah
::leslie::Leslie
;::winter::Winter
::abby::Abby
::mabel::Mabel
::sierra::Sierra
::willa::Willa
::carly::Carly
::jolene::Jolene
::rosemary::Rosemary
::aviana::Aviana
::madelynn::Madelynn
::selah::Selah
::renata::Renata
::lorelei::Lorelei
::briana::Briana
::celeste::Celeste
::wren::Wren
::charleigh::Charleigh
::annabella::Annabella
::jayleen::Jayleen
::braelyn::Braelyn
::ashlyn::Ashlyn
::jazlyn::Jazlyn
::mira::Mira
::malaysia::Malaysia
::edith::Edith
::avianna::Avianna
::maryam::Maryam
::emmalyn::Emmalyn
::hattie::Hattie
::kensley::Kensley
::macie::Macie
::bristol::Bristol
::marlee::Marlee
::demi::Demi
::cataleya::Cataleya
::maia::Maia
::sylvia::Sylvia
::itzel::Itzel
::allyson::Allyson
::lilith::Lilith
::melany::Melany
::kaydence::Kaydence
::holly::Holly
::nayeli::Nayeli
::meredith::Meredith
::nia::Nia
::liana::Liana
::megan::Megan
::bethany::Bethany
::alejandra::Alejandra
::janelle::Janelle
::elisa::Elisa
::adelina::Adelina
::ashlynn::Ashlynn
::elianna::Elianna
::aleah::Aleah
::myra::Myra
::lainey::Lainey
::blair::Blair
::kassidy::Kassidy
::charley::Charley
::virginia::Virginia
;::kara::Kara
::helena::Helena
::sasha::Sasha
::julie::Julie
::michaela::Michaela
::matilda::Matilda
::kehlani::Kehlani
::henley::Henley
::maisie::Maisie
::hallie::Hallie
::jazmin::Jazmin
::priscilla::Priscilla
::marilyn::Marilyn
::cecelia::Cecelia
::danna::Danna
::colette::Colette
::baylee::Baylee
::ivanna::Ivanna
::celine::Celine
::alayah::Alayah
::hanna::Hanna
::imani::Imani
::angelica::Angelica
::emelia::Emelia
::kalani::Kalani
::alanna::Alanna
::lorelai::Lorelai
::macy::Macy
::karina::Karina
::addyson::Addyson
::aleena::Aleena
::aisha::Aisha
::johanna::Johanna
::mallory::Mallory
::leona::Leona
::mariam::Mariam
::kynlee::Kynlee
::madilynn::Madilynn
::karen::Karen
::karla::Karla
::skyla::Skyla
::beatrice::Beatrice
::dayana::Dayana
::gloria::Gloria
::milani::Milani
::savanna::Savanna
::karsyn::Karsyn
::giuliana::Giuliana
::lauryn::Lauryn
::liberty::Liberty
::galilea::Galilea
::aubrie::Aubrie
::charli::Charli
::kyleigh::Kyleigh
::brylee::Brylee
::jillian::Jillian
::anne::Anne
::haylee::Haylee
::azalea::Azalea
::jayda::Jayda
::tiffany::Tiffany
::avah::Avah
::bailee::Bailee
::jazmine::Jazmine
::esme::Esme
::coraline::Coraline
::madisyn::Madisyn
::elaine::Elaine
::lilian::Lilian
::kyra::Kyra
::kaliyah::Kaliyah
::kora::Kora
::octavia::Octavia
::irene::Irene
::kelly::Kelly
::lacey::Lacey
::laurel::Laurel
::adley::Adley
::anika::Anika
::janiyah::Janiyah
::dorothy::Dorothy
::julieta::Julieta
::kimber::Kimber
::cassandra::Cassandra
::rebekah::Rebekah
::collins::Collins
::emmy::Emmy
::sloan::Sloan
::hayley::Hayley
::amalia::Amalia
::jemma::Jemma
::melina::Melina
::leyla::Leyla
::jaylah::Jaylah
::anahi::Anahi
::jaliyah::Jaliyah
::kailani::Kailani
::harlee::Harlee
::wynter::Wynter
::saige::Saige
::alessia::Alessia
::monica::Monica
::anya::Anya
::antonella::Antonella
::emberly::Emberly
::khaleesi::Khaleesi
::ivory::Ivory
::greta::Greta
::maren::Maren
::alena::Alena
::alaia::Alaia
::cynthia::Cynthia
::addisyn::Addisyn
::alia::Alia
::lylah::Lylah
::angie::Angie
::ariya::Ariya
::alma::Alma
::crystal::Crystal
::jayde::Jayde
::aileen::Aileen
::kinslee::Kinslee
::siena::Siena
::zelda::Zelda
::katalina::Katalina
::marie::Marie
::pearl::Pearl
::reyna::Reyna
::mae::Mae
::zahra::Zahra
::kailey::Kailey
::tiana::Tiana
::amirah::Amirah
::madalyn::Madalyn
::alaya::Alaya
::lilyana::Lilyana
::julissa::Julissa
::lillie::Lillie
::jolie::Jolie
::laney::Laney
::roselyn::Roselyn
::mara::Mara
::joelle::Joelle
::rosa::Rosa
::kaylani::Kaylani
::bridget::Bridget
::liv::Liv
::oaklyn::Oaklyn
::aurelia::Aurelia
::clarissa::Clarissa
::elyse::Elyse
::marissa::Marissa
::monroe::Monroe
::kori::Kori
::elsa::Elsa
::rosie::Rosie
::amelie::Amelie
::aitana::Aitana
::aliza::Aliza
::eileen::Eileen
::poppy::Poppy
::emmie::Emmie
::braylee::Braylee
::milana::Milana
::addilynn::Addilynn
::chaya::Chaya
::frida::Frida
::bonnie::Bonnie
::amora::Amora
::stevie::Stevie
::tatiana::Tatiana
::malaya::Malaya
::mina::Mina
::emerie::Emerie
::zaylee::Zaylee
::annika::Annika
::kenia::Kenia
::linda::Linda
::kenna::Kenna
::faye::Faye
::reina::Reina
::brittany::Brittany
::marina::Marina
::astrid::Astrid
::kadence::Kadence
::mikaela::Mikaela
::jaelyn::Jaelyn
::kaylie::Kaylie
::teresa::Teresa
::bria::Bria
::hadassah::Hadassah
::lilianna::Lilianna
::guadalupe::Guadalupe
::rayna::Rayna
::chanel::Chanel
::lyra::Lyra
::noa::Noa
::zariyah::Zariyah
::laylah::Laylah
::aubrielle::Aubrielle
::aniya::Aniya
::livia::Livia
::ellen::Ellen
::meadow::Meadow
::amiya::Amiya
::elora::Elora
::princess::Princess
::leanna::Leanna
::nathalie::Nathalie
::clementine::Clementine
::nola::Nola
::tenley::Tenley
::simone::Simone
::lina::Lina
::marianna::Marianna
::martha::Martha
::sariah::Sariah
::louisa::Louisa
::noemi::Noemi
::emmeline::Emmeline
::kenley::Kenley
::belen::Belen
::erika::Erika
::myah::Myah
::lara::Lara
::amani::Amani
::ansley::Ansley
::everlee::Everlee
::maleah::Maleah
::salma::Salma
::jaelynn::Jaelynn
::kiera::Kiera
::dulce::Dulce
::nala::Nala
::natasha::Natasha
::averi::Averi
::mercy::Mercy
::penny::Penny
::ariadne::Ariadne
::deborah::Deborah
::elisabeth::Elisabeth
::zaria::Zaria
::hana::Hana
::kairi::Kairi
::yareli::Yareli
::raina::Raina
::ryann::Ryann
::lexie::Lexie
::thalia::Thalia
::annabel::Annabel
::christine::Christine
::estella::Estella
::keyla::Keyla
::adele::Adele
::aya::Aya
::estelle::Estelle
::tori::Tori
::perla::Perla
::lailah::Lailah
::miah::Miah
::angelique::Angelique
::avalynn::Avalynn
::romina::Romina
::jaycee::Jaycee
::jaylene::Jaylene
::louise::Louise
::mavis::Mavis
::scarlette::Scarlette
::belle::Belle
::lea::Lea
::nalani::Nalani
::rivka::Rivka
::ayleen::Ayleen
::calliope::Calliope
::dalary::Dalary
::zaniyah::Zaniyah
::kaelyn::Kaelyn
;::sky::Sky
::jewel::Jewel
::joselyn::Joselyn
::madalynn::Madalynn
::paola::Paola
::giovanna::Giovanna
::isabela::Isabela
::karlee::Karlee
::aubriella::Aubriella
::tinley::Tinley
;::dream::Dream
::claudia::Claudia
::corinne::Corinne
::erica::Erica
::milena::Milena
::aliana::Aliana
::kallie::Kallie
::alyson::Alyson
::joyce::Joyce
::tinsley::Tinsley
::whitney::Whitney
::emilee::Emilee
::paisleigh::Paisleigh
::carolyn::Carolyn
::jaylee::Jaylee
::zoie::Zoie
::andi::Andi
::judith::Judith
::paula::Paula
::xiomara::Xiomara
::aiyana::Aiyana
::amia::Amia
::analia::Analia
::audrina::Audrina
::hadlee::Hadlee
::rayne::Rayne
::amayah::Amayah
::cara::Cara
::celia::Celia
::lyanna::Lyanna
::opal::Opal
::amaris::Amaris
::clare::Clare
::gwen::Gwen
::giana::Giana
::veda::Veda
::alisha::Alisha
::davina::Davina
::rhea::Rhea
::sariyah::Sariyah
::noor::Noor
::danica::Danica
::kathleen::Kathleen
::lillianna::Lillianna
::lindsey::Lindsey
::maxine::Maxine
::paulina::Paulina
::hailee::Hailee
::harleigh::Harleigh
::nancy::Nancy
::jessa::Jessa
::raquel::Raquel
::raylee::Raylee
::zainab::Zainab
::chana::Chana
::lisa::Lisa
::heavenly::Heavenly
::oaklynn::Oaklynn
::aminah::Aminah
::emmalynn::Emmalynn
::patricia::Patricia
::india::India
::janessa::Janessa
::paloma::Paloma
::ramona::Ramona
::sandra::Sandra
::abril::Abril
::emmaline::Emmaline
::itzayana::Itzayana
::kassandra::Kassandra
::vienna::Vienna
::marleigh::Marleigh
::kailyn::Kailyn
::novalee::Novalee
::rosalyn::Rosalyn
::hadleigh::Hadleigh
::luella::Luella
::taliyah::Taliyah
::avalyn::Avalyn
::barbara::Barbara
::iliana::Iliana
::jana::Jana
::meilani::Meilani
::aadhya::Aadhya
::alannah::Alannah
::blaire::Blaire
::brenda::Brenda
::selene::Selene
::lizbeth::Lizbeth
::adrienne::Adrienne
::annalee::Annalee
::malani::Malani
::aliya::Aliya
::miley::Miley
::nataly::Nataly
::bexley::Bexley
::joslyn::Joslyn
::maliah::Maliah
::breanna::Breanna
::melania::Melania
::estrella::Estrella
::ingrid::Ingrid
::kaya::Kaya
::kaylin::Kaylin
::harmoni::Harmoni
::arely::Arely
::jazlynn::Jazlynn
::kiana::Kiana
::dana::Dana
::mylah::Mylah
::oaklee::Oaklee
::ailani::Ailani
::kailee::Kailee
::legacy::Legacy
::marjorie::Marjorie
::paityn::Paityn
::courtney::Courtney
::ellianna::Ellianna
::jurnee::Jurnee
::karlie::Karlie
::evalyn::Evalyn
::holland::Holland
::kenya::Kenya
::magdalena::Magdalena
::carla::Carla
::halle::Halle
::aryanna::Aryanna
::kaiya::Kaiya
::kimora::Kimora
::naya::Naya
::saoirse::Saoirse
::susan::Susan
::desiree::Desiree
::ensley::Ensley
::renee::Renee
::esperanza::Esperanza
::treasure::Treasure
::caylee::Caylee
::ellison::Ellison
::kristina::Kristina
::adilynn::Adilynn
::anabelle::Anabelle
::egypt::Egypt
::tegan::Tegan
::aranza::Aranza
::vada::Vada
::emerald::Emerald
::florence::Florence
::marlowe::Marlowe
::sonia::Sonia
::sunny::Sunny
::tara::Tara
::riya::Riya
::yara::Yara
::alisa::Alisa
::nathalia::Nathalia
::yamileth::Yamileth
::saanvi::Saanvi
::samira::Samira
::sylvie::Sylvie
::brenna::Brenna
::carlee::Carlee
::jenny::Jenny
::miya::Miya
::monserrat::Monserrat
::zendaya::Zendaya
::alora::Alora

;--------------------PERIOD
:*c?:.a::. A
:*c?:.b::. B
:*c?:.c::. C
:*c?:.d::. D
:*c?:.e::. E
:*c?:.f::. F
:*c?:.g::. G
:*c?:.h::. H
:*c?:.i::. I
:*c?:.j::. J
:*c?:.k::. K
:*c?:.l::. L
:*c?:.m::. M
:*c?:.n::. N
:*c?:.o::. O
:*c?:.p::. P
:*c?:.q::. Q
:*c?:.r::. R
:*c?:.s::. S
:*c?:.t::. T
:*c?:.u::. U
:*c?:.v::. V
:*c?:.w::. W
:*c?:.x::. X
:*c?:.y::. Y
:*c?:.z::. Z
;--------------------QUESTION MARK
:*c?:?a::? A
:*c?:?b::? B
:*c?:?c::? C
:*c?:?d::? D
:*c?:?e::? E
:*c?:?f::? F
:*c?:?g::? G
:*c?:?h::? H
:*c?:?i::? I
:*c?:?j::? J
:*c?:?k::? K
:*c?:?l::? L
:*c?:?m::? M
:*c?:?n::? N
:*c?:?o::? O
:*c?:?p::? P
:*c?:?q::? Q
:*c?:?r::? R
:*c?:?s::? S
:*c?:?t::? T
:*c?:?u::? U
:*c?:?v::? V
:*c?:?w::? W
:*c?:?x::? X
:*c?:?y::? Y
:*c?:?z::? Z
;--------------------EXCLAM
:*c?:!a::! A
:*c?:!b::! B
:*c?:!c::! C
:*c?:!d::! D
:*c?:!e::! E
:*c?:!f::! F
:*c?:!g::! G
:*c?:!h::! H
:*c?:!i::! I
:*c?:!j::! J
:*c?:!k::! K
:*c?:!l::! L
:*c?:!m::! M
:*c?:!n::! N
:*c?:!o::! O
:*c?:!p::! P
:*c?:!q::! Q
:*c?:!r::! R
:*c?:!s::! S
:*c?:!t::! T
:*c?:!u::! U
:*c?:!v::! V
:*c?:!w::! W
:*c?:!x::! X
:*c?:!y::! Y
:*c?:!z::! Z
;------------------------------------------------------------------------------
; from https://www.ortograf.pl/watpliwosci-jezykowe as seen on 

::bżdąc::brzdąc
::brzdonc::brzdąc
::ukszyżowanie::ukrzyżowanie
::ukżyrzowanie::ukrzyżowanie
::ukrzyrzowanie::ukrzyżowanie
::ani się wasz::ani się waż
::ani się warz::ani się waż
::baldahim::baldachim
::blamasz::blamaż
::błendy::błędy
::borzyszcze::bożyszcze
::bódka::budka
::burrzuazja::burżuazja
::cokuł::cokół
::dororzka::dorożka
::gżanka::grzanka
::charmonia::harmonia
::cherbata::herbata
::chops::hops
::jażębina::jarzębina
::koleszka::koleżka
::kósy::kusy
::lerzak::leżak
::menager::manager
::niby gwiazda::nibygwiazda
::nielepszy::nie lepszy
::niemogąc::nie mogąc
::nie domagać::niedomagać
::nie przyzwyczajony::nieprzyzwyczajony
::nie szanujący::nieszanujący
::ogrud::ogród
::penczek::pęczek
::pietrószka::pietruszka
::nie zadowolony::niezadowolony
::popielec::Popielec
::przełencz::przełęcz
::stróś::struś
::super bohater::superbohater
::świadkowie Jehowi::świadkowie Jehowy
::szczór::szczur
::sznorówki::sznurówki
::sznórówki::sznurówki
::szwędać::szwendać
::troche::trochę
::ucieknął::uciekł
::wyrahowany::wyrachowany
::złorzyć::złożyć
::rzwawo::żwawo
::żerafa::żyrafa
::10-cio lecie::10-lecie
::5 lipiec::5 lipca
::anuż::a nuż
::abnegad::abnegat
::Abracham::Abraham
::abstrachując::abstrahując
::apsztyfikant::absztyfikant
::acha::aha
::adekfatny::adekwatny
::adiónkt::adiunkt
::agrawka::agrafka
::ah::ach
::achoj::ahoj
::akademi::akademii
::akcesorii::akcesoriów
::akuku::a kuku
::akórat::akurat
::akwen wodny::akwen
::aleji::alei
::alkochol::alkohol
::amelinum::aluminum
::Ameli::Amelii
::amplitóda::amplituda
::anarhia::anarchia
::Andrzejki::andrzejki
::Andżelika::Angelika
::Angli::Anglii
::Anii::Ani
::ani raz::ani razu
::apropos::a propos
::akwapark::aquapark
::arbitrasz::arbitraż
::arbóz::arbuz
::arhaizm::archaizm
::arhetyp::archetyp
::arhipelag::archipelag
::artykół::artykuł
::Atheny::Ateny
::ałreola::aureola
::Australi::Australii
::auto korekta::autokorekta
::avokado::awokado
::arz::aż
::asz::aż
::aż nad to::aż nadto
::azalisz::azaliż
::bombel::bąbel
::babiaż::babiarz
::bahor::bachor
::bakłażan::bakłażan
::bakteri::bakterii
::balejarz::balejaż
::balejasz::balejaż
::bauwan::bałwan
::bandasz::bandaż
::bandarz::bandaż
::barzant::bażant
::bemben::bęben
::będom::będą
::będe::będę
::bechawioryzm::behawioryzm
::benkart::bękart
::besti::bestii
::bezsensu::bez sensu
::bezemnie::beze mnie
::bez płatny::bezpłatny
::bez problemowy::bezproblemowy
::bez użyteczna::bezużyteczna
::bez wypadkowy::bezwypadkowy
::białoczerwony::biało-czerwony
::bież::bierz
::bieżemy::bierzemy
::biling::billing
::bióro::biuro
::biznes plan::biznesplan
::birzuteria::biżuteria
::blaha::blacha

::błond::błąd
::błąt::błąd
::błont::błąd
::blado różowy::bladoróżowy
::błachostka::błahostka
::błachy::błahy
::Błarzej::Błażej
::błendnik::błędnik
::błendny::błędny
::blirzej::bliżej
::błazeria::boazeria
::bohenek::bochenek
::bodajrze::bodajże
::bochater::bohater
::boiler::bojler
::boji::boi
::bustwo::bóstwo
::boże narodzenie::Boże Narodzenie
::Borzena::Bożena
::bożo narodzeniowy::bożonarodzeniowy
::branzoletka::bransoletka
::brawóra::brawura
::bronz::brąz
::brokuły::brokuł
::brożka::broszka
::brózda::bruzda
::brudka::bródka
::Bruna::Brunona
::bżemię::brzemię
::bżmieć::brzmieć
::brzozkwinia::brzoskwinia
::brzóska::brzózka
::brzuzka::brzózka
::brzóch::brzuch
::brzytki::brzydki
::bżydula::brzydula
::bójać::bujać
::bókiet::bukiet
::bókszpan::bukszpan
::bul::ból
::bólwa::bulwa
::bandżi::bungee
::bórczy::burczy
::bórsztyn::bursztyn
::buża::burza
::bóziaki::buziaki
::była by::byłaby
::byle byś::bylebyś
::byle by::byleby
::bylejak::byle jak
::byli by::byliby
::było by::byłoby
::bzdóra::bzdura
::capucino::cappuccino
::Celcjusza::Celsjusza
::cemęt::cement
::haber::chaber
::chałas::hałas
::hałtura::chałtura
::hamski::chamski
::handra::chandra
::haos::chaos
::harakter::charakter
::harczeć::charczeć
::haryzma::charyzma
::hata::chata
::chcem::chcę
::chciał bym::chciałbym
::chciał byś::chciałbyś
::hciwy::chciwy
::czirliderka::cheerleaderka
::chemi::chemii
::hemia::chemia
::herlawy::cherlawy
::herubin::cherubin
::chentnie::chętnie
::chętniebym::chętnie bym
::hihot::chichot
::chihot::chichot
::hichot::chichot
::chihrać się::chichrać się
::hichrać się::chichrać się
::himera::chimera
::hirurg::chirurg
::hlać::chlać
::hlipać::chlipać
::hłopak::chłopak
::chłopaką::chłopakom
::hmura::chmura
::hochla::chochla
::hohlik::chochlik
::chociarz::chociaż
::chodźby::choćby
::chodzi oto::chodzi o to
::choćmy::chodźmy
::hoinka::choinka
::chojny::hojny
::hojrak::chojrak
::holera::cholera
::holewka::cholewka
::homąto::chomąto
::homik::chomik
::chop::hop
::hrabąszcz::chrabąszcz
::chrabonszcz::chrabąszcz
::chrabonszcz::chrabąszcz
::hrapać::chrapać
::hrupki::chrupki
::hrust::chrust
::chróst::chrust
::hryzantema::chryzantema
::hszan::chrzan
::hrząszcz::chrząszcz
::chszonszcz::chrząszcz
::Chrześcijaństwo::chrześcijaństwo
::chrzestnica::chrześnica
::chrześnik::chrześniak
::chrzesna::chrzestna
::chuhać::chuchać
::huchać::chuchać
::huherko::chucherko
::chuherko::chucherko
::hucherko::chucherko
::hudy::chudy
::chódy::chudy
::huj::chuj
::huligan::chuligan
::chumor::humor
::czupa czups::chupa chups
::husteczka::chusteczka
::hwalipięta::chwalipięta
::chfalipięta::chwalipięta
::hwiejny::chwiejny
::chwilii::chwili
::hyba::chyba
::chybaże::chyba że
::hybotać się::chybotać się
::hytry::chytry
::cionrza::ciąża
::cięki::cienki
::ciele::cielę
::cięrzar::ciężar
::cióchy::ciuchy
::klu::clou
::cmętarz::cmentarz
::conajmniej::co najmniej
::coniektórzy::co niektórzy
::co nie miara::co niemiara
::coniemiara::co niemiara
::códne::cudne
::co dzienny::codzienny
::cofać do tyłu::cofać
::co kolwiek::cokolwiek
::kola::cola
::co miesięczny::comiesięczny
::co raz::coraz
::curka::córka
::co roczny::coroczny
::cusz::cóż
::kredo::credo
::cókier::cukier
::cukini::cukinii
::cuż::cóż
::ćwierć wiecze::ćwierćwiecze
::czego kolwiek::czegokolwiek
::czelóść::czeluść
::cziłała::chihuahua
::czmyhnąć::czmychnąć
::czułko::czółko
::czóbek::czubek
::czóje::czuje
::czwurka::czwórka
::czycha::czyha
::czym kolwiek::czymkolwiek
::czyrzyk::czyżyk
::Dari::Darii
::Darjusz::Dariusz
::Darjósz::Dariusz
::Dariósz::Dariusz
::dażyć::darzyć
::date::datę
::dąrzyć::dążyć
::demby::dęby
::deżawi::déjà vu
::dekold::dekolt
::dizajn::design
::dentka::dętka
::dewolaj::de volaille
::dizel::Diesel
::diwa::diva
::dla czemu::dlaczego
::dlatego ponieważ::ponieważ
::dlatego bo::dlatego że
::dłógopis::długopis
::długo włosa::długowłosa
::doczynienia::do czynienia
::dowidzenia::do widzenia
::dozobaczenia::do zobaczenia
::dobrywieczór::dobry wieczór
::dobuduwka::dobudówka
::dobóduwka::dobudówka
::do czekać::doczekać
::dojutra::do jutra
::doktór::doktor
::doktur::doktor
::duł::dół
::dołanczam::dołączam
::dołuż::dołóż
::dołurz::dołóż
::do okoła::dookoła
::do póki::dopóki
::dopuki::dopóki
::dźwi::drzwi
::dżwi::drzwi
::dabing::dubbing
::dubing::dubbing
::dókat::dukat
::druszlak::durszlak
::dósza::dusza
::z dużej litery::dużą literą
::dopołudnia::do południa
::do pytać::dopytać
::dożucić::dorzucić
::Dosiego roku::Do siego roku
::dorzynki::dożynki
::drelih::drelich
::drószka::dróżka
::druszka::dróżka
::drórzka::dróżka
::drógi::drugi
::druch::druh
::dróhna::druhna
::drók::druk
::drurzyna::drużyna
::drrzeć::drżeć
::drrzeć::drżeć
::dżemka::drzemka
::durzy::duży
::dwuch::dwóch
::dwum::dwóm
::dwożec::dworzec
::dwu kropek::dwukropek
::dwu krotnie::dwukrotnie
::derektor::dyrektor
::dys honor::dyshonor
::dyskórs::dyskurs
::dyslekcja::dyskurs
::desydent::dysydent
::ddżysty::dżdżysty
::dzionsła::dziąsła
::dzieciami::dziećmi
::dziencioł::dzięcioł
::dziecią::dzieciom
::dzienki::dzięki
::dzieńdobry::dzień dobry
::dzień dziecka::Dzień Dziecka
::dzień dzisiejszy::dziś
::dzierrzawca::dzierżawca
::dziewieńcset::dziewięćset
::dziub::dziób
::dziubek::dzióbek
::dzióra::dziura
::dżownica::dżdżownica
::eho::echo
::ekri::écru
::egzekfować::egzekwować
::egzekwo::ex aequo
::egzemplasz::egzemplarz
::eks mąż::eksmąż
::elokwętny::elokwentny
::Elrzbieta::Elżbieta
::empati::empatii
::Emili::Emilii
::energi::energii
::anturasz::entourage
::anturasz::entourage
::epopeji::epopei
::asencja::esencja
::ekspresso::espresso
::esy floresy::esy-floresy
::esyfloresy::esy-floresy
::europejczyk::Europejczyk
::iwent::event
::expresis verbis::expressis verbis
::facebook::Facebook
::fejsbuk::Facebook
::fer::fair
::fakt autentyczny::autentyczny
::fartuh::fartuch
::fo pa::faux pas
::feljeton::felieton
::fermęt::ferment
::filcharmonia::filharmoina
::fili::filii
::filirzanka::filiżanka
::filmuw::filmów
::fjołki::fiołki
::fjord::fiord
::firnament::firmament
::flondra::flądra
::flustracja::frustracja
::foh::foch
::foli::folii
::foróm::forum
::frekfencja::frekwencja
::fuha::fucha
::furarz::furaż
::fórtka::furtka
::Gabrielii::Gabrieli
::Gabrysii::Gabrysi
::gązka::gąska
::gonska::gąska
::gas::gaz
::Gdynii::Gdyni
::gdyrz::gdyż
::gdysz::gdyż
::gdzieindziej::gdzie indziej
::gdzie kolwiek::gdziekolwiek
::gdzie niegdzie::gdzieniegdzie
::gemba::gęba
::gehena::gehenna
::gimbuz::gimbus
::gmah::gmach
::gnuj::gnój
::gołomb::gołąb
::gura::góra
::gożelnia::gorzelnia
::goszki::gorzki
::gością::gościom
::gożej::gorzej
::grabierz::grabież
::grabiesz::grabież
::grafiti::graffiti
::gracham::graham
::grejfrut::grejpfrut
::grekokatolicki::greckokatolicki
::gril::grill
::grub::grób
::groh::groch
::gróby::gruby
::gróle::grule
::grónt::grunt
::grószka::gruszka
::grzonski::grząski
::gżąski::grząski
::gżech::grzech
::Grzegosz::Grzegorz
::gżmi::grzmi
::gżyby::grzyby
::góbi::gubi
::gural::góral
::góst::gust
::gózik::guzik
::kwoli::gwoli
::grzegrzółka::gżegżółka
::habry::chabry
::chaczyk::haczyk
::chaft::haft
::chajs::hajs
::hacker::haker
::chłada::hałda
::chalka::halka
::halołin::halloween
::chalo::halo
::ham::cham
::chamburger::hamburger
::youtube::YouTube
::nei::nie
::chamulec::hamulec
::chańba::hańba
::chandel::handel
::changar::hangar
::Hanii::Hani
::chaniebny::haniebny
::Channa::Hanna
::charce::harce
::charcerz::harcerz
::harcesz::harcerz
::chardy::hardy
::charem::harem
::charfa::harfa
::charmider::harmider
::charmonijka::harmonijka
::charmonogram::harmonogram
::charować::harować
::charówka::harówka
::charpagan::harpagan
::chasać::hasać
::chasło::hasać
::haszcze::chaszcze
::hasztag::hashtag
::chazard::hazard
::hce::chce
::checa::heca
::chej::hej
::chejnał::hejnał
::hatakumba::hekatomba
::chektar::hektar
::Chelena::hektar
::chelikopter::helikopter
::chełm::hełm
::chen::hen
::cherb::herb
::cheroina::heroina
::cheroizm::heroizm
::chiacynt::hiacynt
::chiena::hiena
::chigroskopijny::higroskopijny
::Hiny::Chiny
::Chiob::Hiob
::chiperbola::hiperbola
::chiperpoprawność::hiperpoprawność
::chipnoza::hipnoza
::chipochondryk::hipochondryk
::hipohondryk::hipochondryk
::chipokryta::hipokryta
::chisteria::histeria
::histori::historii
::chistoria::historia
::chit::hit
::hobysta::hobbysta
::chodowla::hodowla
::chokej::hokej
::chol::hol
::chola::hola
::cholistyczny::holistyczny
::chołota::hołota
::cholować::holować
::chomar::homar
::chonor::honor
::Chonorata::Honorata
::horał::chorał
::horendalne::horrendalne
::chormony::hormony
::choroskop::horoskop
::chorror::horror
::hory::chory
::choryzont::horyzont
::choryzont::horyzont
::horyząt::horyzont
::chostia::hostia
::chotel::hotel
::howa::chowa
::choży::hoży
::hrypa::chrypa
::Chubert::Hubert
::huć::chuć
::chucpa::hucpa
::chuczy::huczy
::chufiec::hufiec
::Huga::Hugona
::chuk::huk
::chulajnoga::hulajnoga
::chultaj::hultaj
::hummus::humus
::chummus::humus
::chuncwot::huncwot
::chura::hura
::churagan::huragan
::chuśtawka::huśtawka
::chuta::huta
::chycel::hycel
::chydraulik::hydraulik
::hyży::chyży
::ideii::idei
::idjoci::idioci
::iglo::igloo
::imidż::image
::imie::imię
::immamentny::immanentny
::invitro::in vitro
::inchalacja::inhalacja
::iniciały::inicjały
::injekcja::iniekcja
::instagram::Instagram
::instrókcja::instrukcja
::instruktarz::instruktaż
::instrómenty::instrumenty
::intęcje::intencje
::inwektywów::inwektyw
::aifon::iPhone
::istniał by::istniałby
::Iwa::Iwona
::Izabelii::Izabeli
::japko::jabłko
::jaht::jacht
::dżakuzi::jacuzzi
::Jadwigii::Jadwigi
::jak narazie::jak na razie
::chamak::hamak
::niebierz::nie bierz
::szynszyl::szynszyla
::jakto::jak to
::jak by co::jakby co
::jak bym::jakbym
::jakich kolwiek::jakichkolwiek
::jakoże::jako że
::jałmurzna::jałmużna
::jałmóżna::jałmużna
::jarmurz::jarmuż
::jarmusz::jarmuż
::jażmo::jarzmo
::jażyny::jarzyny
::Jasełka::jasełka
::jaskułka::jaskółka
::jasno niebieski::jasnoniebieski
::jaszczórka::jaszczurka
::dźinsy::jeansy
::jednom::jedną
::jednakoworz::jednakowoż
::jednak że::jednakże
::jedno znaczny::jednoznaczny
::jedynaście::jedenaście
::jerz::jeż
::Jeży::Jerzy
::jerzyny::jeżyny
::jerzeli::jeżeli
::języczek uwagi::języczek u wagi
::jenzyk::język
::język Polski::język polski
::Juzef::Józef
::juchas::juhas
::jóhas::juhas
::Juli::Julii
::jótro::jutro
::jusz::już
::Kaji::Kai
::kejzerka::kajzerka
::kakaa::kakao
::kakała::kakao
::kałamaż::kałamarz
::kalkólator::kalkulator
::kałurza::kałuża
::kałóża::kałuża
::Kamilii::Kamili
::kamuflarz::kamuflaż
::kanabka::kanapka
::kancelari::kancelarii
::kompać::kąpać
::kąplet::komplet
::karmik::karmnik
::karnik::karmnik
::karnirz::karnisz
::karniż::karnisz
::kartka papieru::kartka
::każeł::karzeł
::kategori::kategorii
::katarzis::katharsis
::Katolik::katolik
::kontomierz::kątomierz
::kawałek torta::kawałek tortu
::kawiarnii::kawiarni
::kafka::kawka
::karzdy::każdy
::kebap::kebab
::kihać::kichać
::kiedyindziej::kiedy indziej
::kiełubasa::kiełbasa
::kielih::kielich
::kilku sekundowe::kilkusekundowe
::kim kolwiek::kimkolwiek
::Kingii::Kingi
::kiślu::kisielu
::Klaudi::Klaudii
::klałn::klaun
::klaón::klaun
::klawiatóra::klawiatura
::klijent::klient
::klientą::klientom
::klnąć::kląć
::kląb::klomb
::kłutnia::kłótnia
::kluha::klucha
::klócz::klucz
::kłudka::kłódka
::kohać::kochać
::kocy::koców
::kocór::kocur
::kogiel-mogiel::kogel-mogel
::kogót::kogut
::kocherentny::koherentny
::kojażę::kojarzę
::kokjetować::kokietować
::kolarz::kolaż
::kordła::kołdra
::kolenda::kolęda
::kolerzanka::koleżanka
::kulko::kółko
::kolokfializm::kolokwializm
::kąbinować::kombinować
::komętasz::komentarz
::komętarz::komentarz
::konfort::komfort
::kąpetencje::kompetencje
::kąplement::komplement
::kąpromis::kompromis
::kąto::konto
::kontrachent::kontrahent
::kontynułuj::kontynuuj
::koordynatów::koordynat
::Korneli::Kornelii
::korytaż::korytarz
::kożeń::korzeń
::kościuł::kościół
::kościół mariacki::kościół Mariacki
::kósi::kusi
::kuzka::kózka
::kompóter::komputer
::komu kolwiek::komukolwiek
::komónia::komunia
::komuni::komunii
::kondon::kondom
::konefka::konewka
::konii::koni
::konklózja::konkluzja
::kąkubent::konkubent
::kąstytucja::konstytucja
::korzuch::kożuch
::kretka::kredka
::krul::król
::krulestwo::królestwo
::krulik::królik
::krutki::krótki
::krótrzy::krótszy
::krucej::krócej
::krók::kruk
::krószec::kruszec
::króżganek::krużganek
::krwii::krwi
::kszątanie::krzątanie
::kszem::krzem
::kszemień::krzemień
::kszepki::krzepki
::kżepki::krzepki
::kszta::krzta
::Kszysztof::Krzysztof
::kszysz::krzyż
::krzysz::krzyż
::krzyrz::krzyż
::krzyrzówka::krzyżówka
::ksiondz::ksiądz
::książe::książę
::ksiąrzka::książka
::ksionżka::książka
::ksiąszka::książka
::księrzyc::księżyc
::ksienrzyc::księżyc
::krztałt::kształt
::kto kolwiek::ktokolwiek
::ktoby::kto by
::którom::którą
::którendy::którędy
::ktury::który
::ktuż::któż
::którz::któż
::któsz::któż
::kóbek::kubek
::kuchnii::kuchni
::kócyk::kucyk
::kójon::kuJon
::kókółka::kukułka
::kukórydza::kukurydza
::kóla::kula
::kólka::kulka
::kóltura::kultura
::kómpel::kumpel
::kupywać::kupować
::kóra::kura
::kórier::kurier
::kórsywa::kursywa
::kórtyna::kurtyna
::kóruj::kuruj
::kórwa::kurwa
::kusz::kurz
::kustorz::kustosz
::kustoż::kustosz
::kóśtykać::kuśtykać
::kóźnia::kuźnia
::kwesti::kwestii
::kfiatki::kwiatki
::kfintesencja::kwintesencja
::kforum::kworum
::łabądź::łabędź
::labolatorium::laboratorium
::lablator::labrador
::lajik::laik
::łonka::łąka
::lampard::lampart
::lazania::lasagne
::latex::lateks
::layki::lajki
::lizing::leasing
::lising::leasing
::lekko myślny::lekkomyślny
::łep::łeb
::leprzy::lepszy
::lezba::lesba
::letko::lekko
::lerzakować::leżakować
::lezbijki::lesbijki
::lerzy::leży
::lini::linii
::liściami::liśćmi
::life::live
::łudka::łódka
::lodżia::loggia
::łużko::łóżko
::łószko::łóżko
::lubiałem::lubiłem
::ludzią::ludziom
::lajkra::lycra
::łyrzka::łyżka
::łyrzwy::łyżwy
::maconald::McDonald's
::mahina::machina
::machoń::mahoń
::maczo::macho
::magi::magii
::Maji::Mai
::meila::maila
::Majówka::majówka
::mejkap::make-up
::Małgożata::Małgorzata
::mało mówny::małomówny
::małrze::małże
::małrzonka::małżonka
::mamisynek::maminsynek
::mariarz::mariaż
::Mari::Marii
::marmelada::marmolada
::mars::Mars
::marsjanin::Marsjanin
::maródzić::marudzić
::Maryji::Maryi
::Marysii::Marysi
::mażanna::marzanna
::mażec::marzec
::mażenia::marzenia
::masohista::masochista
::matóra::matura
::mazowsze::Mazowsze
::mazury::Mazury
::meh::mech
::mehanik::mechanik
::melanrz::melanż
::melansz::melanż
::menbrana::membrana
::menarzka::menażka
::męda::menda
::menski::męski
::mentlik::mętlik
::miąsz::miąższ
::mieć fach w ręce::mieć fach w ręku
::miendzy::między
::międzyinnymi::między innymi
::miesionc::miesiąc
::mienso::mięso
::migli::mignęli
::milijon::milion
::miłorząb::miłożąb
::mineło::minęło
::mini spódniczka::minispódniczka
::mini rozmówki::minirozmówki
::minoł::minął
::mirasz::miraż
::mirarz::miraż
::miszczowski::mistrzowski
::misz masz::miszmasz
::młodziesz::młodzież
::młodzierz::młodzież
::mnustwo::mnóstwo
::muc::móc
::mocher::moher
::mógł byś::mógłbyś
::mogła by::mogłaby
::mogło by::mogłoby
::mojich::moich
::mojim::moim
::muj::mój
::mohito::mojito
::momęt::moment
::monarha::monarcha
::montarz::montaż
::mówiom::mówią
::muwić::mówić
::moździeż::moździerz
::moździesz::moździerz
::muzg::mózg
::możnaby::można by
::morzna::można
::mrorzonki::mrożonki
::mrógać::mrugać
::muhomor::muchomor
::mół::muł
::móle::mule
::multi-kulti::multikulti
::Mundial::mundial
::mundór::mundur
::móndur::mundur
::mór::mur
::móskuły::muskuły
::muskóły::muskuły
::musze::muszę
::mószla::muszla
::mósztarda::musztarda
::mrzawka::mżawka
::mżonka::mrzonka
::mrzy::mży
::mrzyć::mżyć
::na bierząco::na bieżąco
::na hybcika::na chybcika
::naniby::na niby
::naogół::na ogół
::napewno::na pewno
::na pochybel::na pohybel
::naprzykład::na przykład
::narazie::na razie
::na szyji::na szyi
::naboji::naboi
::nahalny::nachalny
::naczosy::nachosy
::nacodzień::na co dzień
::naczczo::na czczo
::nadwyraz::nad wyraz
::na daremno::nadaremno
::nad brzeże::nadbrzeże
::nademną::nade mną
::Nadi::Nadii
::nad przyrodzone::nadprzyrodzone
::nadstan::nad stan
::nadwerężać::nadwyrężać
::nadzieji::nadziei
::najblizsi::najbliżsi
::namieżyć::namierzyć
::na oczny::naoczny
::naobkoło::naokoło
::napuj::napój
::na prędce::naprędce
::na przeciwko::naprzeciwko
::naprzekór::na przekór
::nararzać::narażać
::nażeczona::narzeczona
::narzyczony::narzeczony
::nażędzia::narzędzia
::naskutek::na skutek
::następnom::następną
::nastempny::następny
::naszczęście::na szczęście
::Natali::Natalii
::natemat::na temat
::naukom::nauką
::na wzajem::nawzajem
::na zajutrz::nazajutrz
::nażekać::narzekać
::nerwós::nerwus
::nefralgiczny::newralgiczny
::nic nie robienie::nicnierobienie
::niebardzo::nie bardzo
::niebędzie::nie będzie
::niebyle::nie byle
::nie całe::niecałe
::niecałkiem::nie całkiem
::nie cały::niecały
::niechcę::nie chcę
::nie chętnie::niechętnie
::nie czynne::nieczynne
::nie dokońca::nie do końca
::nie dowiary::nie do wiary
::niedowiary::nie do wiary
::niedość::nie dość
::niedotyczy::nie dotyczy
::nie dużo::niedużo
::niedziała::nie działa
::nielada::nie lada
::nie istotne::nieistotne
::niejest::nie jest
::nie koniecznie::niekoniecznie
::niema::nie ma
::niemam::nie mam
::nie miłe::niemiłe
::niemogę::nie mogę
::nie możliwe::niemożliwe
::nienadążam::nie nadążam
::nienajgorzej::nie najgorzej
::nienalegam::nie nalegam
::nie narodzony::nienarodzony
::nie ogolony::nieogolony
::niepalić::nie palić
::niepisać::nie pisać
::niepodlega::nie podlega
::nie poprawny::niepoprawny
::nieposiadam::nie posiadam
::nie potrzebny::niepotrzebny
::nieprzeszkadzać::nie przeszkadzać
::nierozumiem::nie rozumiem
::nie śmieszne::nieśmieszne
::niesposób::nie sposób
::niestwierdzono::nie stwierdzono
::nietak::nie tak
::nietutaj::nie tutaj
::nietylko::nie tylko
::nie typowe::nietypowe
::nie używany::nieużywany
::niewątpię::nie wątpię
::nie wątpliwie::niewątpliwie
::nie ważne::nieważne
::nie wiedza::niewiedza
::nie wiele::niewiele
::niewiem::nie wiem
::niewierzę::nie wierzę
::niewszędzie::nie wszędzie
::nie wychowany::niewychowany
::nie wygodny::niewygodny
::nie wyspany::niewyspany
::nie zadbany::niezadbany
::nie zadowolenie::niezadowolenie
::nie zawodny::niezawodny
::niezawsze::nie zawsze
::nie zdrowe::niezdrowe
::nieznam::nie znam
::nie zniszczone::niezniszczone
::nie żyjący::nieżyjący
::niePolak::nie-Polak
::nie Polak::nie-Polak
::nie aktualne::nieaktualne
::nie bawem::niebawem
::niebiesko oki::niebieskooki
::nie chcący::niechcący
::niehybnie::niechybnie
::nie cierpliwić się::niecierpliwić się
::nie często::nieczęsto
::nieda::nie da
::nie daleko::niedaleko
::nie dawno::niedawno
::nie długo::niedługo
::nie dobrze::niedobrze
::nie dosłyszeć::niedosłyszeć
::niedostarczono::nie dostarczono
::nie dotrzymanie::niedotrzymanie
::nie dowidzieć::niedowidzieć
::nie drogi::niedrogi
::nie bawem::niebawem
::niebiesko oki::niebieskooki
::nie chcący::niechcący
::niehybnie::niechybnie
::nie cierpliwić się::niecierpliwić się
::nie często::nieczęsto
::nieda::nie da
::nie daleko::niedaleko
::nie dawno::niedawno
::nie długo::niedługo
::nie dobrze::niedobrze
::nie dosłyszeć::niedosłyszeć
::niedostarczono::nie dostarczono
::nie dotrzymanie::niedotrzymanie
::nie dowidzieć::niedowidzieć
::nie drogi::niedrogi
::nie aktualne::nieaktualne
::nie dzisiejszy::niedzisiejszy
::nie elegancko::nieelegancko
::nie fajnie::niefajnie
::niegorszy::nie gorszy
::nie kiedy::niekiedy
::niekilka::nie kilka
::nie które::niektóre
::nie którzy::niektórzy
::nie ładnie::nieładnie
::nielepiej::nie lepiej
::nie malże::niemalże
::niemiał::nie miał
::nie mile::niemile
::nie miły::niemiły
::niemoje::nie moje
::nie mówiący::niemówiący
::niemowlont::niemowląt
::nie opodal::nieopodal
::nienajlepiej::nie najlepiej
::nienajlepszy::nie najlepszy
::nienajpiękniejszy::nie najpiękniejszy
::nie nawidzę::nienawidzę
::nienawidzieć::nienawidzić
::nie obecny::nieobecny
::nie obliczalny::nieobliczalny
::nie oceniony::nieoceniony
::nie omal::nieomal
::nie opisany::nieopisany
::nie palący::niepalący
::niepamiętam::nie pamiętam
::niepasuje::nie pasuje
::nie piszący::niepiszący
::niepół::nie pół
::niepowiem::nie powiem
::nie pozorny::niepozorny
::nie prawda::nieprawda
::nie przerwanie::nieprzerwanie
::nie przygotowani::nieprzygotowani
::nie słyszący::niesłyszący
::niesłyszę::nie słyszę
::nie spełna::niespełna
::nie stety::niestety
::nie takt::nietakt
::nie ubezpieczony::nieubezpieczony
::nie ustępliwy::nieustępliwy
::niewarto::nie warto
::niewiadomo::nie wiadomo
::niewszystkie::nie wszystkie
::nie wygodne::niewygodne
::nie wykonanie::niewykonanie
::nie zależnie::niezależnie
::nie zapłacone::niezapłacone
::nie zbyt::niezbyt
::nie zgodna::niezgodna
::nie źle::nieźle
::nie zły::niezły
::nie znajomy::nieznajomy
::nie zrobienie::niezrobienie
::nie zrobione::niezrobione
::nie zwłocznie::niezwłocznie
::Nikolii::Nikoli
::nisko słodzony::niskosłodzony
::nisz::niż
::niuanze::niuanse
::ocean atlantycki::Ocean Atlantycki
::Ocean atlantycki::Ocean Atlantycki
::okres czasu::przedział czasowy
::okróchy::okruchy
::okróhy::okruchy
::okruhy::okruchy
::ołtasz::ołtarz
::ołtaż::ołtarz
::nószki::nóżki
::nórzki::nóżki
::nuszki::nóżki
::obtować::optować
::obu nóż::obunóż
::obydwuch::obydwu
::obrzarstwo::obżarstwo
::odrazu::od razu
::odbież::odbierz
::oddziaływuje::oddziałuje
::odemnie::ode mnie
::odkużacz::odkurzacz
::odpowieć::odpowiedź
::odpóst::odpust
::odświerzyć::odświeżyć
::odzierz::odzież
::odziwo::o dziwo
::oglondać::oglądać
::ogulnie::ogólnie
::ogólno dostępny::ogólnodostępny
::ogólno krajowe::ogólnokrajowe
::ogólno pojęte::ogólnopojęte
::ogurek::ogórek
::ochyda::ohyda
::OJOM::OIOM
::oka mgnienie::okamgnienie
::okarze::okaże
::okazi::okazji
::okrent::okręt
::okólary::okulary
::okólista::okulista
::ól::ul
::Oliwi::Oliwii
::ołuwek::ołówek
::on line::online
::opatrznie::opacznie
::noi::no i
::nonstop::non stop
::nosororzec::nosorożec
::nota bene::notabene
::nowo narodzony::nowonarodzony
::nowopowstały::nowo powstały
::nozdża::nozdrza
::norzyczki::nożyczki
::nóty::nuty
::obejżeć::obejrzeć
::obejrz::obejrzyj
::obiado kolacja::obiadokolacja
::obieży świat::obieżyświat
::obojniak::obojnak
::obrucić::obrócić
::obrut::obrót
::obrorza::obroża
::obserwóje::obserwuje
::obskórny::obskurny
::obsówa::obsuwa
::orzehy::orzechy
::ożechy::orzechy
::ożesz::ożeż
::o żesz::ożeż
::o żeż::ożeż
::opur::opór
::oportónista::oportunista
::oprucz::oprócz
::oprużnia::opróżnia
::orenżada::oranżada
::organiźmie::organizmie
::orginał::oryginał
::ortografi::ortografii
::orginalny::oryginalny
::ożeł::orzeł
::ośmio tysięczniki::ośmiotysięczniki
::osoba towarzysząca::Osoba Towarzysząca
::ostrorznie::ostrożnie
::osz ty::oż ty
::od tak::ot tak
::otusz::otóż
::owy::ów
::uwczesny::ówczesny
::pahnie::pachnie
::ponczek::pączek
::pamientnik::pamiętnik
::opini::opinii
::pantoflarz::pantoflaż
::paparacci::paparazzi
::papierz::papież
::paprykasz::paprykarz
::parafja::parafia
::parafi::parafii
::pare::parę
::partykóła::partykuła
::paruwka::parówka
::pażyć::parzyć
::pasarzer::pasażer
::pasha::pascha
::pasorzyt::pasożyt
::patrjota::patriota
::pacz::patrz
::paułza::pauza
::peh::pech
::pencherz::pęcherz
::pendy::pędy
::pendzel::pędzel
::peioratywna::pejoratywna
::pejzarz::pejzaż
::pejzasz::pejzaż
::pendrak::pędrak
::pieniondze::pieniądze
::piniondze::pieniądze
::pendrajw::pendrive
::pempek::pępek
::percepować::percypować
::perfuma::perfumy
::permamentny::permanentny
::peruga::peruka
::penseta::pęseta
::peżot::peugeot
::fotoshop::Photoshop
::piontek::piątek
::pionty::piąty
::picca::pizza
::pięć złoty::pięć złotych
::piegrza::piegża
::pienkny::piękny
::piepsz::pieprz
::pierorzek::pierożek
::pierszy::pierwszy
::pieżasty::pierzasty
::plastyk::plastik
::pluha::plucha
::plócha::plucha
::pienta::pięta
::piurnik::piórnik
::piuro::pióro
::piorón::piorun
::piróet::piruet
::piszonc::pisząc
::pizzernia::pizzeria
::plonsy::pląsy
::plarza::plaża
::pułciowy::płciowy
::pleps::plebs
::plemie::plemię
::pląba::plomba
::płutno::płótno
::plóskać::pluskać
::poco::po co
::po koleji::po kolei
::po lewo::po lewej
::po najmniejszej linii oporu::po linii najmniejszego oporu
::poraz::po raz
::podkoszulka::podkoszulek
::podłórzny::podłużny
::podłurzny::podłużny
::podłóżny::podłużny
::podrużnik::podróżnik
::podrurznik::podróżnik
::podrórznik::podróżnik
::pointa::puenta
::pokoji::pokoi
::poraz kolejny::po raz kolejny
::pobódka::pobudka
::pohopnie::pochopnie
::pocieha::pociecha
::poczym::po czym
::poddać w wątpliwość::podać w wątpliwość
::pod czas::podczas
::Podchale::Podhale
::podrząd::pod rząd (z rzędu)
::pojedyńczy::pojedynczy
::po jutrze::pojutrze
::póka::puka
::pokarze::pokaże
::pokuj::pokój
::po krótce::pokrótce
::polak::Polak
::półgodziny::pół godziny
::pułka::półka
::pół kolonie::półkolonie
::pułnoc::północ
::pomuż::pomóż
::pomusz::pomóż
::po nie wczasie::poniewczasie
::po nie w czasie::poniewczasie
::półtorej roku::półtora roku
::półtorej tygodnia::półtora tygodnia
::półtora godziny::półtorej godziny
::połuż::połóż
::po mału::pomału
::pomarańcz::pomarańcza
::pomażyć::pomarzyć
::po mimo::pomimo
::pomuc::pomóc
::pąpa::pompa
::ponad czasowy::ponadczasowy
::ponad dwuipółmiesięczny::ponaddwuipółmiesięczny
::poniewarz::ponieważ
::popołudniu::po południu
::poprostu::po prostu
::po proszę::poproszę
::po przez::poprzez
::po przytulać::poprzytulać
::poradnii::poradni
::pół światek::półświatek
::po za tym::poza tym
::pozatym::poza tym
::porarzony::porażony
::porzondek::porządek
::pożądek::porządek
::pożądnie::porządnie
::pożeczka::porzeczka
::póścić::puścić
::po środku::pośrodku
::post komunizm::postkomunizm
::post scriptum::postscriptum
::poszłem::poszedłem
::potenga::potęga
::potrzebował bym::potrzebowałbym
::potwur::potwór
::powarzny::poważny
::Powiat::powiat
::powiec::powiedz
::powierzchnii::powierzchni
::powieżyć::powierzyć
::powrut::powrót
::po za::poza
::porzar::pożar
::porzegnanie::pożegnanie
::puźno::późno
::prestisz::prestiż
::pruchno::próchno
::próhno::próchno
::prużny::próżny
::prórzny::próżny
::prurzny::próżny
::porzyczka::pożyczka
::porzyteczny::pożyteczny
::pijar::PR
::pra babcia::prababcia
::prasuwka::prasówka
::premi::premii
::prezęt::prezent
::pręrzyć::prężyć
::prezydęt::prezydent
::pruba::próba
::proh::proch
::proźba::prośba
::prosiont::prosiąt
::prosił bym::prosiłbym
::prostokont::prostokąt
::prostrze::prostsze
::prosze::proszę
::pruszy::prószy
::protokuł::protokół
::prucz::prócz
::pozur::pozór
::przerarzenie::przerażenie
::przeżutki::przerzutki
::przeżótki::przerzutki
::przerzótki::przerzutki
::przebuj::przebój
::przecierz::przecież
::pszecinek::przecinek
::przeczkolanka::przedszkolanka
::przeczówać::przeczuwać
::przedemną::przede mną
::przedewszystkim::przede wszystkim
::przeczkole::przedszkole
::przed wczoraj::przedwczoraj
::prze grupować::przegrupować
::przeklnąć::przekląć
::przekonywujący::przekonujący
::Pszemek::Przemek
::prze nigdy::przenigdy
::prze piękny::przepiękny
::przepiurka::przepiórka
::przeżucać::przerzucać
::przeżucić::przerzucić
::pszesłać::przesłać
::przestżeń::przestrzeń
::przezemnie::przeze mnie
::przymrórzyć::przymrużyć
::przymrurzyć::przymrużyć
::pszysłuwek::przysłówek
::pszysłówek::przysłówek
::psałtesz::psałterz
::psałteż::psałterz
::pujdę::pójdę
::pufa::puf
::pódełko::pudełko
::puhar::puchar
::puhacz::puchacz
::póch::puch
::przenica::pszenica
::przczoła::pszczoła
::psycholorzka::psycholożka
::psyhika::psychika
::PS.::PS
::przywieść::przywieźć
::pszytulić::przytulić
::przyżekać::przyrzekać
::pszypadek::przypadek
::pszymiotnik::przymiotnik
::przyczepa kampingowa::przyczepa kempingowa
::przyhodnia::przychodnia
::przyczym::przy czym
::pszodek::przodek
::przerzuwać::przeżuwać
::quasieksperyment::quasi-eksperyment
::quasi eksperyment::quasi-eksperyment
::rahunek::rachunek
::rachónek::rachunek
::rahónek::rachunek
::puki co::póki co
::pósty::pusty
::pószka::puszka
::puzle::puzzle
::pyha::pycha
::quazi::quasi
::kuiz::quiz
::rombać::rąbać
::ramonezka::ramoneska
::randevu::rendez-vous
::rencznik::ręcznik
::rege::reggae
::regóła::reguła
::rechabilitacja::rehabilitacja
::renka::ręka
::rekonwalestencja::rekonwalescencja
::religi::religii
::remament::remanent
::remedióm::remedium
::remąt::remont
::ręta::renta
::restałracja::restauracja
::resteuracja::restauracja
::rużne::różne
::rurzne::różne
::rórznica::różnica
::rurznica::różnica
::rużnica::różnica
::rozpróć::rozpruć
::rospruć::rozpruć
::reportarz::reportaż
::rezerwój::rezerwuj
::rodzaji::rodzajów
::rok dwutysięczny dwudziesty::rok dwa tysiące dwudziesty
::romantyźmie::romantyzmie
::rosuł::rosół
::równierz::również
::rurza::róża
::rozbież::rozbierz
::różczka::różdżka
::rożno::rożen
::ruzga::rózga
::rozjószyć::rozjuszyć
::roskosz::rozkosz
::różno kolorowe::różnokolorowe
::rozpręrzenie::rozprężenie
::rozumię::rozumiem
::rozumisz::rozumiesz
::rubiesz::rubież
::rubierz::rubież
::ruh::ruch
::róch::ruch
::róh::ruch
::rysz::ryż
::ryrz::ryż
::rozżąd::rozrząd
::róbin::rubin
::róbryka::rubryka
::ródy::rudy
::rókiew::rukiew
::róstykalny::rustykalny
::ryź::ryś
::rysónek::rysunek
::rząt::rząd
::żadko::rzadko
::rzadne::żadne
::żądy::rządy
::żądzić::rządzić
::rzeby::żeby
::żeczy::rzeczy
::żeka::rzeka
::żekomo::rzekomo
::żemień::rzemień
::żemyk::rzemyk
::żepa::rzepa
::żęsisty::rzęsisty
::rzęrzenie::rzężenie
::żężenie::rzężenie
::żeźko::rześko
::rzensy::rzęsy
::żewny::rzewny
::żęzić::rzęzić
::żerzucha::rzeżucha
::żodkiewka::rzodkiewka
::rzreć::żreć
::rzul::żul
::żut::rzut
::żutnik::rzutnik
::rrzy::rży
::żygać::rzygać
::rzymsko katolicki::rzymskokatolicki
::samochud::samochód
::samo zatrudnienie::samozatrudnienie
::senatorium::sanatorium
::sanepit::sanepid
::sawuar wiwr::savoir-vivre
::zcharakteryzować::scharakteryzować
::shiza::schiza
::shizma::schizma
::schizofremia::schizofrenia
::dr::doktor
::jw.::jak wyżej
::mgr::magister
::m.in.::między innymi
::shody::schody
::ścielać::ścielić
::selfi::selfie
::semp::sęp
::serji::serii
::serwós::serwus
::sęs::sens
::sexi::sexy
::zfinalizować::sfinalizować
::szejk::shake
::sie ma::siema
::siudemka::siódemka
::z kąd::skąd
::skąd inąd::skądinąd
::skarrzyć::skarżyć
::zkontaktować::skontaktować
::skura::skóra
::skożystam::skorzystam
::skrut::skrót
::tj.::to jest
::ww.::wyżej wymieniony
::p.::punkt
::pkt::punkt
::sms::SMS
::spadać w dół::spadać
::skrzynii::skrzyni
::skówka::skuwka
::ślizgo::ślisko
::słuj::słój
::Słoweni::Słowenii
::słowianie::Słowianie
::ślup::ślub
::smarzalnia::smażalnia
::smarzyć::smażyć
::śmię::śmiem
::śmingus-dyngus::śmigus-dyngus
::sujka::sójka
::sokuł::sokół
::sul::sól
::somelier::sommelier
::somsiad::sąsiad
::sądarz::sondaż
::Sp. z o.o.::sp. z o.o.
::ślób::ślub
::spadać w dół::spadać
::spagetti::spaghetti
::spend::spęd
::spichlesz::spichlerz
::spichleż::spichlerz
::śpieszyć::spieszyć
::z pod::spod
::zpod::spod
::spokuj::spokój
::spułgłoska::spółgłoska
::z pośród::spośród
::spowrotem::z powrotem
::zpowrotem::z powrotem
::z poza::spoza
::spuźnienie::spóźnienie
::sporzyć::spożyć
::spraj::spray
::sprajt::sprite
::sprubuje::spróbuje
::z przed::sprzed
::zprzed::sprzed
::sprzedarz::sprzedaż
::sprzent::sprzęt
::sprzęrzenie::sprzężenie
::spszęrzenie::sprzężenie
::średniozaawansowany::średnio zaawansowany
::Średniowiecze::średniowiecze
::śróbokręt::śrubokręt
::śróbokrent::śrubokręt
::śrubokrent::śrubokręt
::staluwka::stalówka
::standart::standard
::starczy::wystarczy
::starorzytność::starożytność
::starószka::staruszka
::status kwo::status quo
::stępel::stempel
::starzysta::stażysta
::ztęsknić::stęsknić
::sto gram::sto gramów
::stoji::stoi
::stujka::stójka
::stuł::stół
::stupki::stópki
::stuwa::stówa
::strikte::stricte
::struż::stróż
::strórz::stróż
::strurz::stróż
::stróga::struga
::strómień::strumień
::struszka::strużka
::strórzka::strużka
::stróżka::strużka
::szczelać::strzelać
::sczelać::strzelać
::stszykafka::strzykawka
::stódia::studia
::studii::studiów
::stu dniówka::studniówka
::stwur::stwór
::sóbiektywny::subiektywmy
::subskrybcja::subskrypcja
::szfagier::szwagier
::sufrarzystka::sufrażystka
::super cena::supercena
::sórdut::surdut
::surdót::surdut
::surealizm::surrealizm
::suszi::sushi
::swetr::sweter
::świerzak::świeżak
::świeszp::świerzb
::świeżb::świerzb
::święta Wielkanocne::Święta Wielkanocne
::świenty::święty
::świeżomalowany::świeżo malowany
::świerzy::świeży
::swuj::swój
::Sylwi::Sylwii
::champagne::szampan
::szantarz::szantaż
::szapo ba::chapeau bas
::szczegułów::szczegółów
::szczeże::szczerze
::szczeżyć::szczerzyć
::szczerzuja::szczeżuja
::szłem::szedłem
::Szekspir::Sheakspare
::szlahta::szlachta
::szlauf::szlauch
::szusty::szósty
::Sztokcholm::Sztokholm
::szómi::szumi
::szfagier::szwagier
::szwecki::szwedzki
::szfy::szwy
::szypko::szybko
::takto::tak to
::tajbrek::tie-break
::tajemnica polisznela::tajemnica poliszynela
::tak czyowak::tak czy owak
::tależ::talerz
::tamtendy::tamtędy
::tatuator::tatuażysta
::tchurz::tchórz
::tencza::tęcza
::tej że::tejże
::textowo::tekstowo
::tele obiektyw::teleobiektyw
::temperuwka::temperówka
::terz::też
::tłómaczenie::tłumaczenie
::toważysz::towarzysz
::tózin::tuzin
::trąpka::trąbka
::tranzakcja::transakcja
::tręd::trend
::trujkąt::trójkąt
::trójkont::trójkąt
::tród::trud
::tródne::trudne
::truht::trucht
::tróizm::truizm
::trwać nadal::kontynuować
::trworzyć się::trwożyć się
::tryumf::triumf
::tszcina::trzcina
::trzcionka::czcionka
::tszeba::trzeba
::trzebaby::trzeba by
::tszmiel::trzmiel
::tszpiotka::trzpiotka
::trzy letni::trzyletni
::tszymać::trzymać
::tżymać::trzymać
::tudziesz::tudzież
::thuja::tuja
::tuleji::tulei
::tółuw::tułów
::tórlać::turlać
::twojim::twoim
::twuj::twój
::twojom::twoją
::twoji::twoi
::twórca bloga::twórca blogu
::twożywo::tworzywo
::tych że::tychże
::tymbardziej::tym bardziej
::tym czasem::tymczasem
::umnie::u mnie
::unas::u nas
::uhwalić::uchwalić
::udeżać::uderzać
::ugryść::ugryźć
::ukojić::ukoić
::ukrucić::ukrócić
::uledz::ulec
::ułuż::ułóż
::umią::umieją
::umię::umiem
::umożenie::umorzenie
::umżeć::umrzeć
::upakarzać::upokarzać
::upowarznienie::upoważnienie
::uprzejmię::uprzejmie
::urusł::urósł
::urząd skarbowy::Urząd Skarbowy
::uspakajać::uspokajać
::uspokuj się::uspokój się
::usóń::usuń
::usówać::usuwać
::uwarzać::uważać
::uwdzie::ówdzie
::urzywać::używać
::viceversa::vice versa
::wizawi::vis-a-vis
::Woldzwagen::Volkswagen
::w cudzysłowiu::w cudzysłowie
::we czwartek::w czwartek
::wdodatku::w dodatku
::w każdym bądź razie::w każdym razie
::w koloże::w kolorze
::wkońcu::w końcu
::wmiędzyczasie::w międzyczasie
::wogóle::w ogóle
::w oka mgnieniu::w okamgnieniu
::w pół do::wpół do
::wpoprzek::w poprzek
::wporządku::w porządku
::w przed dzień::w przeddzień
::w sęsie::w sensie
::wskład::w skład
::w skutek::wskutek
::wsumie::w sumie
::w tę i we w tę::wtę i wewtę
::w tedy::wtedy
::w Zakopanym::w Zakopanem
::wzamian::w zamian
::wachać::wahać
::wahlarz::wachlarz
::wahlasz::wachlarz
::wachlasz::wachlarz
::wąhać::wąchać
::wachacz::wahacz
::wajha::wajcha
::vacat::wakat
::walętynka::walentynka
::Walentynki::walentynki
::Warszawiak::warszawiak
::ważywa::warzywa
::wonski::wąski
::watacha::wataha
::waszka::ważka
::warzka::ważka
::wbród::w bród
::wciąż kontynuuje::kontynuuje
::wczesno poranny::wczesnoporanny
::wdrorzyć::wdrożyć
::w wtorek::we wtorek
::wendka::wędka
::wedłóg::według
::łykend::weekend
::weganem::weganinem
::wengiel::węgiel
::velfon::wenflon
::wernisarz::wernisaż
::wernisasz::wernisaż
::wersii::wersji
::weś::weź
::weznę::wezmę
::wuef::WF
::łyski::whisky
::wihura::wichura
::wideo::video
::widzi mi się::widzimisię
::wiencej::więcej
::wieczur::wieczór
::wielka sobota::Wielka Sobota
::Wielka sobota::Wielka Sobota
::wielki piątek::Wielki Piatek
::Wielki piątek::Wielki Piatek
::wieżba::wierzba
::wieżgać::wierzgać
::wieszchołek::wierzchołek
::wiewiurka::wiewiórka
::wieża Ajfla::wieża Eiffla
::wifi::wi-fi
::wigilja::wigilia
::wichajster::wihajster
::Wikingowie::wikingowie
::Wiktori::Wiktorii
::wilczór::wilczur
::winogron::winogrono
::wiur::wiór
::wirasz::wiraż
::wirarz::wiraż
::wkródce::wkrótce
::włanczam::włączam
::włonczyć::włączyć
::włuczęga::włóczęga
::włuczka::włóczka
::włodasz::włodarz
::włukno::włókno
::włorzyć::włożyć
::wnók::wnuk
::wudka::wódka
::wojarze::wojaże
::Województwo Mazowieckie::województwo mazowieckie
::wujt::wójt
::wur::wór
::w okół::wokół
::wuzek::wózek
::wpełni::w pełni
::w pół żywy::wpół żywy
::wrarzenia::wrażenia
::wrarzenie::wrażenie
::wrazie::w razie
::w reszcie::wreszcie
::wrubel::wróbel
::wrug::wróg
::wrużka::wróżka
::wrórzka::wróżka
::wruszka::wróżka
::wżawa::wrzawa
::wżeciono::wrzeciono
::wścipski::wścibski
::wskurać::wskórać
::współ lokatorka::współlokatorka
::w śród::wśród
::wstał byś::wstałbyś
::wstąrzka::wstążka
::wsówać::wsuwać
::wsówka::wsuwka
::wszechczasów::wszech czasów
::wrzędzie::wszędzie
::wrzystko::wszystko
::w ten czas::wtenczas
::wtrakcie::w trakcie
::wuala::voilà
::wójek::wujek
::wólkan::wulkan
::wybież::wybierz
::wydażenia::wydarzenia
::wyjontek::wyjątek
::wyklóć się::wykluć się
::wkrzykł::wykrzyknął
::wykrztałcenie::wykształcenie
::wyłanczać::wyłączać
::wymyśleć::wymyślić
::wynaleść::wynaleźć
::wynużyć::wynurzyć
::wypagadza się::wypogadza się
::wyposarzenie::wyposażenie
::wyrarzenie::wyrażenie
::wyrrznąć::wyrżnąć
::wyżucić::wyrzucić
::wysokolatający::wysoko latający
::wysokokwalifikowany::wysoko kwalifikowany
::wystszał::wystrzał
::wyszczał::wystrzał
::wyztrzał::wystrzał
::wyszłem::wyszedłem
::wytęrzyć::wytężyć
::wyłuzdany::wyuzdany
::wyrzej::wyżej
::wyrzerka::wyżerka
::wyrzywać::wyżywać
::wziąść::wziąć
::wziąć na tapetę::wziąć na tapet
::wzięłem::wziąłem
::wzur::wzór
::wzrószenie::wzruszenie
::wzwysz::wzwyż
::skolei::z kolei
::z nad morza::znad morza
::z na przeciwka::z naprzeciwka
::z nie nacka::znienacka
::z powarzaniem::z poważaniem
::spowodu::z powodu
::pod rząd::z rzędu
::z tąd::stąd
::z tamtąd::stamtąd
::za wyjątkiem::z wyjątkiem
::z za::zza
::zabardzo::za bardzo
::zagranicą::za granicą
::za nadto::zanadto
::zaniedługo::za niedługo
::zapóźno::za późno
::za tem::zatem
::zawiele::za wiele
::rzaba::żaba
::rzabot::żabot
::zachaczyć::zahaczyć
::zahłysnąć::zachłysnąć
::zachud::zachód
::zachrystia::zakrystia
::zaczoł::zaczął
::zaczęłem::zacząłem
::rządać::żądać
::rządanie::żądanie
::rzaden::żaden
::rządło::żądło
::zadrrzeć::zadrżeć
::rzagiel::żagiel
::zagwostka::zagwozdka
::zajonc::zając
::zajżeć::zajrzeć
::rzakiet::żakiet
::rzal::żal
::zalerzy::zależy
::rzałosne::żałosne
::ubrać kurtkę::założyć kurtkę
::zamrarzarka::zamrażarka
::Rzaneta::Żaneta
::zanużyć::zanurzyć
::zararzać::zarażać
::za razem::zarazem
::rzargon::żargon
::rzart::żart
::zarzyć::zażyć
::zasłurzyć::zasłużyć
::zasłóżyć::zasłużyć
::zaspakajać::zaspokajać
::za sponsorować::zasponsorować
::zastompić::zastąpić
::zastszerzenie::zastrzeżenie
::zasówka::zasuwka
::zaszczyk::zastrzyk
::zato::za to
::zawali droga::zawalidroga
::za wczasu::zawczasu
::zawieruha::zawierucha
::zarzenowany::zażenowany
::rzbik::żbik
::zbiur::zbiór
::zczytać::sczytać
::zdąrzą::zdążą
::zdażyć::zdarzyć
::zdaża::zdarza
::zdjołem::zdjąłem
::zdjełem::zdjąłem
::zdjencie::zdjęcie
::zdruj::zdrój
::dźbło::źdźbło
::zemną::ze mną
::rzebrać::żebrać
::zemby::zęby
::gel::żel
::rzel::żel
::rzenada::żenada
::rzeński::żeński
::rzerowisko::żerowisko
::zeruwka::zerówka
::zespuł::zespół
::zeszło roczny::zeszłoroczny
::żetelne::rzetelne
::starkować::zetrzeć
::zef::zew
::zgnite::zgniłe
::z goła::zgoła
::shańbiony::zhańbiony
::ziemii::ziemi
::zjerzdżać::zjeżdżać
::zjerzyć::zjeżyć
::zkąd::skąd
::rzłobek::żłobek
::złodzieji::złodziei
::złorzone::złożone
::zmenczenie::zmęczenie
::zmieżch::zmierzch
::zmieszch::zmierzch
::rzmija::żmija
::rzmudny::żmudny
::żmódny::żmudny
::znaleść::znaleźć