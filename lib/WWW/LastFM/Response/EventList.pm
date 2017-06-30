package WWW::LastFM::Response::EventList;

use XML::Rabbit;

# ABSTRACT: <events/> XML response handler

has_xpath_value 'page'       => './@page';
has_xpath_value 'page_limit' => './@perPage';
has_xpath_value 'page_count' => './@totalPages';

has_xpath_value 'location'       => './@location';
has_xpath_value 'festivals_only' => './@festivalsonly';

has_xpath_object_map 'map' => './event',
    './id'  => 'WWW::LastFM::Response::Event',
    handles => {
        'get' => 'get',
        'ids' => 'keys',
        'all' => 'values',
    },
;

finalize_class();
