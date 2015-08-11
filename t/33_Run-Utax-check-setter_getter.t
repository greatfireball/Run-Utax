use strict;
use warnings;

use Test::More;
use Test::Exception;

BEGIN { use_ok('Run::Utax') };

# Here we test, if all required setter/getter are avaiable
can_ok("Run::Utax", qw(usearchpath));
can_ok("Run::Utax", qw(database));
can_ok("Run::Utax", qw(taxonomy));
can_ok("Run::Utax", qw(infile));
can_ok("Run::Utax", qw(overwrite));
can_ok("Run::Utax", qw(outfile));

#
# create object instance
#
my $utaxrun = new_ok('Run::Utax' => [], 'Empty command line given');

#
# usearchpath
#
my $expected_path = 'blib/script/usearch8';

# setting should work without dying
lives_ok { $utaxrun->usearchpath($expected_path) } 'Program should not die with a executable usearch path';
# afterwards, the expected path should be retured
is($utaxrun->usearchpath(), $expected_path, 'Setting usearchpath seems to work');
# setting of a non executable program should die the program
dies_ok { $utaxrun->usearchpath('data/usearch8_non_exec') } 'Program dies, if a non executable usearch is used';
# setting of a non existing program should die the program
dies_ok { $utaxrun->usearchpath('data/usearch8_non_exec2') } 'Program dies, if a non existing usearch is used';

done_testing();
