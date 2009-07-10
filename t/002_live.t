use strict;
use warnings;

use Test::More tests => 1;

use WWW::YQL;
use List::MoreUtils qw(any);
use Data::Dump qw(pp);

my $yql = WWW::YQL->new;
$yql->useragent->env_proxy;
my $data = $yql->query("show tables");

ok( any { $_ eq 'search.web' } @{ $data->{'query'}{'results'}{'table'} }, 
    'found table search.web' );

$data = $yql->query("select * from search.web where query = 'YQL'");
for my $result ( @{ $data->{'query'}{'results'}{'result'} } ) {
    print $result->{'title'}, "\n";
    print $result->{'abstract'}, "\n";
    print '* ', $result->{'url'}, "\n\n";
}

