use strict;
use warnings;

use Test::More tests => 1;
use Test::Script 1.10;

my $script = 'blib/script/run_utax.pl';
my %options = (exit => 1);

script_runs($script, \%options, "Test if script runs without parameters");
