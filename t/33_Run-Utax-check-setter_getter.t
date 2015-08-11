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

#
# recreate object instance
#
$utaxrun = new_ok('Run::Utax' => [], 'Empty command line given');

#
# database
#
$expected_path = 'data/example.utax.udb';
# setting should work without dying
lives_ok { $utaxrun->database($expected_path) } 'Program should not die with a accessable database file';
# afterwards, the expected path should be retured
is($utaxrun->database(), $expected_path, 'Setting database seems to work');
# setting of a non existing file should die the program
dies_ok { $utaxrun->database($expected_path."2") } 'Program dies, if a non existing database is used';

#
# recreate object instance
#
$utaxrun = new_ok('Run::Utax' => [], 'Empty command line given');

#
# taxonomy
#
$expected_path = 'data/example.utax.tax';
# setting should work without dying
lives_ok { $utaxrun->taxonomy($expected_path) } 'Program should not die with a accessable taxonomy file';
# afterwards, the expected path should be retured
is($utaxrun->taxonomy(), $expected_path, 'Setting taxonomy seems to work');
# setting of a non existing file should die the program
dies_ok { $utaxrun->taxonomy($expected_path."2") } 'Program dies, if a non existing taxonomy file is used';

done_testing();
