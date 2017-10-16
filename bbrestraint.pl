#!/usr/bin/perl

#check command line
if (@ARGV != 1) {
	print STDERR "get_backbone.pl usuage: get_backbone.pl <tinker_xyz_file>\n";
	exit;
}
open (PROXYZ, $ARGV[0]);
@xyztxt = <PROXYZ>;
close (PROXYZ);
my $xyzlen = @xyztxt;
for ($i = 1; $i < $xyzlen; $i++) {
	$atomnumb[$i] = substr($xyztxt[$i], 0, 6);
	$atonname[$i] = substr($xyztxt[$i], 7, 3);
	$atomxcor[$i] = substr($xyztxt[$i], 11, 12);
	$atomycor[$i] = substr($xyztxt[$i], 23, 12);
	$atomzcor[$i] = substr($xyztxt[$i], 35, 12);
}
for ($i = 2; $i < $xyzlen; $i++) {
	$flag = 0;
	if ($atonname[$i - 1] eq "N" && $atonname[$i] eq "CT" && $atonname[$i + 1] eq "C" && $atonname[$i + 2] eq "O") {
		$flag = 1;
	}
	if ($atonname[$i - 1] eq "N3" && $atonname[$i] eq "CT" && $atonname[$i + 1] eq "C" && $atonname[$i + 2] eq "O") {
		$flag = 1;
	}
	if ($atonname[$i - 1] eq "N" && $atonname[$i] eq "CT" && $atonname[$i + 1] eq "C" && $atonname[$i + 2] eq "O2") {
		$flag = 1;
	}
	next if ($flag == 0);
	printf ("restrain-position %6d %8.3f %8.3f %8.3f 100.000 0.000\n", $atomnumb[$i - 1], $atomxcor[$i - 1], $atomycor[$i - 1], $atomzcor[$i - 1]);
	printf ("restrain-position %6d %8.3f %8.3f %8.3f 100.000 0.000\n", $atomnumb[$i], $atomxcor[$i], $atomycor[$i], $atomzcor[$i]);
	printf ("restrain-position %6d %8.3f %8.3f %8.3f 100.000 0.000\n", $atomnumb[$i + 1], $atomxcor[$i + 1], $atomycor[$i + 1], $atomzcor[$i + 1]);
	printf ("restrain-position %6d %8.3f %8.3f %8.3f 100.000 0.000\n", $atomnumb[$i + 2], $atomxcor[$i + 2], $atomycor[$i + 2], $atomzcor[$i + 2]);
}
