use v5.18;
use warnings;

use File::Slurp 'read_file', 'write_file';
use Test2::V0;
use NewsExtractor;

my @urls = (
    read_file('t/data/urls-fails', chomp => 1 ),
    read_file('t/data/urls-success', chomp => 1 ),
);

my (@fails, @success);
for my $url (@urls) {
    my ($error, $x) = NewsExtractor->new(url => $url)->download;

    if ($error) {
        fail "Download failed: $url";
        diag $error->message;
        push @fails, $url;
    } else {
        subtest "Extract: $url" => sub {
            my $article = $x->parse;

            if ($article) {
                push @success, $url;
                ok $article->dateline;
                ok $article->headline;
                ok $article->journalist;
                ok $article->content;
            } else {
                push @fails, $url;
            }
        };
    }
}

write_file('t/data/urls-success', join("\n", @success));
write_file('t/data/urls-fails', join("\n", @fails));

done_testing;
