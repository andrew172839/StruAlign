#!/usr/bin/perl

#define the reasonable pdb atom name
%index = (
	"GLY_N", 1, "GLY_CA", 2, "GLY_C", 3, "GLY_O", 4,
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
@amino3 = ("GLY", "ALA", "VAL", "LEU", "ILE", "SER", "THR", "CYS", "PRO", "PHE",
	"TYR", "TRP", "HIS", "ASP", "ASN", "GLU", "GLN", "MET", "LYS", "ARG");
@amino1_upper = ("G", "A", "V", "L", "I", "S", "T", "C", "P", "F", "Y", "W", "H", "D", "N", "E", "Q", "M", "K", "R");
@amino1_lower = ("g", "a", "v", "l", "i", "s", "t", "c", "p", "f", "y", "w", "h", "d", "n", "e", "q", "m", "k", "r");
$namino = @amino3;
#check the command-line arguments
if (@ARGV ne 4) {
	printf STDERR "shiftseq_dir.pl <arg1> <arg2> <arg3> <arg4>\n";
	printf STDERR "<arg1>: input protein pdb dir\n";
	printf STDERR "<arg2>: residue number shif t\n";
	printf STDERR "<arg3>: desired chain ID\n";
	printf STDERR "<arg4>: output protein pdb dir\n";
	exit;
}
#check if the pdb dir exists
if (not -d $ARGV[0]) {
	printf STDERR "error: pdb dir - $ARGV[0] doesn't exist\n";
	exit;
}
#read in file names in the pdb dir
opendir(DIR, $ARGV[0]);
@pdbdir = readdir(DIR);
$npdbdir = @pdbdir;
closedir(DIR);
#go through each pdb file and analyze contacts
for ($npdb = 0, $i = 0; $i < $npdbdir; $i++) {
	#skip current and parent dirs
	$len = length($pdbdir[$i]);
	next if ($len < = 4);
	#skip non-pdb format files
	$postfix = substr($pdbdir[$i], $len - 4, 4);
	next if ($postfix ne ".pdb");
	#read pdb file
	&readpdb("$ARGV[0]/$pdbdir[$i]");
	#change residue number
	for ($j = 0; $j < $natm; $j++) {
		$rseq[$j] = $rseq[$j] + $ARGV[1];
		if (substr($ARGV[2], 0, 1) eq '_') {
			$chid[$j] = ' ';
		}
		elsif (substr($ARGV[2], 0, 1) ne 'X') {
			$chid[$j] = substr($ARGV[2], 0, 1);
		}
	}
	#output modified pdb file
	&writepdb("$ARGV[3]/$pdbdir[$i]");
}

#read in protein pdb file and store information in global arrays
sub readpdb() {
	my $ipdb, $jpdb, $pdblen, @pdbtxt;
	my $strtmp, @dual, $pdbnam, $find;
	open(PROPDB, "$_[0]");
	@pdbtxt = <PROPDB>;
	$pdblen = @pdbtxt;
	close(PROPDB);
	for ($natm = 0, $ipdb = 0; $ipdb < $pdblen; $ipdb++) {
		if ($pdbtxt[$ipdb] =~ /^ATOM/) {
			chomp $pdbtxt[$ipdb];
			$strtmp = substr($pdbtxt[$ipdb], 11, 10);
			@dual = split(/ +/, $strtmp);
			#correct ile_cd in gromacs-generated pdbs
			if ($dual[2] eq "ILE" and $dual[1] eq "CD") {
				$dual[1] = "CD1";
			}
			#correct c-terminal oxygen in gromacs pdbs
			if ($dual[1] eq "O1") {
				$dual[1] = "O";
			}
			#create a unique pdb name for protein atom
			$pdbnam = $dual[2]."_".$dual[1];
			$find = 0;
			for ($jpdb = 0; $jpdb < $nindex; $jpdb++) {
				if ($pdbnam eq $list[$jpdb]) {
					$find = 1;
					last;
				}
			}
			next if ($find == 0);
			$anam[$natm] = $dual[1];
			$rnam[$natm] = $dual[2];
			$chid[$natm] = substr($pdbtxt[$ipdb], 21, 1);
			$rseq[$natm] = substr($pdbtxt[$ipdb], 22, 4);
			$xpdb[$natm] = substr($pdbtxt[$ipdb], 30, 8);
			$ypdb[$natm] = substr($pdbtxt[$ipdb], 38, 8);
			$zpdb[$natm] = substr($pdbtxt[$ipdb], 46, 8);
			$natm++;
		}
	}
	#number of residues
	$nres = 0;
	$rseq_prev = -1000;
	for ($ipdb = 0; $ipdb < $natm; $ipdb++) {
		if ($rseq[$ipdb] != $rseq_prev) {
			$rseq_prev = $rseq[$ipdb];
			$ratm_star[$nres] = $ipdb;
			$nres++;
		}
	}
	$ratm_star[$nres] = $natm;
	#calculate c-alpha trace
	for ($ipdb = 0; $ipdb < $nres; $ipdb++) {
		$idx_str = $ratm_star[$ipdb];
		$idx_end = $ratm_star[$ipdb + 1];
		for ($jpdb = $idx_str; $jpdb < $idx_end; $jpdb++) {
			if ($anam[$jpdb] eq 'CA') {
				$xca[$ipdb] = $xpdb[$jpdb];
				$yca[$ipdb] = $ypdb[$jpdb];
				$zca[$ipdb] = $zpdb[$jpdb];
			}
		}
	}
	#calculate c-beta trace
	for ($ipdb = 0; $ipdb < $nres; $ipdb++) {
		$idx_str = $ratm_star[$ipdb];
		$idx_end = $ratm_star[$ipdb + 1];
		for ($jpdb = $idx_str; $jpdb < $idx_end; $jpdb++) {
			if ($anam[$jpdb] eq 'CB') {
				$xcb[$ipdb] = $xpdb[$jpdb];
				$ycb[$ipdb] = $ypdb[$jpdb];
				$zcb[$ipdb] = $zpdb[$jpdb];
			}
			#use ca coordinates for glycan
			if ($anam[$jpdb] eq 'CA' and $rnam[$jpdb] eq 'GLY') {
				$xcb[$ipdb] = $xpdb[$jpdb];
				$ycb[$ipdb] = $ypdb[$jpdb];
				$zcb[$ipdb] = $zpdb[$jpdb];
			}
		}
	}
	#calculate side chain geometry center
	for ($ipdb = 0; $ipdb < $nres; $ipdb++) {
		$idx_str = $ratm_star[$ipdb];
		$idx_end = $ratm_star[$ipdb + 1];
		$ntmp = 0;
		$xtmp = $ytmp = $ztmp = 0.0;
		for ($jpdb = $idx_str; $jpdb < $idx_end; $jpdb++) {
			next if ($anam[$jpdb] eq 'N' or $anam[$jpdb] eq 'CA' or $anam[$jpdb] eq 'C' or $anam[$jpdb] eq 'O');
			$xtmp += $xpdb[$jpdb];
			$ytmp += $ypdb[$jpdb];
			$ztmp += $zpdb[$jpdb];
			$ntmp++;
		}
		#use ca coordinates for glycine
		if ($ntmp == 0) {
			for ($jpdb = $idx_str; $jpdb < $idx_end; $jpdb++) {
				if ($anam[$jpdb] eq 'CA') {
					$xscc[$ipdb] = $xpdb[$jpdb];
					$yscc[$ipdb] = $ypdb[$jpdb];
					$zscc[$ipdb] = $zpdb[$jpdb];
				}
			}
		}
		else {
			$xscc[$ipdb] = $xtmp / $ntmp;
			$yscc[$ipdb] = $ytmp / $ntmp;
			$zscc[$ipdb] = $ztmp / $ntmp;
		}
	}
}

#write a protein pdb file in standard format
sub writepdb() {
	my $ipdb;
	open(PROPDB, ">$_[0]");
	for ($ipdb = 0; $ipdb < $natm; $ipdb++) {
		printf PROPDB ("ATOM%7d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f%6.2f%6.2f\n", $ipdb + 1, $anam[$ipdb], $rnam[$ipdb], $chid[$ipdb], $rseq[$ipdb], $xpdb[$ipdb], $ypdb[$ipdb], $zpdb[$ipdb], 1.00, 0.00);
	}
	close(PROPDB);
}
