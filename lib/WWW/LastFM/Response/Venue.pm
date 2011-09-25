package WWW::LastFM::Response::Venue;
use XML::Rabbit;

# Last.FM-specific data
has_xpath_value 'id'  => './id';
has_xpath_value 'url' => './url';

# The actual venue-related data
has_xpath_value 'name'         => './name';
has_xpath_value 'website'      => './website';
has_xpath_value 'phone_number' => './phonenumber';

# Location-related data
has_xpath_value 'city'        => './location/city';
has_xpath_value 'country'     => './location/country';
has_xpath_value 'street'      => './location/street';
has_xpath_value 'postal_code' => './location/postalcode';
has_xpath_value 'latitude'    => './location/geo:point/geo:lat';
has_xpath_value 'longitude'   => './location/geo:point/geo:long';

# Venue image URLs
has_xpath_value 'image_s'  => './image[@size="small"]';
has_xpath_value 'image_m'  => './image[@size="medium"]';
has_xpath_value 'image_l'  => './image[@size="large"]';
has_xpath_value 'image_xl' => './image[@size="extralarge"]';

# Convenience attribute for combined address
has 'address' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub _build_address {
    my ($self) = @_;
    return $self->name . ', '
         . ( $self->street ? $self->street . ', ' : "" )
         . ( $self->postal_code ? $self->postal_code . ' ' : "" )
         . $self->city . ', '
         . $self->country;
}

finalize_class();
