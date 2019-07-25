use v5.18;

use Test2::V0;
use NewsExtractor;

my @urls = qw(
                 'https://www.ettoday.net/news/20190726/1498716.htm',
                 'https://www.ettoday.net/news/20190726/1498728.htm',
                 'https://www.ettoday.net/news/20190725/1498576.htm',
                 'https://www.ettoday.net/news/20190725/1498607.htm',
         );

for my $url (@urls) {
    my ($x, $error) = NewsExtractor->new($url)->download;

    if ($error) {
        skip "Failed";
    } else {
        subtest "Extract $url as NewsArticle" => sub {
            my $y = $x->as_NewsArticle;
            ok $y->dateline;
            ok $y->journalist;
            ok $y->title;
        };
    }
}
done_testing;
