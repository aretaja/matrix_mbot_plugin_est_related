package Mbot::Plugins::Ilm;
use LWP::UserAgent;
use XML::Smart;
use DateTime;
use Encode;

our $VERSION = '0.2';

=head1 NAME

Mbot::Plugins::Ilm - Mbot Estonian weather plugin

=head1 METHODS

=head2 parse - input parser

If input is "ilm" responds weather data

       $result = parse($self->in);

=cut

sub parse
{
    my ($self, $in) = @_;

    return 'ilm - hetke ilm'
      if ($in->{msg} && $in->{msg} eq 'help');

    if ($in->{msg} && $in->{msg} eq 'ilm')
    {
        my $ua = LWP::UserAgent->new(
            timeout => 5,
            agent   => '',
        );
        my $req =
          HTTP::Request->new(GET =>
              'http://www.ilmateenistus.ee/ilma_andmed/xml/observations.php');
        my $res = $ua->request($req);

        my $all_data;
        if ($res->is_success)
        {
            my $locations = {
                26038 => 'Tallinn-Harku',
                26242 => 'Tartu-Tõravere',
                26058 => 'Narva',
                26247 => 'Valga',
                26135 => 'Türi',
                26231 => 'Pärnu-Sauga',
                26123 => 'Haapsalu',
                26249 => 'Võru',
            };

            my $xml   = XML::Smart->new($res->decoded_content);
            my $epoch = $xml->{observations}->{timestamp}->content();
            my $dt    = DateTime->from_epoch(
                epoch     => $epoch,
                time_zone => $in->{conf}->{time_zone},
            );
            my $data->{time} = $dt->ymd . 'T' . $dt->hms || 'Na';

            $xml = $xml->cut_root();
            my @stations = @{$xml->{station}};
            foreach (@stations)
            {
                if ($locations->{$_->{wmocode}})
                {
                    $data->{locations}->{$_->{name}} = {
                        hum    => $_->{relativehumidity},
                        press  => $_->{airpressure},
                        temp   => $_->{airtemperature},
                        wspeed => $_->{windspeed},
                        prec   => $_->{precipitations},
                    };
                }
            }

            my @out = (
                '',
                "Seisuga $data->{time}",
"Temp (C) : Sademed (mm) : Niiskus (%) : Rõhk (hPa) :  Tuul (m/s)"
            );

            foreach (sort(keys(%{$data->{locations}})))
            {
                my $l_data = $data->{locations}->{$_};
                my $loc =
"$_\n    $l_data->{temp} : $l_data->{prec} : $l_data->{hum} : $l_data->{press} : $l_data->{wspeed}";
                push(@out, $loc);
            }

            return decode('utf8', join("\n", @out));
        }
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
