use v5.28;
use strict;

use Encode qw(encode decode);
use Mojo::UserAgent;
use Getopt::Long qw< GetOptions >;

use NewsExtractor;

my %opts;
GetOptions(
    \%opts,
);

my $url = shift @ARGV or die;

my $x = NewsExtractor->new( url => $url );
my $article = $x->download->parse;

if ($article) {
    print JSON->new->pretty->canonical->encode({ %$article });
} else {
    print "No Article\n";
}
