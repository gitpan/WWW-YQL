

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'WWW::YQL',
    VERSION_FROM => 'lib/WWW/YQL.pm', # finds \$VERSION
    AUTHOR       => 'Viorel Stirbu (cpan@stirbu.name)',
    ABSTRACT     => 'Simple interface for Yahoo Query Language',
    PREREQ_PM    => {
        'Test::Simple' => 0.44,
        'JSON::Any' => undef,
    },
);
