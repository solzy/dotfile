#!/usr/bin/perl -w

my( @word , @words , %hash , $lines , $keys);
while( <> ){
	chomp( $lines = $_ );
	@word = split /(\s+|[^a-zA-Z])/,$lines;
	foreach( @word ){
		if( $_ =~ /^[a-zA-Z]+$/){
			push @words , $_;
		}
	}
}
foreach( @words ){
	$hash{ $_ } += 1;
}
foreach $keys ( sort keys %hash ){
	$values = $hash{ $keys };
	print" $keys => $values\n";
}
foreach( &sort( values %hash ) ){
	print"the value sort is: $_\n";
}
sub sort{
	my ($a , @params ) =  ( 0  , @_);
	print"\@_ is @params\n";
	for( my $i = 0 ; $i < @params - 1 ; $i++ ){
		for( my $j = 0  ; $j < @params - $i  ; $j++ ){
				if($params[$j] < $params[$j + 1]){
					$a = $params[$j];
					$params[$j] = $params[$j + 1];
					$params[$j + 1] = $a;
				}
		}
	}  
	@params;
}
			
