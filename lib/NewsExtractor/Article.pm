package NewsExtractor::Article;
use Moo;
use NewsExtractor::Types qw< Text Text1K >;

has headline => ( required => 1, is => 'ro', isa => Text1K );
has article_body  => ( required => 1, is => 'ro', isa => Text );

has dateline   => ( predicate => 1, is => 'ro', isa => Text1K );
has journalist => ( predicate => 1, is => 'ro', isa => Text1K );

1;

__END__

=head1 Name

NewsExtractor::Article

=head1 Description

This is a data class that contains an news article extracted from some web sites.
The instances of this data class has these attributes:

=over 4

=item headline

Mandatory. Str. Refer to the headline of a news article.

=item article_body

Mandatory. Str. Refer to the body of a news article.

=item dateline

Optional. One must check the presense of this attribute with C<has_dateline>
method before taking the value of it.
(
=item journalist

Optional. One must check the presense of this attribute with C<has_journalist>
method before taking the value of it.

=back

=cut
