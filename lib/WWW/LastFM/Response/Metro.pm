package WWW::LastFM::Response::Metro;
use XML::Rabbit;

# ABSTRACT: <metro/> XML response handler

has_xpath_value 'name'    => './name';
has_xpath_value 'country' => './country';

has 'country_and_name' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub _build_country_and_name {
    my ($self) = @_;
    return $self->country . ": " . $self->name;
}

has 'name_and_country' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub _build_name_and_country {
    my ($self) = @_;
    return $self->name . ", " . $self->country;
}

finalize_class();
