package WWW::LastFM;
use Moose;
use namespace::autoclean;

# ABSTRACT: Object-oriented interface to the Last.FM API version 2.0

use LWP::UserAgent;
use WWW::LastFM::API::Geo;

our $VERSION = "0.0.1";

# Read configuration from ~/.lastfm.ini, available in $self->config
has 'config_filename' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
sub _build_config_filename { '.lastfm.ini' }
with 'Config::Role';

# And here we have our api key and secret
has 'api_key' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub _build_api_key { return (shift)->config->{'API'}->{'key'}; }

has 'api_secret' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub _build_api_secret { return (shift)->config->{'API'}->{'secret'}; }

# All access to the Last.FM API starts with this URL
has 'api_root_url' => (
    is      => 'ro',
    isa     => 'Str',
    default => 'http://ws.audioscrobbler.com/2.0/',
);

# And finally our HTTP client that we will use to make requests
has 'ua' => (
    is         => 'ro',
    isa        => 'LWP::UserAgent',
    lazy_build => 1,
);

sub _build_ua {
    my ($self) = @_;
    return LWP::UserAgent->new( agent => 'WWW::LastFM/' . $VERSION );
}

# A utility method for making requests, returns raw XML
# or throws exception if no content was generated
sub get {
    my ($self, $url) = @_;
    confess("No URL specified") unless $url;
    my $response = $self->ua->get($url);
    my $content = $response->content;
    confess("HTTP error: " . $response->status_line) unless defined $content;
    confess("HTTP error: " . $response->status_line) if $response->code >= 500;
    return $content;
}

# API modules
has 'geo' => (
    is         => 'ro',
    isa        => 'WWW::LastFM::API::Geo',
    lazy_build => 1,
);

sub _build_geo {
    my ($self) = @_;
    return WWW::LastFM::API::Geo->new( lastfm => $self );
}

__PACKAGE__->meta->make_immutable();

1;

__END__

=head1 SYNOPSIS

    say join("\n",
        map { $_->name_and_country }
        WWW::LastFM->new->geo->get_metros()->metros->locations
    );


=head1 DESCRIPTION

A partial client implementation of the L<Last.FM API|http://www.last.fm/api/>. Currently only the
C<geo.getMetros> and C<geo.getEvents> are implemented.


=head1 SEMANTIC VERSIONING

This module uses semantic versioning concepts from L<http://semver.org/>.


=head1 SEE ALSO

=for :list
* L<Moose>
* L<XML::Rabbit>
* L<Config::Role>
* L<Last.FM API|http://www.last.fm/api/>
