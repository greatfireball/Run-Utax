use strict;
use warnings;

use Test::More;
use Test::Script 1.10;

use Test::File::Contents;

use File::Temp;

my (undef, $filename) = File::Temp::tempfile(OPEN => 0);

my $script_args = [
                   'blib/script/run_utax.pl',
                   '--database', 'data/example.utax.udb',
		   '--taxonomy', 'data/example.utax.tax',
                   '--input', 'data/example.fa',
                   '--outfile', $filename,
		   '--utax',  'data/usearch8'
                  ];
my $options = {
                exit => 0
              };

script_runs($script_args, $options, "Test if script runs our test set with fasta file and given utax program");

files_eq($filename, "data/out.expected", "Output file contains the expected output");

$script_args = [
                   'blib/script/run_utax.pl',
                   '--database', 'data/example.utax.udb',
		   '--taxonomy', 'data/example.utax.tax',
                   '--input', 'data/example.fa',
                   '--outfile', $filename,
		   '--utax',  'data/usearch8'
                  ];
$options = {
                exit => 2
              };

script_runs($script_args, $options, "Test if script runs our test set with fasta file and given utax program");

$script_args = [
                   'blib/script/run_utax.pl',
                   '--database', 'data/example.utax.udb',
		   '--taxonomy', 'data/example.utax.tax',
                   '--input', 'data/example.fa',
                   '--outfile', $filename,
		   '--utax',  'data/usearch8',
		   '--force'
                  ];
$options = {
                exit => 0
              };

script_runs($script_args, $options, "Test if script runs our test set with fasta file and given utax program");

files_eq($filename, "data/out.expected", "Output file contains the expected output");

my (undef, $tsvout) = File::Temp::tempfile;
my (undef, $fastaout) = File::Temp::tempfile;

$script_args = [
                   'blib/script/run_utax.pl',
                   '--database', 'data/example.utax.udb',
		   '--taxonomy', 'data/example.utax.tax',
                   '--input', 'data/example.fa',
                   '--outfile', $filename,
		   '--utax',  'data/usearch8',
		   '--force',
		   '--tsv' , $tsvout,
		   '--fasta', $fastaout,
                  ];
$options = {
                exit => 0
              };

script_runs($script_args, $options, "Test if script runs our test set with fasta file and given utax program");

files_eq($filename, "data/out.expected", "Output file contains the expected output");
files_eq($tsvout, "data/tsv.expected", "Output tsv file contains the expected output");
files_eq($fastaout, "data/fasta.expected", "Output fasta file contains the expected output");

done_testing();
