package Run::Utax;

use 5.010000;
use strict;
use warnings;

our @ISA = qw();

our $VERSION = '0.1';

use File::Which qw(which);
use Getopt::Long qw(GetOptionsFromArray :config pass_through);

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

This setter/getter sets or returns the path for the usearch
program. The path must indicate the location of a executable file to
be valid.

=cut

sub usearchpath
{
    my $self = shift;

    # is a parameter given?
    if (@_)
    {
	# still an argument available so set the path
	my $utax_path = shift;

	# before using the command, we want to check if it is executable
	unless (-x $utax_path)
	{
	    die "Unable to execute the usearch file on location '$utax_path'\n";
	}

	$self->{_utaxpath} = $utax_path;
    }

    # finally return the value
    return $self->{_utaxpath};
}

=head2 database()

This setter/getter sets or returns the path for the database file.
The path must indicate the location of a existing and accessable file
to be valid.

=cut

sub database
{
    my $self = shift;

    # is a parameter given?
    if (@_)
    {
	# still an argument available so set the path
	my $database_path = shift;

	# check if the file exists and can be accessed
	unless (-e $database_path)
	{
	    die "Unable to access the database file on location '$database_path'\n";
	}

	$self->{_database} = $database_path;
    }

    # finally return the value
    return $self->{_database};
}

=head2 taxonomy()

This setter/getter sets or returns the path for the taxonomy file.
The path must indicate the location of a existing and accessable file
to be valid.

=cut

sub taxonomy
{
    my $self = shift;

    # is a parameter given?
    if (@_)
    {
	# still an argument available so set the path
	my $taxonomy_path = shift;

	# check if the file exists and can be accessed
	unless (-e $taxonomy_path)
	{
	    die "Unable to access the taxonomy file on location '$taxonomy_path'\n";
	}

	$self->{_taxonomy} = $taxonomy_path;
    }

    # finally return the value
    return $self->{_taxonomy};
}

=head2 infile()

This setter/getter sets or returns the path for the infile file.
The path must indicate the location of a existing and accessable file
to be valid.

=cut

sub infile
{
    my $self = shift;

    # is a parameter given?
    if (@_)
    {
	# still an argument available so set the path
	my $infile_path = shift;

	# check if the file exists and can be accessed
	unless (-e $infile_path)
	{
	    die "Unable to access the infile on location '$infile_path'\n";
	}

	$self->{_infile} = $infile_path;
    }

    # finally return the value
    return $self->{_infile};
}

=head2 overwrite()

This setter/getter sets or returns the status of overwrite flag.
Allowed values are 0 for disabled and 1 for enabled overwriting.


=cut

sub overwrite
{
    my $self = shift;

    # is a parameter given?
    if (@_)
    {
	# still an argument available so set the path
	my $overwrite = shift;

	# convert it into a number
	$overwrite = $overwrite+0;

	# check if the value is allowed
	unless ($overwrite == 0 || $overwrite == 1)
	{
	    die "Allowed values for overwrite setter are 0 for disabling and 1 for enabling overwriting\n";
	}

	$self->{_overwrite} = $overwrite;
    }

    # finally return the value
    return $self->{_overwrite};
}

=head2 outfile()

This setter/getter sets or returns the path for the outfile
file. Moreover, it checks, if the files exists and in this case it
dies, if the overwrite flag is not set. The path must indicate the
location of a new or an existing and accessable file (if overwrite is
set) to be valid.

=cut

sub outfile
{
    my $self = shift;

    # is a parameter given?
    if (@_)
    {
	# still an argument available so set the path
	my $outfile_path = shift;

	# check if the file exists and can be accessed
	if (-e $outfile_path && !($self->overwrite))
	{
	    die "Overwriting existing files is not allowed. Use option --force|--overwrite to enable that\n";
	}

	$self->{_outfile} = $outfile_path;
    }

    # finally return the value
    return $self->{_outfile};
}

=head2 run()

Runs the usearch command according to the parameter settings.

=cut

sub run
{
    my $self = shift @_;

    $self->_parse_and_check_utax();
    $self->_parse_arguments();
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

    # if a environmental variable USEARCHPROGRAM is given, than use that
    if (exists $ENV{USEARCHPROGRAM})
    {
	$utax_path = $ENV{USEARCHPROGRAM};
    }

    # finally we try to parse the command line options
    GetOptionsFromArray($self->{_orig_argv},
			'utax|u=s' => \$utax_path
	);

    # did we succeed in finding a usearch file?
    unless (defined $utax_path)
    {
	die "Unable to find usearch program!\n";
    }

    # now set the progam path
    $self->usearchpath($utax_path);

    return $self;
}

=head2 _parse_arguments()

This subroutine checks is the other arguments for validity.

=back

=cut

sub _parse_arguments
{

    my $self = shift;

    # the command line arguments are stored in _argv_orig

    # first we want to get the parameter settings
    my $database  = "";   # default empty, as it is required
    my $taxonomy  = "";   # no default, as it is required

    my $ret = GetOptionsFromArray(
	$self->{_orig_argv},
	(
	 'database|d=s' => \$database,
	 'taxonomy|t=s' => \$taxonomy,
	));

    # check if required parameters are set
    if ($database eq "")
    {
	die "No database given!";
    }

    if ($taxonomy eq "")
    {
	die "No taxonomy file given!";
    }

    # set the values using the setter
    $self->database($database);
    $self->taxonomy($taxonomy);
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
