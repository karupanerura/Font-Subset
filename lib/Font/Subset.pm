package Font::Subset;
use 5.008_001;
use strict;
use warnings;
use utf8;

our $VERSION = '0.01';

use Carp qw/croak/;
use Font::Subset::TTF;

sub new {
    my($class, $file, $type) = @_;

    unless ($type) {
        if ($file =~ /\.ttf\z/i) {
            $type = 'TTF';
        }
        else {
            croak "cannot guess type: '${file}'";
        }
    }

    if ($type =~ /\A TTF \z/xi) {
        return Font::Subset::TTF->new($file);
    }
    else {
        croak "unknown type: $type";
    }
}

1;
__END__

=head1 NAME

Font::Subset - Perl extention to do something

=head1 VERSION

This document describes Font::Subset version 0.01.

=head1 SYNOPSIS

    use Font::Subset;

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
