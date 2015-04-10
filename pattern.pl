#!/usr/bin/perl

while(<>){
	print "$2\n" if $_ =~ m/\s*(\w+)\s*(\w+).*/g
}
