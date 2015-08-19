package Run::Utax;

use 5.010000;
use strict;
use warnings;

our @ISA = qw();

our $VERSION = '0.1';

use File::Which qw(which);
use File::Temp qw(tempfile);

use Getopt::Long qw(GetOptionsFromArray :config pass_through);

use Capture::Tiny ':all';

use Bio::SeqIO;

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

=head2 DESTROY

=cut

sub DESTROY
{
    my $self = shift;

    $self->_closeAllHandles();
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

This setter/getter sets or returns the path for the outfile file. It
utilizes the private method _check4_outfile to test if the files
exists and in this case it dies, if the overwrite flag is not set. The
path must indicate the location of a new or an existing and accessable
file (if overwrite is set) to be valid.

=cut

sub outfile
{
    my $self = shift;

    return $self->_check_4_outfile('outfile', @_);
}

=head2 fasta()

This setter/getter sets or returns the path for the fasta file. It
utilizes the private method _check4_outfile to test if the files
exists and in this case it dies, if the overwrite flag is not set. The
path must indicate the location of a new or an existing and accessable
file (if overwrite is set) to be valid.

=cut

sub fasta
{
    my $self = shift;

    return $self->_check_4_outfile('fasta', @_);
}

=head2 tsv()

This setter/getter sets or returns the path for the tsv file. It
utilizes the private method _check4_outfile to test if the files
exists and in this case it dies, if the overwrite flag is not set. The
path must indicate the location of a new or an existing and accessable
file (if overwrite is set) to be valid.

=cut

sub tsv
{
    my $self = shift;

    return $self->_check_4_outfile('tsv', @_);
}

=head2 run()

Runs the usearch command according to the parameter settings.

=cut

sub run
{
    my $self = shift @_;

    $self->_parse_and_check_utax();
    $self->_parse_arguments();

    # I need to create a temporary file for the utax output. The
    # requested output file is required later
    my ($fh, $filename) = tempfile();

    # construct the run command for usearch
    $self->{cmd} = [
	$self->usearchpath(),
	'-utax', $self->infile(),
	'-db',   $self->database(),
	'-tt',   $self->taxonomy(),
	'-utaxout', $filename,
	'-utax_rawscore',
	];

    printf STDERR "Command to run: '%s'\n", join(" ", @{$self->{cmd}});

    # run the external program
    my ($stdout, $stderr, $exit) = capture { system( @{$self->{cmd}} ) };

    # print status messages
    printf STDERR "Exit code for command was %d\n==== Captured STDOUT ====\n%s\n==== Captured STDERR ====\n%s", $exit, $stdout, $stderr;

    # if the exit code was not 0 we need to die
    # uncoverable branch true
    unless ($exit == 0)
    {
        # uncoverable statement
    	die "The call of usearch8 failed!\n";
    }

    # now we need to parse the output:
    # - if a tsv is requested, the file will be created
    # - if a fasta is requested, the file will be created
    # - the raw utax output is copied into the output file which will be created

    # open a tsv file, if requested
    $self->_open4writing('tsv');
    $self->_open4writing('fasta');
    $self->_open4writing('outfile');

    # a handle for the utax output is alread present in $fh
    # reset the position
    seek($fh, 0, 0) || die "Unable to reset file position for file '$filename': $!\n";

    # utax returns a different order of sequences, therefore we need to track the ID lineage pairs
    my %id_lineage = ();

    # if tsv is requested, print a header
    my $tsvFH = $self->{_FH_tsv};
    if ($tsvFH)
    {
	print $tsvFH "#", join("\t", qw(ID kingdom phylum class order family genus species)), "\n";
    }

    # get the output file handle
    my $outFH = $self->{_FH_outfile};

    # loop through the original utax output
    while (<$fh>)
    {
	# write the raw output to the outputfile

	print $outFH $_;

	chomp($_);

	my @fields = split(/\t/, $_);

	# first field contains the id, second field the lineage, third
	# field a plus sign

	my $id = $fields[0];
	my @lineage = split(/,/, $fields[1]);

	# workaround a undocumented utax behavior
	# sometimes it prints two line for an ID, but then the first line contains
	# * for lineage and plus sign
	# skip those lines
	next if ($fields[1] eq "*" && $fields[2] eq "*");

	@lineage = map {
	    $_ =~ /([^_]+)_{1,2}(\d+)\(([\d.]+)\)$/;
	    {sciname => $1, taxid => $2, score => $3}
	} (@lineage);

	# print sciname and score to the tsv
	if ($tsvFH)
	{
	    print $tsvFH join("\t", ($id, map {sprintf "%s (%s)", $_->{sciname}, $_->{score}} (@lineage))), "\n";
	}

	# store the lineage information to the id if not already present
	if (exists $id_lineage{$id})
	{
	    die "utax returned the identical id ($id) twice...\n";
	}

	$id_lineage{$id} = $fields[1];

    }

    # last thing to do is writing the fasta file, if requested
    if (defined $self->{_FH_fasta})
    {

	# we need to open the input data
	my $seqin = Bio::SeqIO->new(
	    -file => $self->{_infile}
	    );

	# let Bio::SeqIO write our output file if we want it
	my $seqout = Bio::SeqIO->new(
	    -format => 'fasta',
	    -fh => $self->{_FH_fasta}
	    );

	# loop through the sequences and add the lineage infomation to
	# the description and write it to the output file

	while (my $inseq = $seqin->next_seq) {
	    my $lin = "n.d.";
	    unless (exists $id_lineage{$inseq->id()})
	    {
		warn "No lineage information for id: ", $inseq->id(), "\n";
	    } else {
		$lin = $id_lineage{$inseq->id()};
	    }
		$inseq->desc($inseq->desc." utax: ".$lin);
		$seqout->write_seq($inseq);
	}

	# done
    }

    # close all files
    $self->_closefile('tsv');
    $self->_closefile('fasta');
    $self->_closefile('outfile');

}

=head1 Private subroutines

=head2 _check_4_outfile

This method is used by fasta/tsv/outfile. It tests if the file exists
and if in that case overwrite is set.

=head3 parameters

First parameter ist the type of the file. This determines the
attribute name. Currently supported are

=over 4

=item a) outfile

=item b) fasta

=item c) tsv

=back

=cut

sub _check_4_outfile
{
    my $self = shift;

    # next parameter is the type
    my $type = shift;
    # the attribute has a leading _
    $type = "_".$type;

    # is another parameter given?
    if (@_)
    {
	# still an argument available so set the path
	my $file_path = shift;

	# check if the file exists and can be accessed
	if (defined $file_path && $file_path ne "-" && -e $file_path && !($self->overwrite))
	{
	    die "Overwriting existing files is not allowed. Use option --force|--overwrite to enable that\n";
	}

	$self->{$type} = $file_path;
    }

    # finally return the value
    return $self->{$type};
}

=head2 _open4writing

This methods checks if a given parameter is defined. If so, it tries
to open the file for writing and stores the filehandle in a attribute

=head3 parameters

The name of the option. So far the following are supported:

=over 4

=item a) outfile

File for the raw utax output

=item b) tsv

A file which contains the utax output as tab seperated file

=item c) fasta

A file which contains the original sequences, but the header of the
sequences are supplemented with the utax lineage for that sequence

=over

=cut

sub _open4writing
{
    my $self = shift;

    # one parameter should be given
    my $file = shift;

    # the private attribute owns a leading underscore
    $file = "_".$file;

    # the attribute for the file handle has a leading _FH
    my $filehandle = "_FH".$file;

    if ($self->{$file})
    {
	# sometimes we want to have the output on stdout, here we can capture that
	if ($self->{$file} ne "-")
	{
	    # create a new file
	    my $fh;
	    open($fh, ">", $self->{$file}) || die "Unable to open the file '$self->{$file}' for writing: $!\n";
	    $self->{$filehandle} = $fh;
	} else {
	    # we want to write to STDOUT
	    $self->{$filehandle} = \*STDOUT;
	}
    }

    return $self;
}

=head2 _closefile

This methods closes a specified file (given by filename) and set the corresponding filehandle to undef.

=cut

sub _closefile
{
    my $self = shift;

    # one parameter should be given
    my $file = shift;

    # the private attribute owns a leading underscore
    $file = "_".$file;

    # the attribute for the file handle has a leading _FH
    my $filehandle = "_FH".$file;

    if (defined $self->{$filehandle} && fileno $self->{$filehandle})
    {
	close($self->{$filehandle}) || die "Unable to close the file '$self->{$file}': $!\n";
    }
    $self->{$filehandle} = undef;

    return $self;
}


=head2 _closeAllHandles

This methods closes all file handles from the file handle attributed.
Should be used as part of the destructor.

=cut

sub _closeAllHandles
{
    my $self = shift;

    # find all attributes which represents filehandles
    my @filehandles = grep {$_ =~ /^_FH_/} (keys %{$self});

    # determine the filename attribute from the filehandle attribute and call _closefile
    foreach my $fh (@filehandles)
    {
	# the filename should be stored in a attribute without the leading _FH
	my $filename = $fh;
	$filename =~ s/^_FH//;

	$self->_closefile($filename);
    }

    return $self;
}

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
    if ((! defined $utax_path) || ($utax_path eq ''))
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
    my $infile    = "";   # no default, as it is required
    my $outfile   = "-";  # default is printing to STDOUT
    my $overwrite = 0;    # default no overwriting
    my $tsv       = undef;  # default undef
    my $fasta     = undef;  # default undef

    my $ret = GetOptionsFromArray(
	$self->{_orig_argv},
	(
	 'database|d=s'      => \$database,
	 'taxonomy|t=s'      => \$taxonomy,
	 'infile|input|i=s'  => \$infile,
	 'outfile|o=s'       => \$outfile,
	 'force|overwrite|f' => \$overwrite,
	 'tsv=s'             => \$tsv,
	 'fasta=s'           => \$fasta,
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

    if ($infile eq "")
    {
	die "No infile file given!";
    }

    # set the values using the setter
    $self->overwrite($overwrite);    # first because it might be required for outfile
    $self->database($database);
    $self->taxonomy($taxonomy);
    $self->infile($infile);
    $self->outfile($outfile);
    $self->fasta($fasta);
    $self->tsv($tsv);

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
