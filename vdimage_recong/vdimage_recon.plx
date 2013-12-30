#!/usr/bin/perl

use OCR::PerfectCR;
use GD;
use Data::Dumper;

my $recognizer = OCR::PerfectCR->new;
$recognizer->load_charmap_file("charmap");
my $image = GD::Image->new("./verifycode.png") or die "Can't open  $!";
my @string = $recognizer->recognize($image);
$recognizer->save_charmap_file("testmap");
print Dumper( @string );
print"------------------------------------------------------";
print $#string;
