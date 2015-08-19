use strict;
use warnings;

use Test::More;
use Test::Exception;
use File::Temp qw(tempfile);

use Test::File::Contents;

BEGIN { use_ok('Run::Utax') };

my $expected_db   = 'data/example.utax.udb';
my $expected_tax  = 'data/example.utax.tax';
my $expected_in   = 'data/example.missing_lineage.fa';
my (undef, $out)  = tempfile();
my (undef, $fasta) = tempfile();
my (undef, $tsv)  = tempfile();
my $usearch_path  = 'data/usearch8';

my $utaxrun = new_ok('Run::Utax' => [
	 '--database', $expected_db,
	 '--taxonomy', $expected_tax,
	 '--infile',   $expected_in,
	 '--outfile',  $out,
	 '--fasta',  $fasta,
	 '--tsv',  $tsv,
	 '--utax', $usearch_path,
	 '--force'
	 ], 'Setting the database/taxonomy/infile/outfile using the long version');

lives_ok { $utaxrun->run() } 'Program works when a lineage for an ID is missing';

files_eq($out, "data/example.missing_lineage.fa.out.raw.expected", "Output file contains the expected output");
files_eq($fasta, "data/example.missing_lineage.fa.out.fasta.expected", "Output fasta file contains the expected output");
files_eq($tsv, "data/example.missing_lineage.fa.out.tsv.expected", "Output tsv file contains the expected output");

done_testing();