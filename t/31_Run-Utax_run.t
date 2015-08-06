use strict;
use warnings;

use Test::More tests => 2;
BEGIN { use_ok('Run::Utax') };

can_ok("Run::Utax", qw(run));
