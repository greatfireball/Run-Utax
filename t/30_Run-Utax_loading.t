use strict;
use warnings;

use Test::More;
BEGIN { use_ok('Run::Utax') };

# check if we generate a new object instance

new_ok('Run::Utax' => [], 'Empty argument list');
new_ok('Run::Utax' => [
                   '--database', 'all.utax.udb',
		   '--taxonomy', 'all.utax.tax',
                   '--input', 'test.fa',
                   '--output', 'utax.out'
		   ], 'Complete argument list');

done_testing();