#!/usr/bin/perl

#check command line
if (@ARGV != 1) {
	print STDERR "usuage: bbconstraint.pl <tinker_xyz_file>\n";
	exit;
}
open(PROXYZ, $ARGV[0]);
@xyztxt = <PROXYZ>;
close(PROXYZ);
my $xyzlen = @xyztxt;
for ($j = 1; $j < $xyzlen; $j++) {
	@dual = split(/ +/, $xyztxt[$j]);
	$atomnum[$j] = $dual[1];
	$atonname[$j] = substr($xyztxt[$j], 7, 3);
}
for ($j = 2; $j < $xyzlen; $j++) {
	if ($atonname[$j - 1] eq "N" && $atonname[$j] eq "CT" && $atonname[$j + 1] eq "C" && $atonname[$j + 2] eq "O") {
		printf "%-8s %6d %6d %6d %6d\n", "inactive", $j - 1, $j, $j + 1, $j + 2;
	}
	if ($atonname[$j - 1] eq "N3" && $atonname[$j] eq "CT" && $atonname[$j + 1] eq "C" && $atonname[$j + 2] eq "O") {
		printf "%-8s %6d %6d %6d %6d\n", "inactive", $j - 1, $j, $j + 1, $j + 2;
	}
	if ($atonname[$j - 1] eq "N" && $atonname[$j] eq "CT" && $atonname[$j + 1] eq "C" && $atonname[$j + 2] eq "O2") {
		printf "%-8s %6d %6d %6d %6d\n", "inactive", $j - 1, $j, $j + 1, $j + 2;
	}
}
