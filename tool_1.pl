#!/usr/bin/perl -w
#@date  2014/03/21
#@version 1.0

use strict;
use warnings;

my $writeFileName = "result.txt";

#recursively traverse all files
sub traverseDir{
	my $dirName = shift ;
	opendir( my $dir , $dirName) or die "unable to open this directory $!\n";
	while( my $fileName = readdir( $dir )){
		if ( $fileName =~  /.*(_macro_log)\.(xml)/ ){
			$dirName =~ s/(\/\.)//g;
			my $path = "$dirName/$fileName";
			print "path: $path\n";
			open( FILE , "<$path" ) or die "file open failed $!\n";
			while( <FILE> ){
				my $linenum = -1;
				$linenum = $2 if $_ =~ /.*(<linenum>)(\d+)(<\/linenum>).*/g;
				next if $linenum == -1 ;
				my $writeContent = $path."\t\t".$linenum;
				print "content :: $writeContent\n";
				open( DATA, "+>>$writeFileName") 
					or die "unable to open $writeFileName file $!\n";
				print DATA  "$writeContent\n";
				close( DATA );
			}
			close( FILE );
		}
		if( -d "$dirName/$fileName"){
			&traverseDir( "$dirName/$fileName");
		}
	}
	close( $dir );
	return $dirName;
}

if( $ARGV[0]){
	traverseDir( $ARGV[0]);
}else{
	&traverseDir( "." );
}
