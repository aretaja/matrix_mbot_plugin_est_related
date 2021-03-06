package Mbot::Plugins::Solva;
use strict;
use warnings;

use List::Util 'shuffle';
use Encode;

our $VERSION = '0.2';

=head1 NAME

Mbot::Plugins::Solva - Simple Mbot insult plugin

=head1 METHODS

=head2 parse - input parser

Responds random insult.
Insults source L<https://github.com/mth/hirc/blob/master/insult.txt>

       $result = parse($self->in);

=cut

sub parse
{
    my ($self, $in) = @_;

    return 'solva [name] - teeb tuju halvaks'
      if ($in->{msg} && $in->{msg} eq 'help');

    if ($in->{msg} && $in->{msg} =~ m/^solva\s*(.*)?\s*/)
    {
        my $user = $1 || $in->{dname};
        my @frases = (
            '%%: sa oled loll nagu lauajalg.',
            'Tead %%, mine osta õige üks tükk seepi.',
            'Erikuradikinomees sa %% oled, reede õhta ircus!',
            '%%: sa oled üks plekist persega vedruvasikas.',
            '%%: käi jala.',
'%%, sa vana pede, sinu kohta on artikkel: http://www.%%.isgay.com/',
            '%%: kalla end piimaga üle ja pane traktori kõrval põlema.',
'Oh püha perse kiriku laes, kuskohas küll %% suguseid produtseeritakse.',
            '%%: sina mine perse ja jäägi sinna.',
'%%: vabanda, kui ma sind kuidagi solvasin. See juhtus täiesti tahtlikult.',
'%%: ma ei saa aru, kuidas päike küll sinu peale paistes oksendama ei hakka.',
'%%: tra küll, kui mina sinu moodi välja näeks, ei julgeks ma ilma maskita väljagi minna',
            '%%: ma ei näe su silmis mõistusehelki.',
            '%%: kes küll sinusugusele ajukääbikule kirjakunsti õpetas?',
            '%%: sina, sitavikat, ime kella!',
            '%%: kas see on su nina, või kasvatad endale kolmandat kätt?',
            '%%: mina olen blond, aga mis sinu vabandus on?',
            '%%: kuidas Sulle kõrvaltvaatajana inimsugu tundub?',
'%%: sina ja inetu? Sa ei ole inetu, sa oled lihtsalt ... äh kuradile, Sa oled inetu. Sitaks inetu. Ja paks ka. Ja kiilakas.',
            '%%: mitu korda ma pean vett tõmbama, et sa ära kaoksid?',
            '%%: oled sa alati nii loll või on sul lihtsalt blond hetk??',
            'K: Mida ütles jumal, kui ta %% tegi? V: Oh shit!',
'K: Kui "Empire State Building"-i katuselt kukuvad alla paks neeger ja %%, siis kumb jõuab alla esimesena? V: Pole valge mehe asi.',
            'K: Mis on %% jaoks pikk ja raske? V: Algkool',
            '%% pole just karbi kõige kirkam kriit',
'%%: sa oled erakordselt sita väljanägemisega. On see mingi uus trend?',
            '%%: kumb meist nüüd mürki peaks võtma?',
            '%%: mõni küla on sinu pärast praegu ilma lollita.',
            '%%: on see kitsehabe või on tuvid su lõua täis sittunud?',
            '%%: palun seisa allatuult.',
            '%%: sae pekki.',
            '%%: Ah keri pekki',
'Kuule %%, sina kõdunenud kammeljas, sina mädanenud mudakukk, sina solgitud särg, mine osta omale õng.',
            '%%: näri muru!',
            '%%: kes sinusugusele kulendile suu andis?',
            '%%: tead mis, PANE ENNAST PÕLEMA!',
'%%: söö sitta! (miljardid kärbsed ei saa ju ometi valel teel olla)',
            '%%: sa näed välja nagu keedetud kaheksajalg',
            '%%: sa oled meditsiiniline ime',
'%%: sa näed ikka vahva välja! See kleit su seljas on pilapoest, eks?',
            '%%: kao eemale! Sa seisad mu aura peal!',
'%% on mees, kes ei tee palju sõnu. Aga möliseb ikkagi rohkem kui vaja.',
            '. o O ( Kus on geenipolitsei? Siin on mingi jälk %% ) O o .',
'. o O ( Millise kivi alt küll sellised lontrused nagu %% välja ronivad.. ) O o .',
            '%%: kes ma Sinu arust olen? Kärbsepaber idiootidele?',
'%%: on Sul minut aega? Räägi mulle ära kõik, mida Sa üldse tead.',
            '%% on nii loll, et sobiks ideaalselt Võrno saatesse',
'%%: Su jutt kõlab nagu eesti keel, aga ma ei saa mitte halligi aru.',
'%%: kõik mu eelarvamused Sinu suhtes on ajapikku tõeks osutunud.',
            '%%: ilmselgelt on ainuke lahendus sinu probleemile suitsiid.',
'%%: see et keegi sind ei mõista, ei tähenda veel et oled kunstnik.',
'%%{: Sa varud| varub} ilmselt alati spetsiaalselt aega, et end avalikus kohas lolliks teha.',
'%%: Kuuldavasti oli sul kunagi yks mõte, aga see suri yksinduse kätte ära.',
            '%%: Ma vihkan kõiki. Sina oled järgmine.',
            '%%: Ja sinu täiesti mõttetu arvamus on...?',
            '%%: Pista pea perse ja tee porgandi häält.',
'%%: Kas sa nüüd taipad, mis juhtub kui sugulased omavahel abielluvad?',
            '%%: Maakeral ei ole enam ruumi. Mine koju.',
            '%%: Mine hoia oma pead vee all.',
'Isegi lollide maailmameistrivõistlustel saaks %% teise koha, kuna ta on lihtsalt niivõrd loll....',
            '%%: mine ära enne kui ma sind ümber lükkan.',
            'Näe, tõmbasin küll vett, aga %% ikka alla ei läinud.',
            'Miskit rõvedat pininat tuleb kusagilt. Aaa, see oled sina, %%!',
            'Tere %%! Kuidas viinaravi edeneb?',
'Vaene %%, kas sa jäid rongi alla või oledki sellisena sündinud?',
'%%: Piiblis on kirjas: "Juudas eemaldus ja läks ja poos end üles." Ja veel: "Mine tee sina samuti"',
            '%%, miks sa ei lase oma mõistust teritada?',
'%%, tee mulle üks teene - ära unusta koduteel vales kohas tänavat ületada.',
            '%%, mängime kodu, Sina oled uks ja mina löön su kinni.',
            '%%, lähme kusagile, kus me saaksime teineteisest lahus olla.',
'Ma ei unusta kunagi ühtegi nägu, aga %% puhul olen ma valmis erandi tegema.',
            '%%, vaata, rong läheneb! Roni rööbastele!',
'%%, Sul on väga huvitav nägu, mitu korda Sind sinna löödud on?',
'%%, mängime hobust. Mina olen esimene ots ja sina võid lihtsalt iseennast mängida.',
            '%% nalju tervitab alati suur vaikusepahvak.',
'Ahv heitis %%-le ühe pilgu ning karjus: "Persse see Darwini teooria - mina endast inimest teha ei lase!"',
'Peab tunnistama, et %% sugused mehed ei kasva puu otsas - nad ripuvad okste küljes.',
            'Kas tõesti on sõnade helge pea ja %% vahel nii suur erinevus?',
            '%% on nagu lauaga löödud. Ja mitte ainult vastu rindu',
            'Vaata %%. Ilmne tõestus, et hullari aed on liiga madal.',
'Mõistuse pooles on %%-le kõige lähemal reha ... või äärmisel juhul labidas',
'%%, kas sa nüüd taipad, mis juhtub, kui sugulased omavahel abielluvad?',
            '%%, ma suudan vaevu oma ükskõiksust vaos hoida',
            '%%, sa tuled tuttav ette. Lahkasin sind vist zooloogiatunnis?',
            'Kui mind huvitaks su arvamus, %%, siis ütleksin, milline see on.',
'Sinuga dringile, %%? Pigem teen endale ise tuimestuseta pimesooleoperatsiooni.',
            '%%, kas sulle tundub, et ma vajan seltskonda?',
            'Hei, sina, %%! Kao mu planeedilt minema!',
            '%%, ja sinu tattnina-arvamus on...?',
'%%, ma ei ole tige. Olen lihtsalt juba {1|2|3|4}0 aastat väga halvas tujus.',
'%%, mis stiilis sa ka riietuda ei üritanud, välja see sul igastahes ei tulnud.',
            '%%, kas su koduplaneedil keegi kunagi vait ka on?',
            'Ma ei ole sinu tüüp, %%. Ma pole täispuhutav.',
            '%%, kao eemale! Sa seisad mu aura peal.',
            '%%: Ära muretse. Ma ei mäleta sinu nime ka.',
            '%%, ma tahan lihtsalt kätte maksta. Mis selles halba on?',
            '%%, naerata{, kummarda|} ja ütle: "Jah, mu käskija."',
'%%, kas ma mainisin, et kui sa {mind puudutad|minuga räägid}, saad kohe jalaga munadesse?',
            '%%, sa näed erakordselt sitt välja. On see mingi uus trend?',
            '%%, kumb meist nüüd rohtu peaks võtma?',
            '%%: Kuidas seda laserkaardikeppi taparežiimile lülitatakse?',
            'Ja milline seitsmest pöialpoisist sina, %%, oled?',
'%%: Ma sorisin küll kaltsupoes, aga seda hilpu ma seal küll ei näinud',
            'Kus on geenipolitsei? Siin on mingi mutant, kes kasutab nime %%.',
'%%, küll sa näed ikka vahva välja. See kleit on sul pilapoest, eks?',
            '%%, muidugi on ka meestel tunded. Aga keda see kotib?',
            'Ilus kleit, %%. Loodad alla võtta, et sellesse ära mahtuda?',
            'Parem ära mind vihasta %%. Mul hakkavad kirstud otsa saama',
            'Oi, kui kena raseda kleit %%. Sa polegi? Nojah ...',
            'Ma ei usu imesid, %%. Ma arvestan nendega',
            '%%, räägi siis ometi! Sul on õigus oma lollile arvamusele.',
            'Ma vihkan kõiki. Sina, %%, oled järgmine.',
            '%%, Ja sinu täiesti mõttetu arvamus on...?',
'%%: {Hoiatus:|Vaata ette --} mul on oma arvamus ja ma tean, kuidas seda kasutada.',
'%%: Miks kipuvad kinniste peadega inimesed alati suu lahti tegema?',
'Ma olen andekas mitmel alal, %%. Suudan ühteaegu rääkida ja sinu peale laias kaarest kusta.',
            'Ära hakka minuga plõksima, %%. Nagunii sa jagu ei saa.',
'Kuidas ma saangi sinust puudust tunda %%, kui sa kuidagi ära ei lähe?',
            '%%: Stress kasvab üle pea, aga kägistada pole kedagi.',
'%%, sina oled üks hirmus õnnetus, mis headele inimestele kaela kukub.',
            '%%, Sul on õigus vaikida. {Kasuta seda ometi|Nii et - OLE VAIT}!',
'Kui inimest toiduga võrrelda, siis sina, %%, oled {odav, maitsetu ja saad kiiresti valmis|Säästumarketis müügil}.',
'%%, kuuldavasti oli sul kunagi üks mõte, aga see suri üksinduse kätte ära.',
'%%, inetusvõistlusel oleks sulle vääriliseks vastaseks ainlt üleeilne okseloik.',
            '%%: Ma olen nii õnnelik, et võiksin tappa.',
            '%%, vabanda, kui tundus, et huvitad mind. Ei huvita.',
            '%%, su tänane meik on küll puhas raiskamine.',
            '%%, ma pole sinu tüüp. Mul on pulss.',
'%%, ma ei tea, mis viga sul küljes on, aga kindlasti on see raskesti hääldatava diagnoosiga.',
'%%, mida ma küll sinuta pihta hakkaksin? Peale selle, et oleksin õnnelik.',
            'Palun räägi edasi, %%. Ma tahan magada.',
            '%%, jah, see on noku moodi küll, aga palju väiksem.',
            'Sina, %%, oled vist palju Bushi kõnesid kuulanud?',
'%%: Mulle meeldib su lähenemine.  Nüüd näita, kuidas sa kaugened.',
'Sul, %%, käis üks mõte peast läbi?  See pidi vast pikk ja üksildane teekond olema.',
'Kuule, %%, mine õige {Meerika Ase-Resi-Tondiga|Ameerika asepresidendiga} pardijahile.',
'kas su vanemad tõesti vihkasid sind niipalju et %% sulle nimeks panid või astusid enesevihkajate klubisse ja võtsid omale sellise nime ?:)',
            'nimesid nimetamata aga %% on ikka paras ajukääbik küll',
'Sa meeldid mulle %%. Inimesed küll ütlevad, et mul ei ole maitset, aga sa meeldid mulle.',
            '%%: Ära hakka minuga plõksima. Nagunii sa jagu ei saa.',
            '%%: ära täna mind su solvamise eest. Seda oli nauding teha.',
            '%%: ära tunne ennast halvasti. Paljudel inimeste ei ole talenti.',
            '%%: ehk oled kunagi iluoperatsioonile mõelnud ?',
            '%%: Hei, sina! Kao mu planeedilt minema!',
            '%%: Hoiatus: mul on oma arvamus ja ma tean, kuidas seda kasutada.',
            '%%: Huvitav, miks tulnukad sulle pärakusse sondi jätsid?',
            '%%: Ideaalne aeg hakata kadunud inimeseks.',
            '%%: Ilus kleit. Loodad alla võtta, et sellesse ära mahtuda?',
            '%%: Ilus raseda kleit, sünnitad sa varsti?',
            '%%: ime kanni!',
'%%: Inetusvõistlusel oleks sulle vääriliseks vastaseks ainlt üleeilne okseloik.',
            '%%: Jah, see on noku moodi küll, aga palju väiksem.',
            '%%: Ja milline seitsmest pöialpoisist sina oled?',
'%%: ja mina mõtlesin maailma koledaim inimene küll siia ei juhtu...',
            '%%: käi jala.',
'%%: kaos, paanika, korralagedus - sinu töö on siin edukalt tehtud.',
'%%: kas ma mainisin, et kui sa mind puudutad, saad otsekohe jalaga munadesse?',
            '%%: kas sa käid ilusalongis tagavaraväljapääsu kaudu?',
            '%%: Kas su koduplaneedil keegi kunagi vait ka on?',
            '%%: Kas sulle tundub, et ma vajan seltskonda?',
            '%%: kui aju oleks vihm, siis sina oleks kõrb.',
'%%: Kuidas ma saangi sinust puudust tunda, kui sa {kuidagi|kunagi} ära ei lähe?',
            '%%: Kuidas seda laserkaardikeppi taparežiimile lülitatakse',
'%%: Kui inimest toiduga võrrelda, siis sina oled odav, maitsetu ja saad kiiresti valmis.',
'%%: kui ma luban, et igatsen su järele, kas sa siis läheksid ära?',
'%%: kui ma peaks tapma kõik kes sind vihkavad, siis see ei oleks mõrv...   ...see oleks genotsiid.',
'%%: kui ma vajaks aju, siis ma võtaks sinu oma, sest seda ei ole kunagi kasutatud.',
'%%: kui mu koeral oleks selline nägu nagu sul, siis ma raseeriks ta tagumiku ja õpetaks ta tagurpidi käima.',
            '%%: kui mul oleks vaja lonti saada, mõtleksin ma sinu peale',
'%%: Küll sa näed ikka vahva välja. See kleit on sul pilapoest, eks?',
            '%%: kumb meist nüüd rohtu peaks võtma?',
            '%%: Kus on geenipolitsei? Siin on mingi mutant.',
'%%: Kuuldavasti oli sul kunagi üks mõte, aga see suri üksinduse kätte ära.',
'%%: ma annaks sulle ühe mõtte, aga ma ei ole kindel, kas sul on panna seda kuskile.',
            '%%: ma austan mulda, mis sind ootab.',
            '%%: Ma ei ole sinu tüüp. Ma pole täispuhutav.',
'%%: ma ei tea mis sind nii lolliks teeb, aga see tõesti töötab.',
'%%: Ma ei tea, mis viga sul küljes on, aga kindlasti on see raskesti hääldatava diagnoosiga.',
'%%: ma ei unusta ühtegi nägu, aga sinu puhul tahaks küll erandi teha',
            '%%: Ma ei usu imesid. Ma arvestan nendega',
'%%: ma küsiks kui vana sa oled, aga ma tean, et sa ei tunne nii suuri numbreid.',
'%%: Ma kuulsin, et läksid ajuuuringutele, aga arstid ei leidnud sealt midagi.',
'%%: mängime hobust. Mina olen esimene pool ja sina {oled sina ise|võid lihtsalt iseennast mängida}.',
'%%: ma tõesti ei arva, et sa oled loll, aga mis minu arvamus loeb tuhandete teiste vastu.',
'%%: ma tuleks meelsasti sinuga kohtama, aga mu lemmik reklaam on praegu telekas.',
            '%%: milline darwini auhind sulle kuulus ?',
            '%%, muidugi on ka sinul tunded. Aga keda see kotib?',
'%%: mul on kiire praegu, võin ma sind mõni teine kord ignoreerida?',
            '%%: Naerata ja ütle: "Jah, mu käskija."',
            '%%: Näri leiba!',
            '%%: nii-nii. Jälle on tsirkusest paar klouni putku pannud.',
            '%%: oled sa alati nii loll või pingutad täna eriti selle nimel?',
            '%%: oled sa TONT või Inimene ?',
            '%%: on need sinu silmamunad, mis ma oma dekolteest leidsin?',
            '%%: on see su nina või sööd sa banaani?',
            '%%: Parem ära mind vihasta. Mul hakkavad kirstud otsa saama',
            '%%: sa ei ole paranoik. Kõik vihkavad sind tõesti.',
            '%%: sa ei saa iialgi nii vanaks kui välja näed.',
'%%: sa ei tea sõna "hirm" tähendust. Aga kui järele mõelda, siis sa ei tea enamuse sõnade tähendust.',
            '%%: sa oled loll kui leivaauto.',
'%%: sa oled nii kole, et kui ma su loomaaeda viisin, siis talitaja ütles: "Tänan, et ta tagasi tõite."',
'%%, sul on nii inetu nägu, et see trükiti {lennukite|Ryanair} oksekottidele.',
'%%: sa oled nii kole, et su pilt trükiti {lennukite|Ryanair} oksekottidele.',
'%%: sa oled täpselt nagu Action Man: Kandiline soeng, armiline nägu ja püksis mitte midagi.',
            '%%: sa tõendad seda, et isegi jumal eksib vahest.',
'%%: see, kui keegi sind ei mõista, ei tähenda veel, et sa oled kunstnik,',
'%%: sind tehes läks Loojal vist küll vorm katki. Ja mõned nurgad jäid ilmselt maha kraapimata.',
'%%: Sinuga dringile? Pigem teen endale ise tuimestuseta pimesooleoperatsiooni.',
'%%: sinu lolliks nimetamine on solvang kõigile teistele lollidele.',
'%%: sinu nõuannet ma küll ei vaja. Sa ei oska ju kahekümne ühenigi lugeda, kui sa alasti pole.',
            '%%, Sul on nii ilusad kõverad jalad',
            '%%: tavaliselt inimesed elavad ja õpivad. Sina ainult elad.',
            '%%: tunne end nagu kodus. Korista mu köök ja WC ära.',
'%%: üldiselt ma ei taha küll kellegi kohta sitasti öelda aga sina oled ikka tõsiselt räige',
            '%%: võin ma sinult su nägu laenata, mu tagumik on puhkusel.',
            '%%: pane müts pähe.. rähn lendab',
            'Kuule %%, oled sa mingi Transport Object Assembler?',
            'Võiks arvata, et %% on {mingi|mõni} Konfiguratsioon.',
            '%% on topis nagu mingi java.',
            '%%: sinuga läheks luurele küll, aga tagasi tuleksin üksi',
'Ettevaatust: %% võib pikaajalisel tarvitamisel pöördumatult kahjustada teie tervist',
            'Mis on selle vaimuhaiguse nimi, mille põdeja tõi %% ilmale?',
            'Põrgusse see %%, pigem närin endal pea otsast',
            '%% puhul on igasuguste teotuste väljamõtlemine mõttetu',
            '%%, häda on tulnud maale koos sinuga!',
            '%%: Kas sulle tundub, et ma vajan seltskonda?',
            'Võrreldes %% õudusega on Cthulhu nagu pehme kiisupoeg',
            'Mis kuradi käkk see %% {sihuke|selline} on?',
'%% meeldib mulle. Inimesed ütlevad, et mul puudub igasugune maitse, aga mulle ta meeldib.',
            'rattaletõmbamise võiks asendada %% kasutamisega',
            'mullast on %% tulnud ja mullaks peab ta ka saama',
'%%: tahaks sulle vastu hambaid anda aga miks peaksin ma su välimust parandama?',
            '%% peal lasub vaaraode needus',
            'peaga vastu seina peksmine on meeldivam kui %%',
'%% kui ohtlik psühholoogiline relv tuleks Genfi konventsiooniga keelustada',
            '%%: oled sa alati nii loll või on sul lihtsalt blond hetk?',
            '%% on nagu heroiin: korra proovid, igaveseks jama kaelas',
            '%%, siin on sulle Statoili kinkepakk, tarvita julgelt',
            '%%: kas sa oled alati nii loll või on täna mingi eriolukord?',
            'ma ei tea, mis %% nii lolliks teeb, aga igatahes see mõjub',
            '%%: mitu korda ma pean vett tõmbama, et sa ära kaoksid?',
            '%%, ükskord viid sa mu hauda!',
            '%%: ja mis on sinu olemasolu õigustus?',
            '%% on vajalik nagu ürask männile',
            '%%: sinu pilt on preservatiivipakkidel hoiatava näitena',
            '%% vanematest oli väga vastutustundetu keppida',
            '%% näeb pimedas palju parem välja',
            '%%: sina pede mine tagasi munni imema',
            '%% võiks oma vinnid ära pigistada enne mölisemist',
            '%%, kas sul tuld on? Siis pane end põlema.',
            'isegi %% psühhiaater keeldub teda kuulamast',
            '%%: ma ei mäleta su nime, luba ma kutsun sind perseussiks?',
            'miks %% mütsi perse peal kannab?',
            '%% on nii kole, et isegi kärbestel läheb süda pahaks',
            '%% on jälle eksinud nagu sõrm seedekulglasse',
            '%% ei saa kunagi nii kõvaks meheks kui ta ema oli',
'ma ei ole küll proktoloog, aga %% ajud on pärasoolega vahetusse läinud',
            '%%: kondoom peas on tõepoolest sulle sobiv riietus!',
            '%% on vormis - ümmargune on ka vorm.',
'%%: ema ütles sulle, et oled eriline, aga tegelikult oled sa lihtsalt loll',
            '%% on universumi loomulik hälve',
            '%% püstitas negatiivse IQ maailmarekordi',
            '%% on värske nagu munn saunas',
            '%% ei ole mitte homo vaid harilik pede',
            'kui mul oleks Tourette sündroom, siis %% põhjustaks hoogusid',
'%%: näed seda kasti? Värsti näed ainult natuke vasaku silmaga seda. Seestpoolt.',
            '%% on nagu emo, kes on zileti kaotanud',
            '%% aju on evolutsiooni jäänuk',
            '%%: mine kümme meetrit eemale, sa solgid mu aura ära.',
            'paistab, et %% vanemad ei osanud lapsi teha',
            'K: Mis on vahet %%-l ja ämbritäiel sital? V: Ämber.',
            '%%: õpi oma vanemate vigadest - kasuta kondoomi.',
'ma oleks %% isa, kui sada krooni poleks liiga palju olnud ta ema eest',
            '%%: mine varju - prügiauto tuleb',
            'loodus oli %% suhtes helde ainult 21. kromosoomi andes',
            '%%: ütle oma boyfriendile, et ta sulle rohkem suhu ei situks',
            'kas kevad on juba, et %% on lume alt välja sulanud?',
            'kas keegi peeretas või ütles %% midagi?',
            'enamus inimesi moodustab sõnadest lauseid - kuid %% on eriline',
            '%%: Sa käia oskad? Siis käi perse!',
            '%% vanemad kohtusid esimest korda suguvõsa kokkutulekul',
            'see, et %% jalge vahel midagi ripub ei tee temast veel meest',
            '%%: Kas sa põgenesid geneetikalaborist eile?',
            '%%: Sul on jälle päevad?',
            '%%: Palun mine katseklaasi tagasi!',
'see, et %% ahvi moodi haiseb, ei tähenda veel, et ta oleks Tarzan',
'Vau! See pidi küll pirakas teerull olema, mis %% näost üle sõitis.',
            '%%: säästa oma kopsumahtu tüdruku täis puhumiseks',
            'ma ei suuda nii palju juua, et %% inimest meenutama hakkaks',
            '%% on elav tõestus, et inimene saab elada ilma ajudeta.',
            'ajud pole veel kõik - %% korral pole nad mitte midagi',
            'igasugune sarnasus %% ja inimese vahel on täielik kokkusattumus',
'kui Frankenstein tahaks idiooti kokku panna, siis vajaks ta %% tükke',
            'kes jättis %% puuri lahti?',
            '%%: ära tunne end halvasti - paljud inimesed on andetud',
            '%%: ära mõtle, sa võid oma ajud ära nikastada',
'%%: palun räägi edasi, ehk ühel päeval ütled sa ka midagi tarka',
'Kui ma sööksin sada kilo nisukliisid, siis mu sitt oleks parem inimene kui %%',
            '%% on kahjuks langenud anentsefaalia ohvriks',
            '%%: Su ema kepib telliste eest, et su õele litsimaja ehitada...',
            '%% on kole nagu hommikune Halonen',
'%%: sul pole midagi sellist viga, mida reinkarnatsioon ei parandaks',
            '%% on tõestus, et jumalal on huumorimeel',
            '%% aju on samahästi kui uus, kuna seda pole kunagi kasutatud',
            'tänu %% jutu lugemisele on nüüd kõik siin kanalil lollimad...',
'Ma just kuulsin, et %% on haige. Loodetavasti pole see midagi kerget.',
            '%% on tagasihoidlik inimene. Tal on põhjust selleks...',
'%%: mulle tundub, et parim osa sinust jooksis mööda su ema persepragu alla ja lõppes pruuni plekina madratsil',
            'Mõned toovad rõõmu igale poole, kus nad on. Ka %% - lahkudes.',
            'kui %% auto alla jääb, siis ei ole see õnnetus.',
'Mind ei sega, et %% räägib. Vähemalt niikaua kuni ma seda kuulama ei pea.',
'%% tõestab, et ligi paari meetrine sitahunnik võib püsti püsida.',
'%%: Sul on nägu mida ainult ema võiks armastada. Kuid ta vihkab sind...',
            '%%, külast just helistati. Nad tahavad oma lolli tagasi.',
'%%: Ma ei elaks sinuga koos, isegi kui maailm oleks kusega üle ujutatud ja sa oleksid ainsa puu otsas.',
            '%% on alaväärsuskompleksiga - ja täiesti põhjendatult',
'%%: Kas sa sündisid paksu limase sitajunnina, või pidid selleks saamiseks vaeva nägema?',
            '%%: Kas su vanematel on ka mõni elus laps?',
'%%: Vastandid pidavat tõmbuma. Loodetavasti kohtud kellegi ilusa, targa ja kultuursega.',
'%%: Sul on sitt arvamus inimestest kui arvad, et nad on sinuga võrdsed.',
            '%% on tugev nagu härg ja peaaegu sama intelligentne',
'%%: Mul on hea meel, kui ütlesin sulle midagi mille pärast vabandama peaks :)',
            'Taburet oleks %% jaoks võrdväärne vestluspartner.',
'Ma ei tea mitu jalga on %%-l, kuid taburetil on neid umbes samapalju.',
            'Kui %% kenam välja näeks, võiks ta töötada IT alal.',
'%%: Tead, ma valan su munadeni betooni ja jätan suruõhuvasara kahe meetri kaugusele.',
'%%, sina sinirohekollane tipitäpiline puust peaga ja plekist kõrvadega villastes sokkides lollaka naeratusega pilusilmne poolearuline ärakaranud vangi sarnane lampjalgne lasteaia lollpea, kas sa ei mäleta oma kohta?',
            '%%, tead sina, mine õige kasvata omale uus aju',
'%%, palun loobu sellest liiva täis põlvikust, mida sa püksis kannad.',
            '%%: MIS SUL VIGA ON?',
            '%%: keri kolmikhüppega perse ja tõmba luuk ka tagant kinni',
'Kui taburet tagurpidi panna, siis saab %% koos oma pedesõbraga istuda.',
            '%% kõlbab ainult litsimajja linu pesema',
            '%%: ebakõla sinu ja looduse vahel on sulle näkku kirjutatud',
            '%%: sina sitaviiul jää vait',
            '%% kuskil munni ei peaks imema?',
            '%% on nagu kaamel - küür seljas ja ila voolab',
            '%%: Miks sa minuga räägid? Ma pole puuetega laste hooldaja.',
            '%%: mängi endaga kusagil mujal.',
'%%: tead, kui ma oleks sinu näoga, jookseks ma naerdes ketassae otsa',
            '%%: mine ära ja võta oma pokemon kaasa!',
            '%%: millal sa viimati ilma peeglit kasutamata oma munni nägid?',
            '%%: mängisid pipimängu jälle?',
            '%%: kaotasid küpsisemängus jälle?',
            '%%: miks sul häbe näos on?',
            '%% pärast ongi piimapakkidel kiri "Ava siit"',
'%% on hea näide sellest, mis juhtub, kui õigel ajal aborti ei tehta',
            '%% on nii loll, et ei läbi isegi Turingi testi',
'%% pea püsib ikka püsti - sooja õhku täis skalp ei kaalu ju palju ;)',
        );

        my @shuffled = shuffle(@frases);
        my $c = decode('utf8', $shuffled[0]);
        $c =~ s/%%/$user/g;

        return $c;
    }
}

1;

__END__

=head1 AUTHOR

Marko Punnar <marko@aretaja.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by Marko Punnar.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see L<http://www.gnu.org/licenses/>

=cut
