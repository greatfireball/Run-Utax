package Run::Utax;

use 5.010000;
use strict;
use warnings;

our @ISA = qw();

our $VERSION = '0.1';

use File::Which qw(which);

=head2 new()

This subroutine creates a new object instance of Run::Utax

=cut

sub new
{
    my $class = shift @_;

    $class = ref($class) || $class;

    my $self = {};

    # are there more arguments given? if yes store them in orig_argv
    if (@_) {
	$self->{_orig_argv} = \@_;
    } else {
    # if not, keep the array empty
	$self->{_orig_argv} = [];
    }

    bless $self, $class;

    return $self;
}

=head2 usearchpath

This setter/getter sets or returns the path for the usearch program

=cut

sub usearchpath
{
    my $self = shift;

    if (@_)
    {
	# still an argument available so set the path
	my $param = shift;
	$self->{_utaxpath} = $param;
    }

    # finally return the value
    return $self->{_utaxpath};
}

sub run
{

    my $self = shift @_;

    $self->_parse_and_check_utax();

}

=head1 Private subroutines

=head2 _parse_and_check_utax()

This subroutine checks is the utax program is available. Therefore the user can provide the program using three different ways:

=over 4

=item 1) Program usearch is available in path

=item 2) Environmental variable USEARCHPATH

=item 3) Parameter -usearchpath

=back

=cut

sub _parse_and_check_utax
{
    my $self = shift;

    # check if we have a usearch program available in the PATH
    my $utax_path = which('usearch8');

    # if the search using the PATH variable wasn't successful we need
    # to search for USEARCHPROGRAM
    if (! defined $utax_path && exists $ENV{USEARCHPROGRAM})
    {
	$utax_path = $ENV{USEARCHPROGRAM};
    }

    # did we succeed in finding a usearch file?
    unless (defined $utax_path)
    {
	die "Unable to find usearch program!\n";
    }

    # before using the command, we want to check if it is executable
    unless (-x $utax_path)
    {
	die "Unable to execute the usearch file on location '$utax_path'\n";
    }

    # here we have the program
    $self->usearchpath($utax_path);

    return $self;
}

1;
__END__

=head1 NAME

Run::Utax - Perl module which is utilized by the run_utax.pl script

=head1 SYNOPSIS

  use Run::Utax;

=head1 DESCRIPTION

=head1 SEE ALSO

=head1 AUTHOR

Frank Förster, E<lt>foersterfrank@gmx.de<gt>

=head1 COPYRIGHT AND LICENSE

The MIT License (MIT)

Copyright (c) 2009-2015 Frank Förster

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

=cut
