package Mbot::Plugins::Kompliment;
use List::Util 'shuffle';
use Encode;

our $VERSION = '0.1';

=head1 NAME

Mbot::Plugins::Kompliment - Simple Mbot compliment plugin

=head1 METHODS

=head2 parse - input parser

Responds random compliment.
Compliments source L<https://github.com/mth/hirc/blob/master/compliments.txt>

       $result = parse($self->in);

=cut

sub parse
{
    my ($self, $in) = @_;

    return 'kompliment [name] - teeb tuju heaks'
      if ($in->{msg} && $in->{msg} eq 'help');

    if ($in->{msg} && $in->{msg} =~ m/^kompliment\s*(.*)?\s*/)
    {
        my $user = $1 || $in->{dname};
        my @frases = (
            'Milline sümpaatne noor inimene on %%! Olgu ta teile eeskujuks.',
            'Pidevast õllejoomisest hoolimata on Sul fantastiline figuur!',
            'Ma pole veel kohanud nii võrratu käitumisega inimest kui %%',
            'Eesti mees nagu %% on kõige parem',
            'Sul on nii armsad silmad, just nagu kutsikal!',
            'Sa oled sama ilus kui tänane päev!',
            'Oma aju ja teadmistega võiksid Sa vabalt olla mees!',
            'Sa oled nagu ingel kesapõllul!',
            '%% eest annaks ma terve kuningriigi',
            '%%, Sa oled nagu hea vein, mida keegi ei raatsi puutuda',
            'Tahaks Sind kallistada!',
            'Sa oled arukas, heatujuline ja elav. Kuidas naistega läheb?',
            '%% mõistus on kahtlemata omal kohal',
            'Sa oled nagu sinilill kibuvitsapõõsas',
            '%%, mu ingel',
            'Aitäh, %%, et Sa elus oled!',
            'Sina oledki see kirkaim kriit karbis!',
            'Sa näed välja nagu koorejäätis kirsiga',
'Piiblis on kirjas: "Ja nüüd istub ta Tema paremal käel." Mõeldi vist Sind.',
            'Ma arvan, et %% on selle koha tegelik juhtfiguur',
            '%%, kas Sa oleksid palun mu laste isa?',
            'Kas need on Sinu Porsched seal maja ees?',
            'Tule ma annan Sulle musi',
'Kui Sind ära ruunata, oleks Sa ikka rohkem mees kui need teised lontrused siin',
            '%%, kas MENSA jäi Sulle kitsaks?',
            'Ükski prohvet, isegi mitte %%, pole kuulus omal maal...',
            '%%, Su kaunidus võtab jalust nõrgemaks kui liköör shampusega',
            'Räägitakse, et %% on uus Ron Jeremy...',
            'Sa näed fantastiline välja. Oled Sa ikka eestlane?',
            'Muskulatuuri järgi võiks arvata, et Sa oled neeger',
            'Igal õhtul ma palvetan, et mulle Sinusugune mees saadetaks!',
            '%% presidendiks!',
            'Teen ettepaneku nimetada %% Valgetähe ordeni kandidaadiks',
            '%% on nii lahe, et talle peaks selle eest raha maksma',
'Kui ma oleks nii kuulus kui %%, ei julgeks ma ilma turvadeta väljagi minna...',
            'Minu laste isa on %%. Soovitan teistelegi.',
'Päike oli valge, enne kui ta %% peale vaadates kadedusest kollaseks läks',
            'Sinu sära juures poleks meile päikest vajagi',
            '%% paneb aluse uuele inimtõule',
            'Meie ajastu vajab kangelasi. %%, astu ette!',
            'Mehed nagu %% viivad meid tähtedele',
            '%%, kas sind esitati jälle Nobeli preemia kandidaadiks?',
            'Hea on päeva alustada, kui tead, et %% on lähedal',
'Kui Billi asemel juhiks Microsofti %%, kasutaks kogu see rahvas Windowsit',
            '%%: Sinuga läheks luurele küll. Ja tuleks koos tagasi ka.',
            '%%: Ema Teresal oli Sinu kohta mõndagi head öelda',
'Kui maailmas oleks ainult inimesed nagu %%, elaksime siiani paradiisis',
'Kas teadsite, et buda mungad käisid %% juures kannatlikkust õppimas?',
            '%% võitles meie vabaduse eest. Mida tegite teie?',
            'Vaadake! %%-st levib ürgset mehelikku jõudu!',
            'Maagiat ma ei usu, aga %% on küll täielik tehnikavõlur',
            '%%, Sa oled mu eeskuju. Ausõna.',
'Pange tähele, veel mõni aasta ja %% on populaarsem kui Jeesus ja biitlid kokku',
'%%: Kuidas Sa küll suudad alati olla nii rõõmsameelne, optimistlik ja lahke?',
            '%%: Su elurõõm on piiritu, jaga seda teistelegi',
'%%, Sa oled ikka uskumatult positiivne tüüp! Fantastiline! Täiesti super!',
            'Pärast %% nägemist on terve päev nagu päikest täis',
            'Sinuga, %%, võiks ma minna kasvõi maailma lõppu!',
            'Mis on õnn? Aga vaadake %% poole, saate aru...',
            '%%: Tule ma kallistan Sind!',
            '%%: Su elu on nagu muinasjutt...',
'Kas teate, miks John Holmes Eestis ei käinud? Ta kartis %%-ga võistelda.',
        );

        @shuffled = shuffle(@frases);
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
