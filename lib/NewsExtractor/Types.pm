package NewsExtractor::Types;
use v5.18;

use Type::Library -base;
use Type::Utils -all;
extends "Types::Standard";

use Encode qw< is_utf8 >;

declare Text   => as "Str",  where { is_utf8($_) };
declare Text1K => as "Text", where { length($_) <= 1024 };
declare Text4K => as "Text", where { length($_) <= 4096 };

1;
