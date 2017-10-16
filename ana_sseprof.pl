#!/usr/bin/perl

#check the commond line
if (@ARGV ne 1) {
	printf STDERR "ana_sseprof.pl <sseprof output>\n";
	printf STDERR "analyze secondary structure composition\n";
	exit;
}
#check if the pdb file exists
if (not -f $ARGV[0]) {
	printf STDERR "sseprof file doesn't exist\n";
	exit;
}
#secondary structure
open(SSE, $ARGV[0]);
@ssetxt = <SSE>, $sselen = @ssetxt;
close(SSE);
#initialization
$nE = $nH = $nC = 0;
#counting
for ($i = 0; $i < $sselen; $i++) {
	chomp $ssetxt[$i];
	@arr = split / +/, $ssetxt[$i];
	$narr = @arr;
	if ($arr[$narr - 1] eq "E") {
		$nE++;
	}
	elsif ($arr[$narr - 1] eq "H") {
		$nH++;
	}
	elsif ($arr[$narr - 1] eq "C") {
		$nC++;
	}
}
$percH = $nH * 100.0 / $sselen;
$percE = $nE * 100.0 / $sselen;
printf ("%6.1f %6.1f\n", $percH, $percE);
