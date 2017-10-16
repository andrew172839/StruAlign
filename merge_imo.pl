#!/usr/bin/perl

#define the 167 pdb atom names
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
#define the imo keywords
@kwords = ("IMOTYPE", "PROPDB", "STEM1", "STEM2", "NINI", "NSEED", "RANDOM", "NSTEPS", "STEPSIZE", "STEPBASE", "NSECTEM", "SECTEM1", "SECTEM2", "NSILENT", "SLTTEM1", "SLTTEM2", "INIBONE", "DISTRES", "POSTRES", "NRESCYC", "LEVEL", "NSITE", "NCONV", "CUTOFF", "OUTPUT", "VERBOSE");
$nkwords = @kwords;
#check the environmental variables
$imo_dir = $ENV{IMO_DIR};
if (not -d "$imo_dir") {
	printf "environmental variable - IMO_DIR not set\n";
	exit;
}
$dfire_bin = "$imo_dir/bin/know";
$dfire_lib = "$imo_dir/lib/pmf1_dfire151_bin.dat";
#check the command line
if (@ARGV == 0) {
	printf STDERR "merge_imo.pl usuage: merge_imo.pl <imo_refine_dir1> <dir2> ...\n";
	printf STDERR "for example: res_16-22 res_44-79_d1e0ca1 ...\n";
	exit;
}
$ndir = @ARGV;
#check if "results" dir exist
if (not -d "results") {
	mkdir "results";
}
#enter results dir
chdir "results";
#merge all refined regions into one structure
for ($ncount = 0, $j = 0; $j < $ndir; $j++) {
	if (substr($ARGV[$j], 0, 4) eq "res_" and -d "../$ARGV[$j]") {
		#read in the input file
		&readparm("../$ARGV[$j]/input.prm");
		#merge one region into the current model
		$sample_idx = $nsteps - 1;
		if ($ncount == 0) {
			system "~/IMO/imo-2.5 + /bin/seg2pro.pl ../$ARGV[$j]/$pdbfile ../$ARGV[$j]/sample$sample_idx.pdb 0 $stem1 $stem2 > model.pdb_imo";
		}
		else {
			system "~/IMO/imo-2.5 + /bin/seg2pro.pl model.pdb_imo ../$ARGV[$j]/sample$sample_idx.pdb 0 $stem1 $stem2 > _tmp_.pdb";
			system "mv _tmp_.pdb model.pdb_imo";
		}
		$ncount++;
		printf ("%d ", $ncount);
	}
}
printf "\n";
#clean up the refined pdb file
system "shiftseq.pl model.pdb_imo 0 _tmp_.pdb";
system "mv _tmp_.pdb model.pdb_imo";

#read in the parameter file
sub readparm() {
	my ($i, $j);
	my (@partxt, $parlen, @findparm, @arr, $narr);
	#initialization
	for ($i = 0; $i < $nkwords; $i++) {
		$findparm[$i] = 0;
	}
	#read the parameter file
	open(TMP, "$_[0]");
	@partxt = <TMP>;
	close(TMP);
	$parlen = @partxt;
	for ($i = 0; $i < $parlen; $i++) {
		chomp $partxt[$i];
		for ($j = 0; $j < $nkwords; $j++) {
			if ($partxt[$i] =~ /^$kwords[$j] /) {
				$findparm[$j] = 1;
				@arr = split / +/, $partxt[$i];
				$narr = @arr;
				if ($narr < 2) {
					printf STDERR "parameter for keyword $kwords[$j] is missing!\n";
					exit;
				}
				if ($kwords[$j] eq "IMOTYPE") {
					if ($arr[1] == 1) {
						$imotype = "F";
					}
					elsif ($arr[1] == 2) {
						$imotype = "S";
					}
					elsif ($arr[1] == 3) {
						$imotype = "K";
					}
					elsif ($arr[1] == 4) {
						$imotype = "Z";
					}
					else {
						printf STDERR "IMOTYPE is wrong\n";
						exit;
					}
				}
				elsif ($kwords[$j] eq "PROPDB") {
					$pdbfile = $arr[1];
				}
				elsif ($kwords[$j] eq "EMMAP") {
					$mapfile = $arr[1];
				}
				elsif ($kwords[$j] eq "RESOL") {
					$resolution = $arr[1];
				}
				elsif ($kwords[$j] eq "APIX") {
					$apix = $arr[1];
				}
				elsif ($kwords[$j] eq "BOX") {
					$box = $arr[1];
				}
				elsif ($kwords[$j] eq "WEIGHT") {
					$wfac = $arr[1];
				}
				elsif ($kwords[$j] eq "STEM1") {
					$stem1 = $arr[1];
				}
				elsif ($kwords[$j] eq "STEM2") {
					$stem2 = $arr[1];
				}
				elsif ($kwords[$j] eq "NINI") {
					$nini = $arr[1];
				}
				elsif ($kwords[$j] eq "NSEED") {
					$nseed = $arr[1];
				}
				elsif ($kwords[$j] eq "RANDOM") {
					$random = $arr[1];
				}
				elsif ($kwords[$j] eq "NSTEPS") {
					$nsteps = $arr[1];
				}
				elsif ($kwords[$j] eq "STEPBASE") {
					$stepbase = $arr[1];
				}
				elsif ($kwords[$j] eq "NSECTEM") {
					$nsectem = $arr[1];
				}
				elsif ($kwords[$j] eq "NSILENT") {
					$nsilent = $arr[1];
				}
				elsif ($kwords[$j] eq "INIBONE") {
					$inibone = $arr[1];
				}
				elsif ($kwords[$j] eq "DISTRES") {
					$distres = $arr[1];
				}
				elsif ($kwords[$j] eq "POSTRES") {
					$postres = $arr[1];
				}
				elsif ($kwords[$j] eq "NRESCYC") {
					$nrescyc = $arr[1];
				}
				elsif ($kwords[$j] eq "LEVEL") {
					$level = int($arr[1]);
					if ($level < 0 || $level > 10) {
						printf STDERR "check segsam optimization level\n";
						exit;
					}
				}
				elsif ($kwords[$j] eq "NSITE") {
					$nsite = $arr[1];
				}
				elsif ($kwords[$j] eq "NCONV") {
					$nconv = $arr[1];
				}
				elsif ($kwords[$j] eq "CUTOFF") {
					$rcutoff = $arr[1];
				}
				elsif ($kwords[$j] eq "OUTPUT") {
					$outfile = $arr[1];
				}
				elsif ($kwords[$j] eq "VERBOSE") {
					$verbose = $arr[1];
				}
				if ($nsectem > 0) {
					if ($kwords[$j] eq "SECTEM1") {
						if ($nsectem > $narr - 1) {
							printf STDERR "check number of SSEs\n";
							exit;
						}
						for ($k = 0; $k < $nsectem; $k++) {
							$sectem1[$k] = $arr[$k + 1];
						}
					}
					if ($kwords[$j] eq "SECTEM2") {
						if ($nsectem > $narr - 1) {
							printf STDERR "check number of SSEs\n";
							exit;
						}
						for ($k = 0; $k < $nsectem; $k++) {
							$sectem2[$k] = $arr[$k + 1];
						}
					}
				}
				if ($nsilent > 0) {
					if ($kwords[$j] eq "SLTTEM1") {
						if ($nsilent > $narr - 1) {
							printf STDERR "check number of silent regions\n";
							exit;
						}
						for ($k = 0; $k < $nsilent; $k++) {
							$slttem1[$k] = $arr[$k + 1];
						}
					}
					if ($kwords[$j] eq "SLTTEM2") {
						if ($nsilent > $narr - 1) {
							printf STDERR "check number of silent regions\n";
							exit;
						}
						for ($k = 0; $k < $nsilent; $k++) {
							$slttem2[$k] = $arr[$k + 1];
						}
					}
				}
				if ($nsteps > 0) {
					if ($kwords[$j] eq "STEPSIZE") {
						if ($nsteps > $narr - 1) {
							printf STDERR "check number of stepsizes (angles)\n";
							exit;
						}
						for ($k = 0; $k < $nsteps; $k++) {
							$stepsize[$k] = $arr[$k + 1];
						}
					}
				}
			}
		}
	}
	#check if any parameters missing
	for ($i = 0; $i < $nkwords; $i++) {
		if ($findparm[$i] == 0) {
			printf "parameter for $kwords[$i] is missing\n";
		}
	}
}

#read in the pdb file
sub readpdb() {
	my ($i, $j, $pdblen, @pdbtxt);
	my ($strtmp, @dual, $pdbnam, $find);
	open(PROPDB, "$_[0]");
	@pdbtxt = <PROPDB> ;
	close(PROPDB);
	$pdblen = @pdbtxt;
	for ($natm = 0, $i = 0; $i < $pdblen; $i++) {
		if ($pdbtxt[$i] =~ /^ATOM/) {
			chomp $pdbtxt[$i];
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
