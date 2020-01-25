package NewsExtractor::SiteSpecificExtractor::www_ntdtv_com;
use utf8;
use Moo;
extends 'NewsExtractor::GenericExtractor';
use Importer 'NewsExtractor::TextUtil'  => qw( normalize_whitespace );

sub content_text {
    my ($self) = @_;
    my $el = $self->dom->at("div[itemprop=articleBody]");
    $el->find("div.print_link, div.single_ad")->map("remove");
    my $last_child = $el->children->last;
    if ($last_child->all_text =~ /相關鏈接：/) {
        $last_child->remove;
    }
    my $txt = $el->all_text;
    $txt = normalize_whitespace($txt);
    return $txt;
}

sub journalist {
    my ($self) = @_;
    my ($name) = $self->content_text =~ m{
        \n
        (
            新唐人亞太電視\p{Letter}+?報導
            | （\s* 記者\p{Letter}+報導/責任編輯：\p{Letter}+ \s*）
        )
        \z}xs;

    $name =~ s/\A（//;
    $name =~ s/）\z//;

    return $name;
}

1;
