use strict;
package WWW::YQL;
{
  $WWW::YQL::VERSION = '0.001';
}
use warnings;
use Moose;
use URI;
use URI::QueryParam;
use LWP::UserAgent;
use JSON::Any;


# ABSTRACT: Module for YQL queries
# PODNAME: WWW::YQL

has 'ua' => (
    is  => 'rw',
    isa => 'Object',
    predicate => 'has_ua',
    );

has 'json_parser' => (
    is  => 'rw',
    isa => 'Object',
    predicate => 'has_json_parser',
    );


sub BUILD{
    my $self=shift;
    $self->ua(new LWP::UserAgent());
    $self->json_parser(new JSON::Any)
}


sub query{
    my $self=shift;
    my $query=shift;
    die "No query string specified for WWW::YQL->query()" unless defined $query;

    my $URI=URI->new('http://query.yahooapis.com/v1/public/yql');
    my $res;
    my $req;
    if ($query =~ m/^insert/){
	$res = $self->{'ua'}->post($URI, {
	    'q'      => $query,
	    'format' => 'json',
				   });
    }else{
	$URI->query_form( 'q' => $query );
	$URI->query_param( 'format'   => 'json' );
	$req = HTTP::Request->new(GET => $URI);
	$res = $self->{'ua'}->request($req);
    }
    if ($res->is_success) {
        return $self->json_parser->decode($res->content);
    }
    else {
        warn "$URI status ".$res->status_line;
        return "Bad request: $query";
    }

}

1;


__END__
=pod

=head1 NAME

WWW::YQL - Module for YQL queries

=head1 VERSION

version 0.001

=head1 SYNOPSIS

    use WWW::YQL;
    
    my $yql = WWW::YQL->new();
    my $data = $yql->query("show tables");

    foreach my $table ( @{ $data->{'query'}{'results'}{'table'} }){
        print "$table\n";
    }

    $data = $yql->query("insert into yahoo.y.ahoo.it (url) values ('http://search.cpan.org/~cwimmer/')");
    
    my $shorty=$data->{'query'}->{'results'}->{'url'};

    The User Agent that will be used to make the connection is available
    from the ua() method.  You may make changes to the User Agent
    before running the query() method.

=head2 DESCRIPTION

    This module is used to submit YQL queries and receive their responses.

=head1 METHODS

=head2 query

    This method takes one argument, a string.  The string is the YQL
    query string for this request.

    The return value is a has reference representing the result from
    the YQL service.

=head1 KNOWN BUGS

None known at this time.  Please log issues at: 

https://github.com/cwimmer/WWW-YQL/issues

=head1 AVAILABILITY

Source code is available on GitHub:

https://github.com/cwimmer/WWW-YQL

Module available on CPAN as WWW::YQL:

http://search.cpan.org/~cwimmer/

=for Pod::Coverage BUILD

=head1 AUTHOR

Charles A. Wimmer <charles@wimmer.net>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2012 by Charles A. Wimmer.

This is free software, licensed under:

  The (three-clause) BSD License

=cut

