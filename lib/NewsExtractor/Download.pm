package NewsExtractor::Download;
use Moo;
use Types::Standard qw< InstanceOf >;

use NewsExtractor::Article;

has tx => ( required => 1, is => 'ro', isa => InstanceOf['Mojo::Transaction::HTTP']);

sub parse {
    my $self = $_[0];

    return NewsExtractor::Article->new(
    );
}

1;
