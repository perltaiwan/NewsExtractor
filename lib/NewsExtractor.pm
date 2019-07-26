package NewsExtractor;
our $VERSION = v0.0.1;
use Moo;

use Mojo::UserAgent;

use Types::URI qw< Uri >;
use NewsExtractor::Error;
use NewsExtractor::Download;

has url => ( required => 1, is => 'ro', isa => Uri, coerce => 1 );

sub download {
    my NewsExtractor $self = shift;

    my $ua = Mojo::UserAgent->new;
    my $tx = $ua->get( "". $self->url );
    my $res = $tx->result;

    my ($error, $download);
    if ($res->is_error) {
        $error = NewsExtractor::Error->new(
            is_exception => 0,
            message => $res->message,
        );
    } else {
        $download = NewsExtractor::Download->new( tx => $tx );
    }
    return ($error, $download);
}

1;

__END__

=head1 NAME

NewsExtractor -- download and extract news articles from Internet.

=head1 SYNOPSIS

    my $extractor = NewsExtractor->new( url => $url );
    my $x = $extractor->download();

    # https://metacpan.org/pod/SemanticWeb::Schema::NewsArticle
    $o = $x->as_NewsArticle;

=head1 DESCRIPTION

=head1 AUTHOR

Kang-min Liu <gugod@gugod.org>

=head1 LICENSE

To the extent possible under law, Kang-min Liu has waived all copyright and related or neighboring rights to NewsExtractor. This work is published from: Taiwan.

https://creativecommons.org/publicdomain/zero/1.0/

=cut
