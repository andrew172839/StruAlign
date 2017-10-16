#!/usr/bin/perl

#check command-like arguments
if (@ARGV != 3) {
	print STDERR "find_neighbor.pl <arg1> <arg2> <arg3>\n";
	print STDERR "<arg1>: target_pdb_file, 3ie5_a.pdb\n";
	print STDERR "<arg2>: pdb_file_dir, e.g. xxx/xxx/cullpdb-2\n";
	print STDERR "<arg3>: search output file\n";
	exit;
}
#get directory
opendir(DIR, $ARGV[1]);
@dirtxt = readdir(DIR);
closedir(DIR);
$dirnum = @dirtxt;
$npdb = 0;
for ($i = 0; $i < $dirnum; $i++) {
	if ($dirtxt[$i] !~ /^\./) {
		$pdblist[$npdb] = $ARGV[1]."/$dirtxt[$i]";
		$pdbname[$npdb] = $dirtxt[$i];
		$npdb++;
	}
}
#write output file
open(LIST, ">$ARGV[2]");
#generate pairwise alignments inside each family
for ($i = 0; $i < $npdb; $i++) {
	system "TMalign $ARGV[0] $pdblist[$i] > test.out";
	#get the specific tm-score
	open(OUT, "test.out");
	@outtxt = <OUT>;
	close(OUT);
	$size1 = substr($outtxt[8], 25, 4);
	$size2 = substr($outtxt[9], 25, 4);
	$nalgn = substr($outtxt[11], 15, 4);
	$score = substr($outtxt[11], 43, 7);
	$size_ave = ($size1 + $size2) / 2.0;
	#call tmalign to align the first to the second with specified normalization length
	system "TMalign $ARGV[0] $pdblist[$i] -L $size_ave > test.out";
	#get the specific tm-score
	open(OUT, "test.out");
	@outtxt = <OUT>;
	close(OUT);
	$score = substr($outtxt[11], 43, 7);
	$rmsd = substr($outtxt[11], 26, 6);
	printf ("%-s %-6d%-6d%-6d%-12.5f%-12.5f\n", $pdbname[$i], $size1, $size2, $nalgn, $score, $rmsd);
	printf LIST ("%-s %-6d%-6d%-6d%-12.5f%-12.5f\n", $pdbname[$i], $size1, $size2, $nalgn, $score, $rmsd);
}
close(LIST);
unlink "test.out";
