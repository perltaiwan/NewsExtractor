package NewsExtractor::SiteSpecificExtractor::news_ebc_net_tw;
use utf8;
use Moo;
extends 'NewsExtractor::GenericExtractor';

use Importer 'NewsExtractor::TextUtil' => 'normalize_whitespace';

sub journalist {
    my ($self) = @_;
    my $guess = $self->dom->at('.fncnews-content > .info > span.small-gray-text') or return;
    my $text = normalize_whitespace($guess->all_text);
    my ($name) = $text =~ m/(?:東森新聞(?:\s*責任編輯)?)\s+(.+)$/;
    return $name;
}

1;
