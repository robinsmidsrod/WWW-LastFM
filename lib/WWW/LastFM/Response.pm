package WWW::LastFM::Response;
use XML::Rabbit::Root;

add_xpath_namespace 'geo' => 'http://www.w3.org/2003/01/geo/wgs84_pos#';

sub BUILD {
    my ($self) = @_;
    return if $self->is_success;
    confess("Last.FM response error " . $self->error_code . ": " . $self->error);
}

has 'is_success' => (
    is         => 'ro',
    isa        => 'Bool',
    lazy_build => 1,
);

sub _build_is_success {
    my ($self) = @_;
    return unless $self->status eq 'ok';
    return 1;
}

has_xpath_value 'status'     => '/lfm/@status';
has_xpath_value 'error'      => '/lfm/error';
has_xpath_value 'error_code' => '/lfm/error/@code';

has_xpath_object 'metros' => '/lfm/metros' => 'WWW::LastFM::Response::MetroList';
has_xpath_object 'events' => '/lfm/events' => 'WWW::LastFM::Response::EventList';

finalize_class();
