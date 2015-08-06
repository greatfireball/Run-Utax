use strict;
use warnings;

use Test::More tests => 1;
use Test::Script;

script_runs('blib/script/run_utax.pl', "Test if script runs without parameters");
