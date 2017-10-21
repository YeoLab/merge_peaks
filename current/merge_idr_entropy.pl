use warnings;
use strict;


my $rep1_entropy = $ARGV[0];
my $rep2_entropy = $ARGV[1];
my $uid = $ARGV[2];
my $working_directory = $ARGV[3];

my %entropy_hash;
#    my $rep1_entropy = "/home/elvannostrand/data/clip/CLIPseq_analysis/ENCODE_FINALforpapers_20170325/IDR/".$uid.".01v02.IDR.out.0102merged.01.full.annotated_proxdist.entropy";
#    my $rep2_entropy = "/home/elvannostrand/data/clip/CLIPseq_analysis/ENCODE_FINALforpapers_20170325/IDR/".$uid.".01v02.IDR.out.0102merged.02.full.annotated_proxdist.entropy";
&read_entropy($uid,"01",$rep1_entropy);
&read_entropy($uid,"02",$rep2_entropy);

#my $annotated_fi = "/home/elvannostrand/data/clip/CLIPseq_analysis/ENCODE_FINALforpapers_20170325/IDR/".$uid.".01v02.IDR.out.0102merged.bed.annotated_proxdist";
my $annotated_fi = $working_directory."IDR/".$uid.".01v02.IDR.out.0102merged.bed.annotated_proxdist";
#my $annotated_fi = "/home/elvannostrand/data/clip/CLIPseq_analysis/Collaborations/IDR/".$uid.".01v02.IDR.out.0102merged.bed.annotated_proxdist";
my $outfi = $annotated_fi.".entropy";
open(OUTFI,">$outfi");
open(ANN,$annotated_fi) || die "no $annotated_fi\n";
for my $line (<ANN>) {
    chomp($line);
    my @tmp = split(/\t/,$line);
    
    my $peak = $tmp[0].":".$tmp[1]."-".$tmp[2].":".$tmp[5];
    my $geometric_mean = log(sqrt( (2 ** $entropy_hash{$peak}{$uid}{"01"}) * (2 ** $entropy_hash{$peak}{$uid}{"02"}) ))/log(2);
    print OUTFI "".$line."\t".sprintf("%.10f",$geometric_mean)."\n";
    
    
}
close(ANN);
close(OUTFI);



sub read_entropy {
    my $uid = shift;
    my $rep = shift;

    my $file = shift;
    open(F,$file) || die "no $file\n";
    for my $line (<F>) {
	chomp($line);
	my @tmp = split(/\t/,$line);
	
	my $chr = $tmp[0];
	my $start = $tmp[1];
	my $stop = $tmp[2];

	my ($chr2,$pos,$str,$del) = split(/\:/,$tmp[3]);
	
	my $peak = $chr.":".$start."-".$stop.":".$str;

	my $entropy = $tmp[15];
	$entropy_hash{$peak}{$uid}{$rep} = $entropy;
    }
    close(F);


}
