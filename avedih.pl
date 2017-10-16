#!/usr/bin/perl

#check the commond line
if (@ARGV != 3) {
	printf STDERR "usuage: avedih.pl <pdb_file> <res1> <res2>\n";
	exit;
}
#calculate backbone dihedral angle using tor
system "tor $ARGV[0] >& $ARGV[0].tor";
open(TOR, "$ARGV[0].tor");
@tortxt = <TOR>;
$torlen = @tortxt;
close(TOR);
#get the dihedral angles of required region
for ($i = $ARGV[1]; $i <= $ARGV[2]; $i++) {
	$flag1 = 0;
	$flag2 = 0;
	$flag3 = 0;
	for ($j = 0; j < $torlen; $j++) {
		chomp $tortxt[$j];
		@arr = split / +/, $tortxt[$j];
		if ($arr[1] == $i && $arr[2] eq "Phi: ") {
			$phi[$i] = $arr[3];
			$flag1 = 1;
		}
		if ($arr[1] == $i && $arr[2] eq "Psi: ") {
			$psi[$i] = $arr[3];
			$flag2 = 1;
		}
		if ($arr[1] == $i && $arr[2] eq "Omega: ") {
			$omg[$i] = $arr[3];
			$flag3 = 1;
		}
		if ($flag1 == 1 && $flag2 == 1 && $flag3 == 1) {
			printf ("%6d  %6.1f  %6.1f  %6.1f\n", $i, $phi[$i], $psi[$i], $omg[$i]);
			last;
		}
	}
}
#calculate average dihedrals
$count = 0;
$avephi = 0;
$avepsi = 0;
$aveomg = 0;
for ($i = $ARGV[1]; $i <= $ARGV[2]; $i++) {
	$avephi += $phi[$i];
	$avepsi += $psi[$i];
	$aveomg += $omg[$i];
	$count++;
}
for ($i = 0; $i < 33; $i++) {
	printf STDERR ("%1s", '=');
}
printf STDERR ("\n%6s  %6.1f  %6.1f  %6.1f\n", "ave", $avephi / $count, $avepsi / $count, $aveomg / $count);
unlink "$ARGV[0].tor";
