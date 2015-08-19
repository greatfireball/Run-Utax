use strict;
use warnings;

use Test::More;
use Test::Exception;
use File::Temp qw(tempfile);

BEGIN { use_ok('Run::Utax') };

my $expected_db   = 'data/example.utax.udb';
my $expected_tax  = 'data/example.utax.tax';
my $expected_in   = 'data/example.multipletimes.fa';
my ($fh, $expected_out)  = tempfile();
my $usearch_path  = 'data/usearch8';

my $utaxrun = new_ok('Run::Utax' => [
	 '--database', $expected_db,
	 '--taxonomy', $expected_tax,
	 '--infile',   $expected_in,
	 '--outfile',  $expected_out,
	 '--utax', $usearch_path,
	 '--force'
	 ], 'Setting the database/taxonomy/infile/outfile using the long version');

throws_ok { $utaxrun->run() } qr/utax returned the identical id \S+ twice/, 'Program dies when a ID occurs more than once';

done_testing();