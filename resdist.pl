#!/usr/bin/perl

#define the reasonable pdb atom name
%index = ("GLY_N", 1, "GLY_CA", 2, "GLY_C", 3, "GLY_O", 4,
	"ALA_N", 5, "ALA_CA", 6, "ALA_C", 7, "ALA_O", 8, "ALA_CB", 9,
	"VAL_N", 10, "VAL_CA", 11, "VAL_C", 12, "VAL_O", 13, "VAL_CB", 14, "VAL_CG1", 15, "VAL_CG2", 16,
	"LEU_N", 17, "LEU_CA", 18, "LEU_C", 19, "LEU_O", 20, "LEU_CB", 21, "LEU_CG", 22, "LEU_CD1", 23, "LEU_CD2", 24,
	"ILE_N", 25, "ILE_CA", 26, "ILE_C", 27, "ILE_O", 28, "ILE_CB", 29, "ILE_CG1", 30, "ILE_CG2", 31, "ILE_CD1", 32,
	"SER_N", 33, "SER_CA", 34, "SER_C", 35, "SER_O", 36, "SER_CB", 37, "SER_OG", 38,
	"THR_N", 39, "THR_CA", 40, "THR_C", 41, "THR_O", 42, "THR_CB", 43, "THR_OG1", 44, "THR_CG2", 45,
	"CYS_N", 46, "CYS_CA", 47, "CYS_C", 48, "CYS_O", 49, "CYS_CB", 50, "CYS_SG", 51,
	"PRO_N", 52, "PRO_CA", 53, "PRO_C", 54, "PRO_O", 55, "PRO_CB", 56, "PRO_CG", 57, "PRO_CD", 58,
	"PHE_N", 59, "PHE_CA", 60, "PHE_C", 61, "PHE_O", 62, "PHE_CB", 63, "PHE_CG", 64, "PHE_CD1", 65, "PHE_CD2", 66,
	"PHE_CE1", 67, "PHE_CE2", 68, "PHE_CZ", 69,
	"TYR_N", 70, "TYR_CA", 71, "TYR_C", 72, "TYR_O", 73, "TYR_CB", 74, "TYR_CG", 75, "TYR_CD1", 76, "TYR_CD2", 77,
	"TYR_CE1", 78, "TYR_CE2", 79, "TYR_CZ", 80, "TYR_OH", 81,
	"TRP_N", 82, "TRP_CA", 83, "TRP_C", 84, "TRP_O", 85, "TRP_CB", 86, "TRP_CG", 87, "TRP_CD1", 88, "TRP_CD2", 89,
	"TRP_NE1", 90, "TRP_CE2", 91, "TRP_CE3", 92, "TRP_CZ2", 93, "TRP_CZ3", 94, "TRP_CH2", 95,
	"HIS_N", 96, "HIS_CA", 97, "HIS_C", 98, "HIS_O", 99, "HIS_CB", 100, "HIS_CG", 101, "HIS_ND1", 102, "HIS_CD2", 103,
	"HIS_CE1", 104, "HIS_NE2", 105,
	"ASP_N", 106, "ASP_CA", 107, "ASP_C", 108, "ASP_O", 109, "ASP_CB", 110, "ASP_CG", 111, "ASP_OD1", 112, "ASP_OD2", 113,
	"ASN_N", 114, "ASN_CA", 115, "ASN_C", 116, "ASN_O", 117, "ASN_CB", 118, "ASN_CG", 119, "ASN_OD1", 120, "ASN_ND2", 121,
	"GLU_N", 122, "GLU_CA", 123, "GLU_C", 124, "GLU_O", 125, "GLU_CB", 126, "GLU_CG", 127, "GLU_CD", 128, "GLU_OE1", 129,
	"GLU_OE2", 130,
	"GLN_N", 131, "GLN_CA", 132, "GLN_C", 133, "GLN_O", 134, "GLN_CB", 135, "GLN_CG", 136, "GLN_CD", 137, "GLN_OE1", 138,
	"GLN_NE2", 139,
	"MET_N", 140, "MET_CA", 141, "MET_C", 142, "MET_O", 143, "MET_CB", 144, "MET_CG", 145, "MET_SD", 146, "MET_CE", 147,
	"LYS_N", 148, "LYS_CA", 149, "LYS_C", 150, "LYS_O", 151, "LYS_CB", 152, "LYS_CG", 153, "LYS_CD", 154, "LYS_CE", 155,
	"LYS_NZ", 156,
	"ARG_N", 157, "ARG_CA", 158, "ARG_C", 159, "ARG_O", 160, "ARG_CB", 161, "ARG_CG", 162, "ARG_CD", 163, "ARG_NE", 164,
	"ARG_CZ", 165, "ARG_NH1", 166, "ARG_NH2", 167);
@list = keys(%index);
$nindex = @list;
#define the sequence in 3-letter and 1-letter formats
@amino3 = ("GLY", "ALA", "VAL", "LEU", "ILE", "SER", "THR", "CYS", "PRO", "PHE", "TYR", "TRP", "HIS", "ASP", "ASN", "GLU", "GLN", "MET", "LYS", "ARG");
@amino1_upper = ("G", "A", "V", "L", "I", "S", "T", "C", "P", "F", "Y", "W", "H", "D", "N", "E", "Q", "M", "K", "R");
@amino1_lower = ("g", "a", "v", "l", "i", "s", "t", "c", "p", "f", "y", "w", "h", "d", "n", "e", "q", "m", "k", "r");
$namino = @amino3;
#check the commond line
if (@ARGV != 3) {
	printf STDERR "usage: resdist.pl <model_pdb> <res1> <res2>\n";
	exit;
}
$pdbfile = $ARGV[0];
#read in the protein model pdb file
if (-f "$pdbfile") {
	&readpdb("$pdbfile");
	&getseq();
}
else {
	printf "protein pdb file $pdbfile doesn't exist\n";
	exit;
}
#get index of ca of residue 1
for ($i = 0; $i < $natm; $i++) {
	if ($rseq[$i] == $ARGV[1] and $anam[$i] eq "CA") {
		$idx1 = $i;
		last;
	}
}
#get index of ca of residue 2
for ($i = 0; $i < $natm; $i++) {
	if ($rseq[$i] == $ARGV[2] and $anam[$i] eq "CA") {
		$idx2 = $i;
		last;
	}
}
#calculate the distance
$xdif = $xpdb[$idx1] - $xpdb[$idx2];
$ydif = $ypdb[$idx1] - $ypdb[$idx2];
$zdif = $zpdb[$idx1] - $zpdb[$idx2];
$dist = sqrt($xdif * $xdif + $ydif * $ydif + $zdif * $zdif);
printf STDERR "\nca-distance = $dist\n";
#get index of cb of residue 1
for ($i = 0; $i < $natm; $i++) {
	if ($rseq[$i] == $ARGV[1] and $anam[$i] eq "CB") {
		$idx1 = $i;
		last;
	}
}
#get index of cb of residue 2
for ($i = 0; $i < $natm; $i++) {
	if ($rseq[$i] == $ARGV[2] and $anam[$i] eq "CB") {
		$idx2 = $i;
		last;
	}
}
#calculate the distance
$xdif = $xpdb[$idx1] - $xpdb[$idx2];
$ydif = $ypdb[$idx1] - $ypdb[$idx2];
$zdif = $zpdb[$idx1] - $zpdb[$idx2];
$dist = sqrt($xdif * $xdif + $ydif * $ydif + $zdif * $zdif);
printf STDERR "\ncb-distance = $dist\n\n";

#read the pdb file and store the information into global arrays
sub readpdb() {
	my ($i, $j, $pdblen, @pdbtxt);
	my ($strtmp, @dual, $pdbnam, $find);
	open(PROPDB, "$_[0]");
	@pdbtxt = <PROPDB>;
	close (PROPDB);
	$pdblen = @pdbtxt;
	for ($i = 0; $i < $pdblen; $i++) {
		if ($pdbtxt[$i] =~ /^ATOM/) {
			$strtmp = substr($pdbtxt[$i], 11, 10);
			@dual = split(/ +/, $strtmp);
			$pdbnam = $dual[2]."_".$dual[1];
			$find = 0;
			for ($j = 0; $j < $nindex; $j++) {
				if ($pdbnam eq $list[$j]) {
					$find = 1;
					last;
				}
			}
			next if ($find == 0);
			$anam[$natm] = $dual[1];
			$rnam[$natm] = $dual[2];
			$chid[$natm] = " ";
			$rseq[$natm] = substr($pdbtxt[$i], 22, 4);
			$xpdb[$natm] = substr($pdbtxt[$i], 30, 8);
			$ypdb[$natm] = substr($pdbtxt[$i], 38, 8);
			$zpdb[$natm] = substr($pdbtxt[$i], 46, 8);
			$natm++;
		}
	}
}

#generate the sequence from the pdb file
sub getseq() {
	my ($i, $j, $ini, $pdblen, @pdbtxt);
	my ($strtmp, @dual, $pdbnam, $find);
	$nres = 0;
	$pre_res = -1000;
	$pre_cid = "_";
	for ($i = 0; $i < $natm; $i++) {
		if ($rseq[$i] !=  $pre_res or $chid[$i] ne $pre_cid) {
			for ($j = 0; $j < $namino; $j++) {
				if ($rnam[$i] =~ /$amino3[$j]/) {
					$sequen1[$nres] = $amino1_upper[$j];
				}
			}
			$nres++;
		}
		$pre_res = $rseq[$i];
		$pre_cid = $chid[$i];
	}
}
