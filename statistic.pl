#!/usr/bin/perl -w 

#set HQL numbers of each query within TPC-H  
#no-repeat test set
my @queryNum = ( 1,7,1,4,1,
				 1,4,1,1,1,
				 7,1,1,1,7,
				 7,4,4,1,13,
				 7,10);
my %statistic ;
my @queryid=(0);
my ($counter,$i,$runtime) = (0,0,0);
while(<STDIN>){
	chomp($_);
	if(m/^Time taken: ([\d]+\.?[\d]*) seconds.*$/){
		$counter++;
		$runtime += $1;
		if($counter == $queryNum[$i]){
			$queryid = "q_".(++$i);
			push @queryid,$queryid;
			$statistic{$queryid}= $runtime;
			($counter,$runtime) = (0,0);
		}
	}
}

print "Run time of each query:\n";
foreach (@queryid){
	print "$_ => $statistic{$_} seconds\n" if exists $statistic{$_};
}
