package NewsExtractor::SiteSpecificExtractor::ETtoday;
use utf8;
use Moo;
extends 'NewsExtractor::GenericExtractor';

sub journalist {
    my ($self) = @_;
    my ($name) = $self->content_text =~ m{(?:\n|\A)記者(\p{Letter}+)／([\p{Letter}—]+)報導\n};
    return $name;
}

1;
