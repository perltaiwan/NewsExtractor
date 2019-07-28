package NewsExtractor::Download;
use v5.18;
use Moo;
use Types::Standard qw< InstanceOf >;

has tx => ( required => 1, is => 'ro', isa => InstanceOf['Mojo::Transaction::HTTP']);

use NewsExtractor::Article;
use NewsExtractor::GenericExtractor;
use NewsExtractor::Error;
use Try::Tiny;

sub parse {
    my $self = $_[0];
    my ($err, $o);

    my $x = NewsExtractor::GenericExtractor->new( tx => $self->tx );
    my %article = (
        article_body => $x->content_text,
        headline     => $x->headline,
        dateline     => $x->dateline,
        journalist   => $x->journalist,
    );

    for my $it (qw(dateline journalist)) {
        delete $article{$it} unless defined $article{$it};
    }

    try {
        $o = NewsExtractor::Article->new(%article);
    } catch {
        $err = NewsExtractor::Error->new(
            message => $_,
            debug => \%article,
        );
    };

    return ($err, $o);
}

1;
