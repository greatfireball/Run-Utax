use 5.010000;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Run::Utax',
    VERSION_FROM      => 'lib/Run/Utax.pm', # finds $VERSION
    PREREQ_PM         => {
	'Test::Script' => 1.10,  # this script is required to test the wrapper script
	'File::Which'  => 0,     # to determine the location of usearch8
	'Test::Exception' => 0,  # needed to test for die statements
	'Getopt::Long' => 0,
    }, 
    EXE_FILES         => [
	"bin/run_utax.pl",
    ],
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Run/Utax.pm', # retrieve abstract from module
       AUTHOR         => 'Frank Förster <frank@>') : ()),
);
