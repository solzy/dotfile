#!/usr/bin/perl -w 

use LWP::UserAgent;
use HTML::LinkExtor;
use URI::URL;

my @url = "http://mp3.baidu.com/m?f=ms&rf=idx&tn=baidump3&ct=134217728&lf=&rn=&word=traveling+light&lm=-1";
my $ua = LWP::UserAgent->new;

my @unit =();
sub callback{
	my($tag , %attr) = @_;
	return if $tag ne 'a'; #find 'a' format
	push @unit , values %attr;
}

sub extract_link{
	$p = HTML::LinkExtor->new(\&callback);
	$res = $ua->request( HTTP::Request->new(GET => @_) , sub{ $p->parse($_[0]) ;});
	my $base = $res->base;
	@unit = map { $_ = url($_ , $base)->abs;} @unit;
}

sub extract_type{
	my @new_unit = ();
	foreach( @_){
		push(@new_unit , $_) if  $_ =~ /\S+(\.)?mp3.*/;
	}
	@new_unit = join "\n" , @new_unit;
}

my @result = &extract_type( \&extract_link(@url));

sub download{
	foreach(@_){
		`wget -r  $_`;
	}
}

&download( @result );





