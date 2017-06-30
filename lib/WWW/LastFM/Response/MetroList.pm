package WWW::LastFM::Response::MetroList;

use XML::Rabbit;

# ABSTRACT: <metros/> XML response handler

use List::MoreUtils qw(uniq);

has_xpath_object_list '_locations' => './metro' => 'WWW::LastFM::Response::Metro',
    handles => {
        'locations'        => 'elements',
        'filter_locations' => 'grep',
    },
;

has_xpath_value_list '_countries_with_duplicates' => './metro/country';

has '_unique_countries' => (
    is         => 'ro',
    isa        => 'ArrayRef[Str]',
    traits     => ['Array'],
    handles    => {
        'countries'        => 'elements',
        'filter_countries' => 'grep',
    },
    lazy_build => 1,
);

sub _build__unique_countries {
    my ($self) = @_;
    return [
        uniq(
             @{ $self->_countries_with_duplicates }
        )
    ];
}

finalize_class();
