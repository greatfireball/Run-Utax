#!/usr/bin/env perl

use strict;
use warnings;

use Run::Utax;

# Make sure that we get the manual printed if no parameters are given
# or help is requested.

use Pod::Usage;

my $man = 0;
my $help = 0;

# check if help or man is given inside of @ARGV
foreach my $param (@ARGV)
{
    if ($param eq "--help" || $param eq "-h")
    {
	$help = 1;
    }

    if ($param eq "--man" || $param eq "-m")
    {
	$man = 1;
    }
}

# if the argument list is empty the help should be printed anyway

$help = 1 unless (@ARGV);

pod2usage(1) if $help;
pod2usage(-exitval => 0, -verbose => 2) if $man;

# if we do not need to provide help we can call the main function of
# the module providing the given arguments
my $utaxrun= Run::Utax->new(@ARGV);

$utaxrun->run();

__END__

=encoding UTF-8

=head1 NAME

run_utax.pl - Perl wrapper to run utax for a given dataset

=head1 SYNOPSIS

  ./run_utax.pl --database utax.db --infile input.fasta --outfile output.fasta

=head1 VERSION

0.1

=head1 DESCRIPTION

The script run_utax is a wrapper to run utax with a given
database/taxonomy on a given dataset.

=head1 PARAMETERS

=head2 --database (required)

Specifies the utax database which will be used for barcoding.

=head2 --taxonomy (required)

Specifies the utax taxonomy which will be used for barcoding.

=head2 --infile (required)

Specifies the sequences which need to be barcoded.

=head2 --outfile

The utax results will be written to that file. If no file name is
provided, the result will be written to STDOUT.

=head2 --utax

This argument indicates the location of the usearch executable
file. This is not required. If not provided via command line option,
the script search for an evirnomental variable USEARCHPROGRAM or as
fallback inside the PATH directories. If no valid program (must be
executable) is found. The script will die.

=head1 AUTHOR

Frank Förster, E<lt>foersterfrank@gmx.deE<gt>

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

