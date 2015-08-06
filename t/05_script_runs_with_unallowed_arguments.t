use strict;
use warnings;

use Test::More tests => 1;
use Test::Script 1.10;

my $script_args = ['blib/script/run_utax.pl', 
                   '--database', 'all.utax.udb',
		   '--taxonomy', 'all.utax.tax',
                   '--input', 'test.fa', 
                   '--output', 'utax.out'
                  ];
my %options = (exit => 0);

script_runs($script_args, \%options, "Test if script runs our test set with fasta file");


