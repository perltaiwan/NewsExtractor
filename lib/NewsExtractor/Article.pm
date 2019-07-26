package NewsExtractor::Article;
use Moo;
use NewsExtractor::Types qw< Text Text1K >;

has headline => ( required => 1, is => 'ro', isa => Text1K );
has content  => ( required => 1, is => 'ro', isa => Text );

has dateline   => ( required => 1, is => 'ro', isa => Text1K );
has journalist => ( required => 1, is => 'ro', isa => Text1K );

1;
