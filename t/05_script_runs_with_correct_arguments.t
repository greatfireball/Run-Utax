use strict;
use warnings;

use Test::More;
use Test::Script 1.10;

$ENV{PATH} = $ENV{PATH}.":blib/script/";

my $script_args = [
                   'blib/script/run_utax.pl',
                   '--database', 'all.utax.udb',
		   '--taxonomy', 'all.utax.tax',
                   '--input', 'test.fa',
                   '--output', 'utax.out',
                  ];
my $options = {
                exit => 0
              };

script_runs($script_args, $options, "Test if script runs our test set with fasta file and utax from PATH");

$ENV{USEARCHPROGRAM} = "blib/script/usearch8";

$script_args = [
                   'blib/script/run_utax.pl',
                   '--database', 'all.utax.udb',
		   '--taxonomy', 'all.utax.tax',
                   '--input', 'test.fa',
                   '--output', 'utax.out'
                  ];
$options = {
                exit => 0
              };

script_runs($script_args, $options, "Test if script runs our test set with fasta file and utax from USEARCHPROGRAM");

$script_args = [
                   'blib/script/run_utax.pl',
                   '--database', 'all.utax.udb',
		   '--taxonomy', 'all.utax.tax',
                   '--input', 'test.fa',
                   '--output', 'utax.out',
		   '--utax', 'blib/script/usearch8'
                  ];
$options = {
                exit => 0
              };

script_runs($script_args, $options, "Test if script runs our test set with fasta file and given utax program");

done_testing();
