use v5.28;
use strict;

use Encode qw(encode);
use Mojo::UserAgent;
use YAML::Dumper;
use Getopt::Long qw< GetOptions >;

use NewsExtractor;

my %opts;
GetOptions(
    \%opts,
);

my $url = shift @ARGV or die;

my $x = NewsExtractor->new( url => $url );
my ($err, $article) = $x->download->parse;

my $dumper = YAML::Dumper->new;
$dumper->indent_width(4);
if ($article) {
    print encode( "utf8" => $dumper->dump({ %$article }) );
} else {
    print "No Article\n";
    $dumper->dump({ message => $err->message, debug => $err->debug });
}
