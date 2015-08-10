use strict;
use warnings;

use Test::More;
BEGIN { use_ok('Run::Utax') };

# check if we generate a new object instance

new_ok('Run::Utax' => [], 'Empty argument list');

done_testing();