#!/usr/bin/env perl

use warnings;
use strict;

my $hashing_value = 10000;
my $l2fc_cutoff = 3;
my $l10p_cutoff = 3;
#my $idr_file = "204.01v02.IDR.out";
my $idr_file = $ARGV[0];
#my $file1 = "204_01.basedon_204_01.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy";
my $file1 = $ARGV[1];
#my $file2 = "204_02.basedon_204_02.peaks.l2inputnormnew.bed.full.compressed2.bed.full.annotated_proxdist.entropy";
my $file2 = $ARGV[2];

# my $bamfi_rep1 = $ARGV[3];
# my $bamfi_rep2 = $ARGV[4];
# my $bamfi_input1 = $ARGV[5];
# my $bamfi_input2 = $ARGV[6];

# my $mapped_readnum_fi = $ARGV[7];

# my $output_prefix = $ARGV[8];
# my $custombed_output = $output_prefix.".custombed";
my $custombed_output = $ARGV[3];
# my $bed_output = $output_prefix.".bed";
my $bed_output = $ARGV[4];

open(BEDOUT,">$bed_output");
open(CUSTOMOUT,">$custombed_output");

# my $rep1_fullout = $output_prefix.".01.full";
my $rep1_fullout = $ARGV[5];
# my $rep2_fullout = $output_prefix.".02.full";
my $rep2_fullout = $ARGV[6];
open(REP1FULL,">$rep1_fullout");
open(REP2FULL,">$rep2_fullout");

my $idr_cutoff = 0.01;
my %idr_cutoffs = ("0.001" => "1000", "0.005" => "955", "0.01" => "830", "0.02" => "705", "0.03" => "632", "0.04" => "580", "0.05" => "540", "0.06" => "507", "0.07" => "479", "0.08" => "455", "0.09" => "434", "0.1" => "415", "0.2" => "290", "0.3" => "217", "0.4" => "165", "0.5" => "125", "1" => "0");

my %idr_output;
&parse_idr_file($idr_file);

my %idrregion2peaks;


&parse_file($file1);
&parse_file($file2);

#my $output_fi1 = "testoutput_region2peaks";
#open(OUTA,">$output_fi1");
#my $output_bed = "testoutput.bed";
my $output_bed = $idr_file.".bed";
open(OUTBED,">$output_bed");

for my $idr_region (keys %idrregion2peaks) {
    for my $peak (keys %{$idrregion2peaks{$idr_region}}) {
#	print OUTA "".$idr_region."\t".$peak."\n";
	my ($chr,$pos,$str) = split(/\:/,$peak);
	my ($start,$stop) = split(/\-/,$pos);
	print OUTBED "$chr\t$start\t$stop\t.\t.\t$str\n";
    }
}
#close(OUTA);
close(OUTBED);

#my $idr_list_fi = "testoutput_region2peaks";
#open(IDR,$idr_list_fi);
#for my $line (<IDR>) {
#    chomp($line);
#    my ($idrregion,$peak) = split(/\t/,$line);
#    $idrregion2peaks{$idrregion}{$peak} = 1;
#}
#close(IDR);

# my $rep1_inputnorm_output = $idr_file.".IDRpeaks_inputnorm.01.bed";
# my $rep2_inputnorm_output = $idr_file.".IDRpeaks_inputnorm.02.bed";
# my $command1 = "perl /home/elvannostrand/data/clip/CLIPseq_analysis/scripts/PIPELINE_EricVersion/overlap_peakfi_with_bam_PE.pl $bamfi_rep1 $bamfi_input1 $output_bed $mapped_readnum_fi $rep1_inputnorm_output";
# print STDERR "command1 $command1\n";
# system("perl /home/elvannostrand/data/clip/CLIPseq_analysis/scripts/PIPELINE_EricVersion/overlap_peakfi_with_bam_PE.pl $bamfi_rep1 $bamfi_input1 $output_bed $mapped_readnum_fi $rep1_inputnorm_output") unless (-e $rep1_inputnorm_output);
# my $command2 = "perl /home/elvannostrand/data/clip/CLIPseq_analysis/scripts/PIPELINE_EricVersion/overlap_peakfi_with_bam_PE.pl $bamfi_rep2 $bamfi_input2 $output_bed $mapped_readnum_fi $rep2_inputnorm_output";
# print STDERR "command2 $command2\n";
# system("perl /home/elvannostrand/data/clip/CLIPseq_analysis/scripts/PIPELINE_EricVersion/overlap_peakfi_with_bam_PE.pl $bamfi_rep2 $bamfi_input2 $output_bed $mapped_readnum_fi $rep2_inputnorm_output") unless (-e $rep2_inputnorm_output);



#my $bamfile1 = "testoutput.bed.204_01bam";
#my $bamfile2 = "testoutput.bed.204_02bam";
my %peak_info;
# my $rep1_inputnorm_output_full = $idr_file.".IDRpeaks_inputnorm.01.bed.full";
# my $rep2_inputnorm_output_full = $idr_file.".IDRpeaks_inputnorm.02.bed.full";

my $rep1_inputnorm_output_full = $ARGV[7];
my $rep2_inputnorm_output_full = $ARGV[8];

#&parse_bam_file($rep1_inputnorm_output_full);
#&parse_bam_file($rep2_inputnorm_output_full);
&parse_inputnorm_fullfile($rep1_inputnorm_output_full);
&parse_inputnorm_fullfile($rep2_inputnorm_output_full);


my $count_signif=0;
for my $idrregion (keys %idrregion2peaks) {
#    print "idr $idrregion\n";
    my %peak_geommean;
    for my $peak (keys %{$idrregion2peaks{$idrregion}}) {
        my $geometric_mean = log(sqrt( (2 ** $peak_info{$peak}{$rep1_inputnorm_output_full}{l2fc}) * (2 ** $peak_info{$peak}{$rep2_inputnorm_output_full}{l2fc}) ))/log(2);
        $peak_geommean{$peak} = $geometric_mean;
    }

    my @peaks_sorted = sort {$peak_geommean{$b} <=> $peak_geommean{$a}} keys %peak_geommean;

    my %already_used_peaks;
    for my $peak (@peaks_sorted) {
        #first check if overlaps existing 

        my ($chr,$pos,$str) = split(/\:/,$peak);
        my ($start,$stop) = split(/\-/,$pos);

        my $flag = 0;
        for my $peak2 (keys %already_used_peaks) {
            my ($chr2,$pos2,$str2) = split(/\:/,$peak2);
            my ($start2,$stop2) = split(/\-/,$pos2);

            next if ($start2 >= $stop);
            next if ($start >= $stop2);
            $flag = 1;
        }
        next if ($flag == 1);

        # ok doesn't overlap existing
        #first time through - only check significant peaks

        next unless ($peak_info{$peak}{$rep1_inputnorm_output_full}{l10p} >= 3 && $peak_info{$peak}{$rep2_inputnorm_output_full}{l10p} >= 3);

        $already_used_peaks{$peak} = 1;

        print CUSTOMOUT "".$idrregion."\t".$peak."\t".$peak_geommean{$peak}."\t".$peak_info{$peak}{$rep1_inputnorm_output_full}{l2fc}."\t".$peak_info{$peak}{$rep2_inputnorm_output_full}{l2fc}."\t".$peak_info{$peak}{$rep1_inputnorm_output_full}{l10p}."\t".$peak_info{$peak}{$rep2_inputnorm_output_full}{l10p}."\n";

	if ($peak_geommean{$peak} >= $l2fc_cutoff && $peak_info{$peak}{$rep1_inputnorm_output_full}{l10p} >= $l10p_cutoff && $peak_info{$peak}{$rep2_inputnorm_output_full}{l10p} >= $l10p_cutoff) {
	    print BEDOUT "".$chr."\t".$start."\t".$stop."\t".&min($peak_info{$peak}{$rep1_inputnorm_output_full}{l10p},$peak_info{$peak}{$rep2_inputnorm_output_full}{l10p})."\t".$peak_geommean{$peak}."\t".$str."\n";
	}

	my @rep1_full = split(/\t/,$peak_info{$peak}{$rep1_inputnorm_output_full}{full});
	$rep1_full[3] .= ":".$peak_geommean{$peak};
	my $rep1_full_join = join("\t",@rep1_full);
        print REP1FULL "".$rep1_full_join."\n";

	my @rep2_full = split(/\t/,$peak_info{$peak}{$rep2_inputnorm_output_full}{full});
	$rep2_full[3] .= ":".$peak_geommean{$peak};
	my $rep2_full_join = join("\t",@rep2_full);
        print REP2FULL "".$rep2_full_join."\n";

        $count_signif++ if ($peak_geommean{$peak} >= 3);
    }
    for my $peak (@peaks_sorted) {
        #first check if overlaps existing
        my ($chr,$pos,$str) = split(/\:/,$peak);
        my ($start,$stop) = split(/\-/,$pos);

        my $flag = 0;
        next if (exists $already_used_peaks{$peak});

        for my $peak2 (keys %already_used_peaks) {
            my ($chr2,$pos2,$str2) = split(/\:/,$peak2);
            my ($start2,$stop2) = split(/\-/,$pos2);

            next if ($start2 >=$stop);
            next if ($start >= $stop2);
            $flag = 1;
        }
        next if ($flag == 1);

        # ok doesn't overlap existing

        #second time through - check all genes
        $already_used_peaks{$peak} = 1;

        print CUSTOMOUT "".$idrregion."\t".$peak."\t".$peak_geommean{$peak}."\t".$peak_info{$peak}{$rep1_inputnorm_output_full}{l2fc}."\t".$peak_info{$peak}{$rep2_inputnorm_output_full}{l2fc}."\t".$peak_info{$peak}{$rep1_inputnorm_output_full}{l10p}."\t".$peak_info{$peak}{$rep2_inputnorm_output_full}{l10p}."\n";

	if ($peak_geommean{$peak} >= $l2fc_cutoff && $peak_info{$peak}{$rep1_inputnorm_output_full}{l10p} >= $l10p_cutoff &&$peak_info{$peak}{$rep2_inputnorm_output_full}{l10p} >=$l10p_cutoff) {
            print BEDOUT "".$chr."\t".$start."\t".$stop."\t".&min($peak_info{$peak}{$rep1_inputnorm_output_full}{l10p},$peak_info{$peak}{$rep2_inputnorm_output_full}{l10p})."\t".$peak_geommean{$peak}."\t".$str."\n";

        }

	my @rep1_full = split(/\t/,$peak_info{$peak}{$rep1_inputnorm_output_full}{full});
	$rep1_full[3] .= ":".$peak_geommean{$peak};
	my $rep1_full_join = join("\t",@rep1_full);
	print REP1FULL "".$rep1_full_join."\n";

	my @rep2_full = split(/\t/,$peak_info{$peak}{$rep2_inputnorm_output_full}{full});
	$rep2_full[3] .= ":".$peak_geommean{$peak};
	my $rep2_full_join = join("\t",@rep2_full);
        print REP2FULL "".$rep2_full_join."\n";


    }



}

print STDERR "IDR and geommean(fc) >= 3 && p-value >= 3 in both reps: $count_signif\n";
close(REP1FULL);
close(REP2FULL);
close(CUSTOMOUT);
close(BEDOUT);




sub parse_inputnorm_fullfile {
    my $inpnorm_file = shift;
    open(INF,$inpnorm_file) || die "no $inpnorm_file\n";
    for my $line (<INF>) {
	chomp($line);
	my @tmp = split(/\t/,$line);
	my $chr = $tmp[0];
	my $start = $tmp[1];
	my $stop = $tmp[2];
	my ($chr2,$pos2,$str,$del) = split(/\:/,$tmp[3]);
	$tmp[3] = $chr2.":".$pos2.":".$str;
	my $l2fc = $tmp[11];
	my $l10p = $tmp[10];

	$peak_info{$chr.":".$start."-".$stop.":".$str}{$inpnorm_file}{l2fc} = $l2fc;
        $peak_info{$chr.":".$start."-".$stop.":".$str}{$inpnorm_file}{l10p} = $l10p;
	$peak_info{$chr.":".$start."-".$stop.":".$str}{$inpnorm_file}{full} = join("\t",@tmp);

    }
    close(INF);

}

sub parse_bam_file {
    my $file = shift;
    open(F,$file);
    for my $line (<F>) {
        chomp($line);
        my ($chr,$start,$stop,$l10p,$l2fc,$str) = split(/\t/,$line);

        $peak_info{$chr.":".$start."-".$stop.":".$str}{$file}{l2fc} = $l2fc;
        $peak_info{$chr.":".$start."-".$stop.":".$str}{$file}{l10p} = $l10p;
#	print "info ".$chr.":".$start."-".$stop.":".$str." file ".$file." l2fc $l2fc\n";

    }
    close(F);

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
        # my $entropy = $tmp[15]; # if we don't annotate, this is the 13th column
        my $entropy = $tmp[12];
        my $l2fc = $tmp[11];
        my $l10p = $tmp[10];

        next unless ($l2fc >= 3 && $l10p >= 3);
#       print "chr $chr start $start stop $stop str $str l2 $l2fc l10p $l10p ent $entropy\n";


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
	
	if (scalar(keys %overlapping_idrs) > 0) {
	    
	    if (scalar(keys %overlapping_idrs) > 1) {
		print STDERR "This should NEVER be hit - peak overlaps with more than one IDR region $line\n".join("\t",keys %overlapping_idrs)."\n---\n";
	    }

	    my @sorted_idr = keys %overlapping_idrs;
	    my $overlapping_idrpeak = $sorted_idr[0];	    
	    my ($ichr,$ipos,$istr,$iidr) = split(/\:/,$overlapping_idrpeak);

	    if ($iidr >= $idr_cutoffs{$idr_cutoff}) {
		$idrregion2peaks{$overlapping_idrpeak}{$chr.":".$start."-".$stop.":".$str} = 1;
	    }
	} else {
	    # peak not in IDR list

	}
    }
    close(F);
}




sub parse_idr_file {
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


sub min {
    my $x = shift;
    my $y = shift;
    if ($x < $y) {
	return($x);
    } else {
	return($y);
    }
}
