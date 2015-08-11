use strict;
use warnings;

use Test::More;
use Test::Exception;

BEGIN { use_ok('Run::Utax') };

can_ok("Run::Utax", qw(_parse_and_check_utax));

# check if the parameters are scanned correctly

# 
#
#  Test for correct determination of the usearch location
#
#

# test if we die, if the utax_file could not be found
my $utaxrun = new_ok('Run::Utax' => [], 'Empty argument list');
dies_ok { $utaxrun->_parse_and_check_utax() } 'Program dies, if no usearch is available';

# first case I want to check if a utax program is available
# first condition: utax is avaiable using path
$ENV{PATH} = $ENV{PATH}.":blib/script/";

$utaxrun = new_ok('Run::Utax' => [], 'Empty argument list');
$utaxrun->_parse_and_check_utax();

is($utaxrun->usearchpath, "blib/script/usearch8", 'usearch8 was found using the PATH evironmental variable');

# second condition: utax is avaible using USEARCHPROGRAM as environmental variable
$utaxrun = new_ok('Run::Utax' => [], 'Empty argument list');

$ENV{USEARCHPROGRAM} = "blib/script/usearch8";
$utaxrun->_parse_and_check_utax();

is($utaxrun->usearchpath, "blib/script/usearch8", 'usearch8 was found using the USEARCHPROGRAM evironmental variable');

# third condition: utax is given by command line option --utax
$utaxrun = new_ok('Run::Utax' => ['--utax', 'blib/script/usearch8'], 'utax via long command line argument given');

$utaxrun->_parse_and_check_utax();

is($utaxrun->usearchpath, "blib/script/usearch8", 'usearch8 was found using long comand line option');

$utaxrun = new_ok('Run::Utax' => ['-u', 'blib/script/usearch8'], 'utax via short command line argument given');

$utaxrun->_parse_and_check_utax();

is($utaxrun->usearchpath, "blib/script/usearch8", 'usearch8 was found using short comand line option');

# test if we die, if the utax_file is not executable
$utaxrun = new_ok('Run::Utax' => ['-u', 'data/usearch8_non_exec'], 'unexecutable utax via short command line argument given');
dies_ok { $utaxrun->_parse_and_check_utax() } 'Program dies, if a non executable usearch is used';

done_testing();
