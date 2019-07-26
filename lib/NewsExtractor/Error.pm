package NewsExtractor::Error;
use Moo;
use NewsExtractor::Types qw<Bool Text>;

has is_exception => ( required => 1, is => 'ro', isa => Bool );

has message => ( required => 1, is => 'ro', isa => Text );

1;
