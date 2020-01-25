use v5.18;
use warnings;

use File::Slurp 'read_file', 'write_file';
use Test2::V0;
use NewsExtractor;

skip_all 'Live tests: set env TEST_LIVE=1 to actually run tests.' unless $ENV{TEST_LIVE};

my (@fails, @success);

my $fn = 't/data/urls';
my @urls = read_file($fn, chomp => 1 );

while (@urls) {
    my ($url) = splice(@urls, rand(@urls), 1);

    my ($error, $x) = NewsExtractor->new(url => $url)->download;

    if ($error) {
        fail "Download failed: $url";
        diag $error->message;
    } else {
        my $ok = subtest(
            "Extract: $url" => sub {
                my $article = $x->parse;
                if ($article) {
                    pass "parse";
                    ok($article->headline, "headline");
                    ok($article->article_body, "article_body");
                    ok($article->journalist, "journalist");
                    ok($article->dateline, "dateline");
                } else {
                    fail "parse";
                }
            });
        if ($ok) {
            push @success, $url;
        } else {
            push @fails, $url
        }
    }
}

write_file('t/data/urls-success', join("\n", @success));
write_file('t/data/urls-fails', join("\n", @fails));

done_testing;
