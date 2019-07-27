package NewsExtractor::Download;
use v5.18;
use Moo;
use Types::Standard qw< InstanceOf >;

has tx => ( required => 1, is => 'ro', isa => InstanceOf['Mojo::Transaction::HTTP']);

use NewsExtractor::Article;
use NewsExtractor::GenericExtractor;
use JSON;

sub parse {
    my $self = $_[0];
    my $x = NewsExtractor::GenericExtractor->new( tx => $self->tx );

    return NewsExtractor::Article->new(
        content    => $x->content_text,
        dateline   => $x->dateline,
        headline   => $x->headline,
        journalist => $x->journalist,
    );
}

1;
