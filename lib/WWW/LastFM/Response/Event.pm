package WWW::LastFM::Response::Event;
use XML::Rabbit;

# ABSTRACT: <event/> XML response handler

use HTML::FormatText;
use DateTime::Format::HTTP;

# Last.FM-specific data
has_xpath_value 'id'  => './id';
has_xpath_value 'tag' => './tag';
has_xpath_value 'url' => './url';

# The actual event-related data
has_xpath_value 'title'            => './title';
has_xpath_value 'description_html' => './description';
has_xpath_value 'website'          => './website';
has_xpath_value 'start_date'       => './startDate';
has_xpath_value 'headliner'        => './artists/headliner';
has_xpath_value_list '_artists'    => './artists/artist',
    handles => {
        'artists'      => 'elements',
    }
;
has_xpath_object 'venue'     => './venue'    => 'WWW::LastFM::Response::Venue';
has_xpath_value_list '_tags' => './tags/tag',
    handles => {
        'tags' => 'elements',
    },
;

# Some various attendance-related data
has_xpath_value 'ticket_count' => './tickets';
has_xpath_value 'attendance'   => './attendance';
has_xpath_value 'cancelled'    => './cancelled';
has_xpath_value 'review_count' => './reviews';

# Event image URLs
has_xpath_value 'image_s'  => './image[@size="small"]';
has_xpath_value 'image_m'  => './image[@size="medium"]';
has_xpath_value 'image_l'  => './image[@size="large"]';
has_xpath_value 'image_xl' => './image[@size="extralarge"]';

# The description value, converted to plain text
has 'description' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub _build_description {
    my ($self) = @_;
    return HTML::FormatText->format_string(
        $self->description_html,
        leftmargin  =>  0,
        rightmargin => 79,
    );
}

# Convert the start_date to a DateTime class which is much more useful
has 'date' => (
    is         => 'ro',
    isa        => 'DateTime',
    lazy_build => 1,
);

sub _build_date {
    my ($self) = @_;
    return DateTime::Format::HTTP->parse_datetime(
        $self->start_date
    );
}

finalize_class();
