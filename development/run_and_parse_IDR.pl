use warnings;
use strict;

my $hashing_value = 10000;

my $file1 = $ARGV[0];
my $file2 = $ARGV[1];
my $outfi = $ARGV[2];
my $parsed_out = $outfi.".parsed";

my %idr_cutoffs = ("0.001" => "1000", "0.005" => "955", "0.01" => "830", "0.02" => "705", "0.03" => "632", "0.04" => "580", "0.05" => "540", "0.06" => "507", "0.07" => "479", "0.08" => "455", "0.09" => "434", "0.1" => "415", "0.2" => "290", "0.3" => "217", "0.4" => "165", "0.5" => "125", "1" => "0");


my $file1_bed = $file1.".bed";
my $file2_bed = $file2.".bed";
if (-e $file1_bed) {
    print STDERR "$file1_bed exists - skipping fix_file\n";
} else {
    &fix_file($file1);
#    system("perl fix_file.pl $file1");
}

if (-e $file2_bed) {
    print STDERR "$file2_bed exists - skipping fix_file\n";
} else {
    &fix_file($file2);
#    system("perl fix_file.pl $file2");
}


if (-e $outfi) {
} else {
    system("source activate py3 \&\& idr --samples $file1_bed $file2_bed --input-file-type bed --rank 5 --peak-merge-method max --plot -o $outfi");
}
my %idr_output;
&parse_outfi($outfi);

open(PARSEDOUT,">$parsed_out");
my %parsed_output;
&parse_file($file1);
close(PARSEDOUT);


sub fix_file {

    my $fi = shift;

#    print STDERR "running fix_file on $fi\n";
    my $out = $fi.".bed";
    open(OUT,">$out");

    open(F,$fi);
    for my $line (<F>) {
	chomp($line);
	my @tmp = split(/\t/,$line);
	my ($chr2,$pos2,$str,$origpval) = split(/\:/,$tmp[3]);

	next unless ($tmp[11] > 0);
	print OUT "".$tmp[0]."\t".$tmp[1]."\t".$tmp[2]."\t".$tmp[11]."\t".sprintf("%.10f",$tmp[15])."\t".$str."\n";

    }
    close(F);
    close(OUT);
}


sub parse_file {
    my $file = shift;
    open(F,$file);
    for my $line (<F>) {
	chomp($line);

	my @tmp = split(/\t/,$line);
	my $chr = $tmp[0];
	my $start = $tmp[1];
	my $stop = $tmp[2];

	my ($chr2,$pos2,$str,$origpval) = split(/\:/,$tmp[3]);
	my $entropy = $tmp[15];
	my $l2fc = $tmp[11];
	my $l10p = $tmp[10];

	next unless ($l2fc >= 3 && $l10p >= 3);
#	print "chr $chr start $start stop $stop str $str l2 $l2fc l10p $l10p ent $entropy\n";


	my $x = int($start / $hashing_value);
	my $y = int($stop / $hashing_value);

	my %overlapping_idrs;


	for my $i ($x..$y) {
	    for my $idr_peak (@{$idr_output{$chr}{$str}{$i}}) {
		my ($ichr,$ipos,$istr,$iidr) = split(/\:/,$idr_peak);
		my ($istart,$istop) = split(/\-/,$ipos);
		next if ($istart >= $stop);
		next if ($istop <= $start);

		$overlapping_idrs{$idr_peak} = $iidr;
	    }
	}

	$parsed_output{$file}{"all"}{counts}++;
	$parsed_output{$file}{"all"}{entropy}+=$entropy;

	next unless (scalar(keys %overlapping_idrs) > 0);

	my @sorted_idr = sort {$overlapping_idrs{$b} <=> $overlapping_idrs{$a}} keys %overlapping_idrs;
	my $overlapping_idrpeak = $sorted_idr[0];
	my ($ichr,$ipos,$istr,$iidr) = split(/\:/,$overlapping_idrpeak);

#	print "i $iidr\n";

	for my $cutoff (keys %idr_cutoffs) {
	    if ($iidr >= $idr_cutoffs{$cutoff}) {
		$parsed_output{$file}{$cutoff}{counts}++;
		$parsed_output{$file}{$cutoff}{entropy}+=$entropy;
	    }
	}


    }
    close(F);

    for my $cutoff (keys %idr_cutoffs , "all") {
	print PARSEDOUT "$file\t$cutoff\tcounts\t".$parsed_output{$file}{$cutoff}{counts}."\t".sprintf("%.5f",$parsed_output{$file}{$cutoff}{counts}/$parsed_output{$file}{"all"}{counts})."\tentropy\t".$parsed_output{$file}{$cutoff}{entropy}."\t".sprintf("%.5f",$parsed_output{$file}{$cutoff}{entropy}/$parsed_output{$file}{"all"}{entropy})."\n";
    }
}


sub parse_outfi {

    my $idr_file = shift;
    open(ID,$idr_file);
    for my $line (<ID>) {
	chomp($line);
	my @tmp = split(/\t/,$line);

	my $chr = $tmp[0];
	my $start = $tmp[1];
	my $stop = $tmp[2];
	my $str = $tmp[5];

	my $idr_score = $tmp[4];

	my $x = int($start / $hashing_value);
	my $y = int($stop / $hashing_value);
	
	for my $i ($x..$y) {
	    push @{$idr_output{$chr}{$str}{$i}},$chr.":".$start."-".$stop.":".$str.":".$idr_score;
	}
    }
    close(ID);
}
