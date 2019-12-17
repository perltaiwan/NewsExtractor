package NewsExtractor::TextUtil;
use strict;
use warnings;

use Unicode::UCD qw(charscript);

our @EXPORT = (
    'u',
    'normalize_whitespace',
    'remove_spaces',
    'segmentation_by_script',
);

sub u($) {
    my $v = "".$_[0];
    utf8::upgrade($v) unless utf8::is_utf8($v);
    return $v;
}

sub normalize_whitespace {
    local $_ = $_[0];
    s/[\t\x{3000} ]+/ /g;
    s/\r\n/\n/g;
    s/\A\s+//;
    s/\s+\z//;
    return $_;
}

sub remove_spaces {
    return grep { ! /\A\s*\z/u } @_;
}
    
sub segmentation_by_script($) {
    my $str = normalize_whitespace($_[0]);
    my @tokens;
    my @chars = grep { defined($_) } split "", $str;
    return () unless @chars;

    my $t = shift(@chars);
    my $s = charscript(ord($t));
    while (my $char = shift @chars) {
        my $_s = charscript(ord($char));
        if ($_s eq $s) {
            $t .= $char;
        } else {
            push @tokens, $t;
            $s = $_s;
            $t = $char;
        }
    }
    push @tokens, $t;
    return remove_spaces map { $_ = normalize_whitespace($_) } @tokens;
}

1;
