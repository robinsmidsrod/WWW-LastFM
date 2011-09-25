package WWW::LastFM;
use Moose;
use namespace::autoclean;

# ABSTRACT: Object-oriented interface to the Last.FM API version 2.0

use File::HomeDir;
use Path::Class::Dir;
use Config::Any;
use LWP::UserAgent;
use WWW::LastFM::API::Geo;

our $VERSION = "0.0.1";

# Sometimes we like some extra debugging output
has 'debug' => (
    is      => 'ro',
    isa     => 'Bool',
    default => 0,
);

# Standard stuff to read our config file
has 'config_file' => (
    is         => 'ro',
    isa        => 'Path::Class::File',
    lazy_build => 1,
);

sub _build_config_file {
    my ($self) = @_;
    my $home = File::HomeDir->my_data;
    my $conf_file = Path::Class::Dir->new($home)->file('.lastfm.ini');
    return $conf_file;
}

# This is where our config file data ends up
has 'config' => (
    is         => 'ro',
    isa        => 'HashRef',
    lazy_build => 1,
);

sub _build_config {
    my ($self) = @_;
    my $cfg = Config::Any->load_files({
        use_ext => 1,
        files   => [ $self->config_file ],
    });
    foreach my $config_entry ( @{ $cfg } ) {
        my ($filename, $config) = %{ $config_entry };
        warn("Loaded config from file: $filename\n") if $self->debug;
        return $config;
    }
    return {};
}

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
