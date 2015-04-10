#!/bin/perl
use strict;
use File::Find;

my $path="/home/zhangyun/tools/hadoop-2.6.0-src";
my (%level ,%isEnable );

sub subroutine{
	my $file = $File::Find::name ;
	if( -f $file && $file =~ /\.java$/){
		open F, $file or print "cloud not open $file\n";
		while(<F>){
			if(/\W+(LOG\.\w+)\(.*/m){
				if(/(LOG\.is\w+)\(.*/m){
					$isEnable{$1} += 1 ;
				}else{
					$level{$1} += 1;
				}
			}	
		}
	}
}

find(\&subroutine,$path);

print ">>>> LOG level: ".keys(%level)."\n";
foreach( keys %level){
	print "\t $_ => $level{$_}\n";
}

print ">>>> is enable option: ".keys(%isEnable)."\n";
foreach( keys %isEnable){
	print "\t$_ => $isEnable{$_}\n";
}
