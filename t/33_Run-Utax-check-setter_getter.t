use strict;
use warnings;

use Test::More;

BEGIN { use_ok('Run::Utax') };

# Here we test, if all required setter/getter are avaiable
can_ok("Run::Utax", qw(usearchpath));

TODO: {
   local $TODO = "Setter/Getter need to get implemented";

   can_ok("Run::Utax", qw(database));
   can_ok("Run::Utax", qw(taxonomy));
   can_ok("Run::Utax", qw(infile));
   can_ok("Run::Utax", qw(outfile));
   can_ok("Run::Utax", qw(overwrite));
}

done_testing();
