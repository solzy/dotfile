#!/usr/bin/perl

use lib 'lib';
use Test::More tests => 28;
use strict;
use OCR::PerfectCR;
use warnings;
use Data::Dumper;

$| = 1;

use_ok('OCR::PerfectCR');

my $pcr = OCR::PerfectCR->new();
isa_ok($pcr, 'OCR::PerfectCR');

can_ok($pcr, 'recognise');
can_ok($pcr, 'recognize');

use_ok('GD');

$pcr->load_charmap_file('charmap');

my $testimage = GD::Image->new('1.png');
isa_ok($testimage, 'GD::Image');

my $parsed = $pcr->recognize($testimage);
is($parsed, " about it.", "Scalar context recognize (1)");

$parsed = $pcr->recognize(GD::Image->new('2.png'));
is($parsed, "about it.", "Scalar context recognize (2)");

my @parsed = $pcr->recognize($testimage);
my $d= Dumper \@parsed;
print "---------------------------------------------------------------------";
$d =~ s/\n/\n# /;
$d = "# $d";
print $d;
is(0+@parsed, 10, 'List parse correct length');

my @str = split //, ' about it.';
for (0..$#parsed) {
  is($parsed[$_]{str}, $str[$_], "List parse char $_ has correct str.");
  if ($parsed[$_]{str} ne ' ') {
    is($parsed[$_]{color}, 180, "List parse char $_ has correct color.");
  }
}

$pcr->save_charmap_file('charmap3');

my $a = do {local (@ARGV, $/) = 'charmap'; <>};
my $b = do {local (@ARGV, $/) = 'charmap3'; <>};

is($a, $b, "Load-save charmap cycle non-lossy");
