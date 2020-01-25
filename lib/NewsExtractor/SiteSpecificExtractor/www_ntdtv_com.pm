package NewsExtractor::SiteSpecificExtractor::www_ntdtv_com;
use utf8;
use Moo;
extends 'NewsExtractor::GenericExtractor';

sub journalist {
    my ($self) = @_;
    my ($name) = $self->content_text =~ m{\n(新唐人亞太電視\p{Letter}+?報導)\z}s;
    return $name;
}

1;
