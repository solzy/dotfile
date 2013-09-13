#!/usr/bin/perl -w
#@description:
#@Author	zhangyun<zhangyun@book.sina.com>
#@date		2013/08/13
#@version	id:0.1

use Text::SimpleTable::AutoWidth;
use File::Find::Node;
use strict;
use warnings;
#consturctor
my(%descriptions,%properties,%classnames,%functions,@filenames)=();

#$ARGV[0] is path name;
my $f = File::Find::Node->new( $ARGV[0] );
$f->process(sub{
		my (@filedescription,@classname , @function , @property);
 		my $file=shift;
		my $filename = $file->name;
		push @filenames,$filename ;
		open MYFILE , $file->path or die "open file failed\n" if $filename =~ /.*\.php/ && (-s $file->path)>0;
#		open MYFILE , $file->path or die "open file failed\n" ;
		while( <MYFILE> ){
			push @filedescription,$1 if $_ =~ /\s*\*+\s*(@(Copyright|author|since|date|version|abstract){1}[^param|return].*)/g;
			push @classname,$1 if $_ =~ /\s*class\s+(\w+)\s+{?$/g;
			push @function,$3 if $_ =~ /\s*(private|public|protected){1}\s+(static\s+)?function\s+(\w+\s*\(.*\))\s*{?$/g;
			push @property,$4 if $_ =~ /\s*(static\s+)?(public|protected|private|const){1}\s+(static\s+)?(\$\w+)\s*=?/g;
		}
		$descriptions{ $filename }="\t".(join "\n\t>> " ,@filedescription) ;
		$properties{ $filename }="\t".(join "\n\t>> " ,@property );
		$classnames{ $filename }="\t".(join "\n" ,@classname );
		$functions{ $filename }="\t".(join "\n\t>> " ,@function );
		#print @filenames;
	});
#$f->filter(sub{sort @_ });
$f->find;

sub formatOutput{
	my  @filename=@_;
	foreach(@filename){
#		print Text::SimpleTable
#		->new(  [10 ,'FileName'], [10,'ClassName'], [20,'Properties'], [50,'Description'], [120 ,'Functions'])
#		->row( $_ ,$classnames{$_},$properties{$_},$descriptions{$_}, $functions{$_})
#		->draw();
		print "|--------------------------------------------------------------------------|\n";
		print "|the filename: << $_ >>|\n";
		print "|--------------------------------------------------------------------------|\n";
		print "|the classname =>" , $classnames{$_},"|\n";
		print "|--------------------------------------------------------------------------|\n";
		print "|the properties =>|\n" , $properties{$_}, "\n";
		print "|--------------------------------------------------------------------------|\n";
		print "the description: =>|\n" ,$descriptions{$_}, "\n";
		print "|--------------------------------------------------------------------------|\n";
		print "|the functions => |\n" , $functions{$_}, "\n";
		print "|--------------------------------------------------------------------------|\n";
	}
}


&formatOutput( @filenames );

#while( (my $key, my $value)= each %descriptions){
#	print "the filename: << $key >>\n";
#	print "the description: =>\n" ,$descriptions{$key}, "\n";
#}

