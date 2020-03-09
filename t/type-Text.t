use Test2::V0 -no_utf8 => 1;

use NewsExtractor::Types qw(is_Text);

subtest "Strings without control characters" => sub {
    for my $v ("123", "中央社", "123 中央社") {
        utf8::upgrade($v);
        ok is_Text($v);

        utf8::downgrade($v);
        ok !is_Text($v);
    }
};

subtest "String with control characters" => sub {
    my $v = "你好\x07世界";
    utf8::upgrade($v);
    ok !is_Text($v);
};

done_testing;
