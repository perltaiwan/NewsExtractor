package NewsExtractor::CSSExtractor;
use v5.18;
use utf8;
use Moo;
extends 'NewsExtractor::GenericExtractor';

use Types::Common::String qw( NonEmptySimpleStr );

has headline_css_selector => (
    required => 1,
    is => 'ro',
    isa => NonEmptySimpleStr,
);

has journalist_css_selector => (
    required => 1,
    is => 'ro',
    isa => NonEmptySimpleStr,
);

has dateline_css_selector => (
    required => 1,
    is => 'ro',
    isa => NonEmptySimpleStr,
);

has content_text_css_selector => (
    required => 1,
    is => 'ro',
    isa => NonEmptySimpleStr,
);

sub headline {
    my ($self) = @_;
    return $self->dom->at( $self->headline_css_selector )->text;
}

sub dateline {
    my ($self) = @_;
    return $self->dom->at( $self->dateline_css_selector )->text;
}

sub journalist {
    my ($self) = @_;
    return $self->dom->at( $self->journalist_css_selector )->text;
}

sub content_text {
    my ($self) = @_;
    return $self->dom->at( $self->content_text_css_selector )->text;
}

1;
