package NewsExtractor::SiteSpecificExtractor::house_ettoday_net;
use utf8;
use Moo;
extends 'NewsExtractor::GenericExtractor';

use Importer 'NewsExtractor::TextUtil' => 'normalize_whitespace';

sub journalist {
    my ($self) = @_;
    my ($name) = $self->content_text =~ m{\n記者(\p{Letter}+)／綜合報導\n};
    return $name;
}

1;
