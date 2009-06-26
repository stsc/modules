package DateTime::Format::Natural::Test;

use strict;
use warnings;
use base qw(Exporter);
use boolean qw(true);

use Test::More;

our ($VERSION, @EXPORT, %time);

$VERSION = '0.01';

%time = (
    year   => 2006,
    month  => 11,
    day    => 24,
    hour   => 1,
    minute => 13,
    second => 8,
);
@EXPORT = qw(%time _run_tests _message);

sub _run_tests
{
    my ($tests, $sets, $check) = @_;

    local $@;

    if (eval "require Date::Calc") {
        plan tests => $tests * 2;
        foreach my $set (@$sets) {
            $check->(@$set);
        }
    }
    else {
        plan tests => $tests;
    }

    $DateTime::Format::Natural::Compat::Pure = true;

    foreach my $set (@$sets) {
        $check->(@$set);
    }
}

sub _message
{
    my ($msg) = @_;

    my $how = $DateTime::Format::Natural::Compat::Pure
      ? '(using DateTime)'
      : '(using Date::Calc)';

    return "$msg $how";
}

1;
__END__

=head1 NAME

DateTime::Format::Natural::Test - Common test routines

=head1 SYNOPSIS

 Please see the DateTime::Format::Natural documentation.

=head1 DESCRIPTION

The C<DateTime::Format::Natural::Test> class exports common test routines.

=head1 SEE ALSO

L<DateTime::Format::Natural>

=head1 AUTHOR

Steven Schubiger <schubiger@cpan.org>

=head1 LICENSE

This program is free software; you may redistribute it and/or
modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut