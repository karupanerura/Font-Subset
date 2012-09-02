package Font::Subset::TTF;
use 5.008_001;
use strict;
use warnings;
use utf8;

use parent qw/Font::Subset::Base/;
our $VERSION = '0.01';

use Encode;
use Font::TTF::Font;
use Class::Accessor::Lite (
    ro => [qw/ttf/],
);

our @ENCODER = (
    Encode::find_encoding('symbol'),
    Encode::find_encoding('utf-8'),
    Encode::find_encoding('cp932'),
    Encode::find_encoding("big5"),
    Encode::find_encoding("gb2312"),
    Encode::find_encoding("euc-kr"),
    Encode::find_encoding("johab"),
);

sub new {
    my($class, $file) = @_;
    my $ttf = Font::TTF::Font->open($file);
    $ttf->tables_do(sub { shift->read });

    return $class->SUPER::new(ttf => $ttf);
}

sub use {
    my($self, @chars) = @_;

    my @del_glyph;
    foreach my $table (@{ $self->ttf->{cmap}->{Tables} }) {
        my $encoder    = $ENCODER[ $table->{Encoding} ] or die "Unknwon encoding '$table->{Encoding}'";
        my %code_table = map { unpack('C*', $encoder->encode($_)) => 1 } @chars;
        my @del_codes  = grep { not exists $code_table{$_} } keys %{ $table->{val} };

        push @del_glyph => delete $table->{val}->{$_} for @del_codes;
    }

    $self->ttf->{loca}->{glyphs}->[$_] = undef for @del_glyph;

    return $self;
}

sub write {
    my($self, $file) = @_;

    $self->ttf->out($file);
}

sub DESTROY{
    my $self = shift;
    $self->ttf->release;
}

1;
__END__

=head1 NAME

Font::Subset::TTF - Perl extention to do something

=head1 VERSION

This document describes Font::Subset::TTF version 0.01.

=head1 SYNOPSIS

    use Font::Subset::TTF;

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Kenta Sato E<lt>karupa@cpan.orgE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012, Kenta Sato. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
