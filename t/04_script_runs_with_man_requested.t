use strict;
use warnings;

use Test::More tests => 4;
use Test::Script 1.10;

my $script_args = ['blib/script/run_utax.pl', '-m'];
my %options = (exit => 0);

script_runs($script_args, \%options, "Test if script runs with -m as argument");
script_stdout_like(qr/RUN_UTAX|NAME/, "Result of run with -m as argument returned a perldoc output");

$script_args = ['blib/script/run_utax.pl', '--man'];

script_runs($script_args, \%options, "Test if script runs with --man as argument");
script_stdout_like(qr/RUN_UTAX|NAME/, "Result of run with --man as argument returned a perldoc output");
