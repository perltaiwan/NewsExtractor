package NewsExtractor::Article;
use Moo;
use NewsExtractor::Types qw< Text Text1K >;

has headline => ( required => 1, is => 'ro', isa => Text1K );
has article_body  => ( required => 1, is => 'ro', isa => Text );

has dateline   => ( predicate => 1, is => 'ro', isa => Text1K );
has journalist => ( predicate => 1, is => 'ro', isa => Text1K );

1;
