package WWW::LastFM::API::Geo;

use Moose;
use namespace::autoclean;

use URI::Escape;
use WWW::LastFM::Response;

# ABSTRACT: The Last.FM Geo API

has 'lastfm' => (
    is       => 'ro',
    isa      => 'WWW::LastFM',
    required => 1,
);

=method get_metros($country)

API method C<geo.getMetros>. No longer supported by LastFM. See
L<http://www.last.fm/api/show?service=435> for details.  Country must be a
binary encoded UTF8 string.

=cut

sub get_metros {
    my ($self, $country) = @_;
    my $xml = $self->lastfm->get(
           $self->lastfm->api_root_url
        . '?method=geo.getMetros'
        . ( $country ? '&country=' . uri_escape($country) : "" )
        . '&api_key=' . $self->lastfm->api_key
    );
    return WWW::LastFM::Response->new( xml => $xml );
}

=method get_events(%opts)

API method C<geo.getEvents>. No longer supported by LastFM. See
L<http://www.last.fm/api/show?service=270> for details.
All strings must be binary encoded utf8 strings.

Options:

=for :list
* lat (optional) : Specifies a latitude value to retrieve events for (service returns nearby events by default)
* location (optional) : Specifies a location to retrieve events for (service returns nearby events by default)
* long (optional) : Specifies a longitude value to retrieve events for (service returns nearby events by default)
* distance (optional) : Find events within a specified radius (in kilometres)
* limit (optional) : The number of results to fetch per page. Defaults to 10.
* page (optional) : The page number to fetch. Defaults to first page.

=cut

sub get_events {
    my ($self, %opts) = @_;
    my $params = "";
    foreach my $key ( keys %opts ) {
        $params .= '&' . $key . '=' . uri_escape( $opts{$key} );
    }
    my $xml = $self->lastfm->get(
           $self->lastfm->api_root_url
        . '?method=geo.getEvents'
        . $params
        . '&api_key=' . $self->lastfm->api_key
    );
    return WWW::LastFM::Response->new( xml => $xml );
}

__PACKAGE__->meta->make_immutable();

1;
