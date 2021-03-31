package NewsExtractor::SiteSpecificExtractor::www_mdnkids_com;
use utf8;
use Moo;
extends 'NewsExtractor::GenericExtractor';

use Importer 'NewsExtractor::TextUtil' => qw(reformat_dateline normalize_whitespace);

sub dateline {
    my ($self) = @_;
    my $el = $self->dom->at('h2 ~ div.col span');
    if ($el) {
        my ($ymd) = $el->all_text() =~ m<\(([0-9]{4}/[0-9]{1,2}/[0-9]{1,2})\)\z>;
        return reformat_dateline( $ymd, '+08:00' );
    }
    return undef;
}

sub journalist {
    my ($self) = @_;
    my ($x);
    if (my $el = $self->dom->at('h2 ~ div.col span')) {
        $x = $el->all_text() =~ s<\([0-9]{4}/[0-9]{1,2}/[0-9]{1,2}\)\z><>r;
        $x = normalize_whitespace($x);
    }
    return $x;
}

1;
