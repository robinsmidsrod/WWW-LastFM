#!/usr/bin/env perl

use strict;
use warnings;
use rlib;
use feature qw(say);

use WWW::LastFM;
use Encode qw(decode encode);

# PODNAME: lastfm_locations.pl
# ABSTRACT: Search for valid Last.FM API locations

my $filter = shift;
my $filter_utf8 = $filter ? Encode::decode('UTF-8', $filter) : "";

my @locations = sort
        map { $_->name_and_country }
        WWW::LastFM->new->geo->get_metros->metros->filter_locations(
            sub { $_->country_and_name =~ /\Q$filter_utf8\E/i }
        )
;

if ( @locations > 0 ) {
    say Encode::encode('UTF-8', join("\n", @locations) );
}
else {
    say STDERR "No locations found matching '$filter'";
}

1;
