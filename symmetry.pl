#!/usr/bin/perl

@chid = ("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9");
$radian = 57.29577951308232088;
while (1 > 0) {
	printf ("\nenter unit cell axis lengths [X Y Z]:");
	$line = <STDIN>;
	@arr = split(/ +/, $line);
	$ndim = @arr;
	next if ($ndim != 3 and $ndim != 4);
	if ($ndim == 3) {
		$xcell = $arr[0];
		$ycell = $arr[1];
		$zcell = $arr[2];
	}
	else {
		$xcell = $arr[1];
		$ycell = $arr[2];
		$zcell = $arr[3];
	}
	last if ($xcell != 0.0 and $ycell != 0.0 and $zcell != 0.0);
}
printf ("unit cell axis lengths: %8.3f%8.3f%8.3f\n", $xcell, $ycell, $zcell);
while (1 > 0) {
	printf ("\nenter unit cell axis angles [A B G]:");
	$line = <STDIN>;
	@arr = split(/ +/, $line);
	$ndim = @arr;
	next if ($ndim != 3 and $ndim != 4);
	if ($ndim == 3) {
		$acell = $arr[0];
		$bcell = $arr[1];
		$gcell = $arr[2];
	}
	else {
		$acell = $arr[1];
		$bcell = $arr[2];
		$gcell = $arr[3];
	}
	last if ($acell != 0.0 and $bcell != 0.0 and $gcell != 0.0);
}
printf ("unit cell axis angles: %8.3f%8.3f%8.3f\n", $acell, $bcell, $gcell);
while (1 > 0) {
	printf ("\nenter the symmetry definition file:");
	$symfile = <STDIN>;
	open(SYM, $symfile);
	@txtsym = <SYM>;
	$lensym = @txtsym;
	last if ($lensym > 0);
}
while (1 > 0) {
	printf ("\nenter the protein pdb file:");
	$pdbfile = <STDIN>;
	open(PDB, $pdbfile);
	@txtpdb = <PDB>;
	$lenpdb = @txtpdb;
	last if ($lenpdb > 0);
}
printf ("\nenter the unit cell file name:");
$uclfile = <STDIN>;
open(UCL, ">$uclfile");
printf ("\nenter the lattice file name:");
$latfile = <STDIN> ;
open(LAT, ">$latfile");
while (1 > 0) {
	printf ("\nenter distance cutoff from central unit:");
	$line = <STDIN>;
	@arr = split(/ +/, $line);
	$ndim = @arr;
	next if ($ndim != 1 and $ndim != 2);
	if ($ndim == 1) {
		$rcut = $arr[0];
	}
	else {
		$rcut = $arr[1];
	}
	last if ($rcut > 0.0);
}
printf ("distance cutoff from central unit: %f\n", $rcut);
printf ("\nenter the central units file name:");
$cenfile = <STDIN>;
open(CEN, ">$cenfile");
$nsym = ($lensym - 2) / 4;
if ($nsym * 4 + 2 != $lensym) {
	printf ("check the symmetry definition file\n");
	exit;
}
#read in the symmetry definition file
for ($i = 0; $i < $nsym; $i++) {
	for ($j = 0; $j < 3; $j++) {
		$string = $txtsym[2 + $i * 4 + $j];
		chop($string);
		$rotx[$i * 3 + $j] = substr($string, 0, 10);
		$roty[$i * 3 + $j] = substr($string, 10, 10);
		$rotz[$i * 3 + $j] = substr($string, 20, 10);
	}
	$string = $txtsym[2 + $i * 4 + 3];
	chop($string);
	$trnx[$i] = substr($string, 0, 10);
	$trny[$i] = substr($string, 10, 10);
	$trnz[$i] = substr($string, 20, 10);
}
print "\n";
for ($i = 0; $i < $nsym; $i++) {
	printf ("%10f%10f%10f\n", $rotx[$i * 3], $roty[$i * 3], $rotz[$i * 3]);
	printf ("%10f%10f%10f\n", $rotx[$i * 3 + 1], $roty[$i * 3 + 1], $rotz[$i * 3 + 1]);
	printf ("%10f%10f%10f\n", $rotx[$i * 3 + 2], $roty[$i * 3 + 2], $rotz[$i * 3 + 2]);
	printf ("%10f%10f%10f\n", $trnx[$i], $trny[$i], $trnz[$i]);
	print "\n";
}
#read in the protein pdb file
$natm1 = 0;
for ($i = 0; $i < $lenpdb; $i++) {
	if ($txtpdb[$j] =~ /ATOM/) {
		$aseq[$natm1] = substr($txtpdb[$i], 8, 5);
		$anam[$natm1] = substr($txtpdb[$i], 13, 4);
		$rnam[$natm1] = substr($txtpdb[$i], 17, 3);
		$cid[$natm1] = substr($txtpdb[$i], 21, 1);
		$rseq[$natm1] = substr($txtpdb[$i], 22, 5);
		$xpdb[$natm1] = substr($txtpdb[$i], 30, 8);
		$ypdb[$natm1] = substr($txtpdb[$i], 38, 8);
		$zpdb[$natm1] = substr($txtpdb[$i], 46, 8);
		$natm1++;
	}
}
#calculate the matrix (from the fractional coordinate to cartesian coordinate)
$tmp1 = cos($acell / $radian) * cos($acell / $radian);
$tmp2 = cos($bcell / $radian) * cos($bcell / $radian);
$tmp3 = cos($gcell / $radian) * cos($gcell / $radian);
$tmp4 = 2.0 * cos($acell / $radian) * cos($bcell / $radian) * cos($gcell / $radian);
$v = $xcell * $ycell * $zcell * sqrt(1.0 - $tmp1 - $tmp2 - $tmp3 + $tmp4);
$s[0][0] = $xcell;
$s[0][1] = $ycell * cos($gcell / $radian);
$s[0][2] = $zcell * cos($bcell / $radian);
$s[1][0] = 0.0;
$s[1][1] = $ycell * sin($gcell / $radian);
$s[1][2] = $zcell * (cos($acell / $radian) - cos($bcell / $radian) * cos($gcell / $radian)) / sin($gcell / $radian);
$s[2][0] = 0.0;
$s[2][1] = 0.0;
$s[2][2] = $v / $xcell / $ycell / sin($gcell/$radian);
#calculate the determinant
$det = $s[0][0] * $s[1][1] * $s[2][2] + $s[1][2] * $s[0][1] * $s[2][0] + $s[2][1] * $s[1][0] * $s[0][2];
$det = $det - ($s[2][0] * $s[1][1] * $s[0][2] + $s[1][0] * $s[0][1] * $s[2][2] + $s[2][1] * $s[1][2] * $s[0][0]);
#calculate the matrix (cartesian coordinate to fractional)
$inv_s[0][0] = (1 / $det) * ($s[2][2] * $s[1][1] - $s[1][2] * $s[2][1]);
$inv_s[0][1] = (1 / $det) * ($s[0][2] * $s[2][1] - $s[0][1] * $s[2][2]);
$inv_s[0][2] = (1 / $det) * ($s[0][1] * $s[1][2] - $s[1][1] * $s[0][2]);
$inv_s[1][0] = (1 / $det) * ($s[2][0] * $s[1][2] - $s[2][2] * $s[1][0]);
$inv_s[1][1] = (1 / $det) * ($s[0][0] * $s[2][2] - $s[2][0] * $s[0][2]);
$inv_s[1][2] = (1 / $det) * ($s[1][0] * $s[0][2] - $s[0][0] * $s[1][2]);
$inv_s[2][0] = (1 / $det) * ($s[2][1] * $s[1][0] - $s[2][0] * $s[1][1]);
$inv_s[2][1] = (1 / $det) * ($s[0][0] * $s[2][1] - $s[2][0] * $s[0][1]);
$inv_s[2][2] = (1 / $det) * ($s[0][0] * $s[1][1] - $s[0][1] * $s[1][0]);
#print out the scaling matrix
printf ("scaling matrix [scal1 scal2 scal3]\n");
printf ("%8.6f%8.6f%8.6f\n", $inv_s[0][0], $inv_s[0][1], $inv_s[0][2]);
printf ("%8.6f%8.6f%8.6f\n", $inv_s[1][0], $inv_s[1][1], $inv_s[1][2]);
printf ("%8.6f%8.6f%8.6f\n", $inv_s[2][0], $inv_s[2][1], $inv_s[2][2]);
#convert cartesian to fractional coordinates
for ($i = 0; $i < $natm1; $i++) {
	$xcor[$i] = $inv_s[0][0] * $xpdb[$i] + $inv_s[0][1] * $ypdb[$i] + $inv_s[0][2] * $zpdb[$i];
	$ycor[$i] = $inv_s[1][0] * $xpdb[$i] + $inv_s[1][1] * $ypdb[$i] + $inv_s[1][2] * $zpdb[$i];
	$zcor[$i] = $inv_s[2][0] * $xpdb[$i] + $inv_s[2][1] * $ypdb[$i] + $inv_s[2][2] * $zpdb[$i];
}
#generate unit cell
for ($i = 0; $i < $nsym; $i++) {
	for ($j = 0; $j < $natm1; $j++) {
		$xunit[$i * $natm1 + $j] = $xcor[$j] * $rotx[$i * 3] + $ycor[$j] * $roty[$i * 3] + $zcor[$j] * $rotz[$i * 3] + $trnx[$i];
		$yunit[$i * $natm1 + $j] = $xcor[$j] * $rotx[$i * 3 + 1] + $ycor[$j] * $roty[$i * 3 + 1] + $zcor[$j] * $rotz[$i * 3 + 1] + $trny[$i];
		$zunit[$i * $natm1 + $j] = $xcor[$j] * $rotx[$i * 3 + 2] + $ycor[$j] * $roty[$i * 3 + 2] + $zcor[$j] * $rotz[$i * 3 + 2] + $trnz[$i];
	}
}
$natm2 = $nsym * $natm1;
#convert temporary fractional coordinates to cartesian coordinates
for ($i = 0; $i < $natm2; $i++) {
	$xtmp[$i] = $s[0][0] * $xunit[$i] + $s[0][1] * $yunit[$i] + $s[0][2] * $zunit[$i];
	$ytmp[$i] = $s[1][0] * $xunit[$i] + $s[1][1] * $yunit[$i] + $s[1][2] * $zunit[$i];
	$ztmp[$i] = $s[2][0] * $xunit[$i] + $s[2][1] * $yunit[$i] + $s[2][2] * $zunit[$i];
}
#print out the unit-cell
for ($i = 0; $i < $nsym; $i++) {
	for ($j = 0; $j < $natm1; $j++) {
		printf UCL("atom%7d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f\n", $aseq[$j], $anam[$j], $rnam[$j], $chid[$i], $rseq[$j], $xtmp[$i * $natm1 + $j], $ytmp[$i * $natm1 + $j], $ztmp[$i * $natm1 + $j]);
	}
}
#generate the 27-unit-cell lattice
$ncopy = 0;
for ($i = -1; $i < = 1; $i++) {
	for ($j = -1; $j < = 1; $j++) {
		for ($k = -1; $k < = 1; $k++) {
			for ($l = 0; $l < $natm2; $l++) {
				$xlatt[$ncopy * $natm2 + $l] = $xunit[$l] + $i * 1.0;
				$ylatt[$ncopy * $natm2 + $l] = $yunit[$l] + $j * 1.0;
				$zlatt[$ncopy * $natm2 + $l] = $zunit[$l] + $k * 1.0;
			}
			$ncopy++;
		}
	}
}
$natm3 = $natm2 * $ncopy;
#convert fractional to cartesian coordinates
for ($i = 0; $i < $natm3; $i++) {
	$xfin[$i] = $s[0][0] * $xlatt[$i] + $s[0][1] * $ylatt[$i] + $s[0][2] * $zlatt[$i];
	$yfin[$i] = $s[1][0] * $xlatt[$i] + $s[1][1] * $ylatt[$i] + $s[1][2] * $zlatt[$i];
	$zfin[$i] = $s[2][0] * $xlatt[$i] + $s[2][1] * $ylatt[$i] + $s[2][2] * $zlatt[$i];
}
#print out the 27-unit-cell lattice
for ($k = 0; $k < $ncopy; $k++) {
	for ($i = 0; $i < $nsym; $i++) {
		for ($j = 0; $j < $natm1; $j++) {
			printf LAT("atom%7d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f\n", $aseq[$j], $anam[$j], $rnam[$j], $chid[$i], $rseq[$j], $xfin[$k * $natm2 + $i * $natm1 + $j], $yfin[$k * $natm2 + $i * $natm1 + $j], $zfin[$k * $natm2 + $i * $natm1 + $j]);
		}
	}
}
#calculate the geometric center of each protein in the 27-unit-cell lattice
for ($k = 0; $k < $ncopy; $k++) {
	for ($i = 0; $i < $nsym; $i++) {
		$xcent[$k * $nsym + $i] = 0.0;
		$ycent[$k * $nsym + $i] = 0.0;
		$zcent[$k * $nsym + $i] = 0.0;
		for ($j = 0; $j < $natm1; $j++) {
			$xcent[$k * $nsym + $i] = $xcent[$k * $nsym + $i] + $xfin[$k * $natm2 + $i * $natm1 + $j];
			$ycent[$k * $nsym + $i] = $ycent[$k * $nsym + $i] + $yfin[$k * $natm2 + $i * $natm1 + $j];
			$zcent[$k * $nsym + $i] = $zcent[$k * $nsym + $i] + $zfin[$k * $natm2 + $i * $natm1 + $j];
		}
		$xcent[$k * $nsym + $i] = $xcent[$k * $nsym + $i] / $natm1;
		$ycent[$k * $nsym + $i] = $ycent[$k * $nsym + $i] / $natm1;
		$zcent[$k * $nsym + $i] = $zcent[$k * $nsym + $i] / $natm1;
		printf ("center of the protein %d: %12.3f%12.3f%12.3f\n", $k * $nsym + $i, $xcent[$k * $nsym + $i], $ycent[$k * $nsym + $i], $zcent[$k * $nsym + $i]);
	}
}
#calculate the center of the original pdb structure
$xcore = 0.0;
$ycore = 0.0;
$zcore = 0.0;
for ($k = 0; $k < $natm1; $k++) {
	$xcore = $xcore + $xpdb[$k];
	$ycore = $ycore + $ypdb[$k];
	$zcore = $zcore + $zpdb[$k];
}
$xcore = $xcore / $natm1;
$ycore = $ycore / $natm1;
$zcore = $zcore / $natm1;
printf ("center of the pdb structure: %12.3f%12.3f%12.3f\n", $xcore, $ycore, $zcore);
#print out the symmetry-mates around pdb structure
$ind = 0;
for ($k = 0; $k < $ncopy; $k++) {
	for ($i = 0; $i < $nsym; $i++) {
		$distx = $xcent[$k * $nsym + $i]-$xcore;
		$disty = $ycent[$k * $nsym + $i]-$ycore;
		$distz = $zcent[$k * $nsym + $i]-$zcore;
		$dist = sqrt($distx * $distx + $disty * $disty + $distz * $distz);
		next if ($dist > $rcut);
		print ". ";
		for ($j = 0; $j < $natm1; $j++) {
			printf CEN("atom%7d  %-4s%-4s%1s%4d    %8.3f%8.3f%8.3f\n", $aseq[$j], $anam[$j], $rnam[$j], $chid[$ind], $rseq[$j], $xfin[$k * $natm2 + $i * $natm1 + $j], $yfin[$k * $natm2 + $i * $natm1 + $j], $zfin[$k * $natm2 + $i * $natm1 + $j]);
		}
		$ind++;
	}
}
print "\n";
