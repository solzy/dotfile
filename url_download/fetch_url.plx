#!/usr/bin/perl -w

 use strict;
 use 5.010;
 use LWP::UserAgent;

my $file;
my $ua = LWP::UserAgent->new;
$ua->timeout(1000);
my $GetURL="http://search.cpan.org/";
my $req = new HTTP::Request ('GET' , $GetURL);
my $res = $ua->request($req);
if ($res->is_success){
	my $temp = $res->content;
	print $temp."\n";
}



