use v5.18;
use warnings;

use File::Slurp 'read_file', 'write_file';
use Test2::V0;
use NewsExtractor;

my (@fails, @success);
for (["urls-success", \&subtest], ["urls-fails", \&todo]) {
    my $fn = 't/data/' . $_->[0];
    my $cb = $_->[1];
    my @urls = read_file($fn, chomp => 1 );
    for my $url (@urls) {
        my ($error, $x) = NewsExtractor->new(url => $url)->download;

        if ($error) {
            fail "Download failed: $url";
            diag $error->message;
            push @fails, $url;
        } else {
            $cb->(
                "Extract: $url" => sub {
                    my $article = $x->parse;
                    if ($article) {
                        push @success, $url;
                        pass "parse";
                        ok $article->dateline, "dateline";
                        ok $article->headline, "headline";
                        ok $article->journalist, "journalist";
                        ok $article->content, "content";
                    } else {
                        push @fails, $url;
                        fail "parse";
                    }
                });
        }
    }
}

write_file('t/data/urls-success', join("\n", @success));
write_file('t/data/urls-fails', join("\n", @fails));

done_testing;
