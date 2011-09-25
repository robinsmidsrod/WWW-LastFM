#!/usr/bin/env perl

use strict;
use warnings;
use rlib;
use feature qw(say);

use WWW::LastFM;
use Getopt::Long;

# PODNAME: lastfm_eventss.pl
# ABSTRACT: Search the Last.FM API for events/concerts

STDOUT->binmode(":utf8");

# Read command line flags
my $limit;
my $distance;
my $help;
GetOptions(
    "limit=i"    => \$limit,
    "distance=i" => \$distance,
    "help"       => \$help,
);

die <<"EOM" if $help;
Usage: $0 [<options>] [<location>]
Options:
    --limit <num>   ; Number of events to return
    --distance <km> ; How large area to search
EOM

my $location = shift;

# Perform query
my $event_list = WWW::LastFM->new->geo->getEvents(
    ( defined $limit    ? ( limit    => $limit )    : () ),
    ( defined $distance ? ( distance => $distance ) : () ),
    ( defined $location ? ( location => $location ) : () ),
)->events;
my @events = $event_list->all;

# Format and output results
if ( @events > 0 ) {
    foreach my $event ( sort { $a->date cmp $b->date } @events ) {
        my $formatted_date = DateTime::Format::HTTP->format_datetime($event->date);
        my $headliner = $event->title ne $event->headliner ? " with " . $event->headliner : "";
        my @additional_artists = grep { ! $event->headliner } $event->artists;
        say $formatted_date . ": "
          . $event->title
          . $headliner
          . ( scalar @additional_artists ? " and " . join(", ", @additional_artists ) : "" )
          . " @ " . $event->venue->address;
    }
}
else {
    say STDERR "No events found for location '" . $event_list->location . "'";
}

1;
