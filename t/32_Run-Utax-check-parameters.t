use strict;
use warnings;

use Test::More;
BEGIN { use_ok('Run::Utax') };

can_ok("Run::Utax", qw(_parse_and_check_utax));

# Here we test, if all required setter/getter are avaiable
can_ok("Run::Utax", qw(usearchpath));

# check if the parameters are scanned correctly

# 
#
#  Test for correct determination of the usearch location
#
#

# first case I want to check if a utax program is available
# first condition: utax is avaiable using path
$ENV{PATH} = $ENV{PATH}.":blib/script/";

my $utaxrun = new_ok('Run::Utax' => [], 'Empty argument list');
$utaxrun->_parse_and_check_utax();

is($utaxrun->usearchpath, "blib/script/usearch8", 'usearch8 was found using the PATH evironmental variable');

# second condition: utax is avaible using USEARCHPROGRAM as environmental variable
$utaxrun = new_ok('Run::Utax' => [], 'Empty argument list');

$ENV{USEARCHPROGRAM} = "blib/script/usearch8";
$utaxrun->_parse_and_check_utax();

is($utaxrun->usearchpath, "blib/script/usearch8", 'usearch8 was found using the USEARCHPROGRAM evironmental variable');

done_testing();