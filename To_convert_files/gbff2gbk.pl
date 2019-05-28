#!/usr/bin/perl

open (IN, $ARGV[0]);
@file = <IN>;
$cc;
for $i (@file) {
	if ($i =~ m/^LOCUS/){
		$outputname = $i;
		$outputname =~ s/LOCUS[ ]+//g;
		$outputname =~ s/[ ]+.+//g;
		$outputname =~ s/\s//g;
		$outputname .= "\.gbk";
		open (OUT, ">$outputname");
		print OUT ($i);
	}
	else{
		print OUT ($i);
	}
}
	
