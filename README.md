# merge_peaks
CWL-defined pipeline for using IDR to produce a set of peaks given two replicate eCLIP peaks

# Tested with:

Perl scripts:
- perl=5.10.1
    - Statistics::Basic
    - Statistics::Distributions
    - Statistics::R
IDR:
- IDR=2.0.2
    - python=3.4
        - numpy=1.11.3
        - scipy=0.13.0
Other:
- cwl=1.0

# Installation:
- (For YEOLAB: ```module load eclipidrmergepeaks/0.1.0```)

##### For all others:
- run and source the ```source create_environment.sh``` bash script
- install perlbrew: https://perlbrew.pl/ (skip if you want to use your system perl)
- install perl modules:
    - ```cpan install Statistics::Basic```
    - ```cpan install Statistics::Distributions```
    - ```cpan install Statistics::R```
- install IDR
    - [```docker pull brianyee/idr:2.0.2```](https://hub.docker.com/repository/docker/brianyee/idr)
- install CWL
    - [```pip install cwl```](https://pypi.org/project/cwltool/1.0.20160325210917/)

# Outline of workflow:
- Normalize CLIP BAM over INPUT for each replicate (overlap_peakfi_with_bam_PE.cwl)
- Peak compression/merging on input-normalized peaks for each replicate (compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat_outputfull.cwl)
- Entropy calculation on CLIP and INPUT read probabilities within each peak for each replicate (make_informationcontent_from_peaks.cwl)
- Reformat *.full files into *.bed files for each replicate (full_to_bed.cwl)
- Run IDR on peaks ranked by entropy (idr.cwl)
- Calculates summary statistics at different IDR cutoffs (parse_idr_peaks.cwl)
- Normalize CLIP BAM over INPUT using new IDR peak positions (overlap_peakfi_with_bam_PE.cwl)
- Identifies reproducible peaks within IDR regions (get_reproducing_peaks.cwl)

# Usage:
(see the examples/merge_peaks_1input.yaml or examples/merge_peaks_2inputs.yaml manifest file for a full example). Below is a description of all fields
required to be filled out in the manifest file:

First, use the [example template](https://github.com/YeoLab/merge_peaks/tree/master/examples) to fill out the names and paths pertaining to your samples. The shebang "#!" line will depend on your experimental setup (either 2 replicates with 2 corresponding inputs, or 2 replicates normalized over 1 input). 

This should match what was used to call [CLIPper](http://github.com/yeolab/clipper) peaks.
```
species: hg19
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped CLIP reads mapping to the genome for Replicate 1. Replace "rep1" with a unique ID for each rep1.
```
    - name: "rep1"
      ip_bam: 
        class: File
        path: /home/centos/peCLIP_inputs/ENCFF994WPX.r2.bam
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped INPUT reads mapping to the genome for Replicate 1.
```
      input_bam:
        class: File
        path: /home/centos/peCLIP_inputs/ENCFF590UCY.r2.bam
```

BED file containing the called peak clusters for Replicate 1 <b>Output from either CLIPPER or input-normed peaks</b>. This pipeline will perform input norm internally for you, so it won't really matter which file you use.
```
      peak_clusters:
        class: File
        path: /home/centos/peCLIP_inputs/ENCFF639MYI.bed6
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped CLIP reads mapping to the genome for Replicate 2. Replace "rep2" with a unique ID for each rep2.
```
    - name: "rep2"
      ip_bam: 
        class: File
        path: /home/centos/peCLIP_inputs/ENCFF154BQS.r2.bam
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped INPUT reads mapping to the genome for Replicate 2.
```
      input_bam:
        class: File
        path: /home/centos/peCLIP_inputs/ENCFF590UCY.r2.bam
```

BED file containing the called peak clusters for Replicate 2 <b>Output from CLIPPER or input-normed peaks</b>. This pipeline will perform input norm internally for you.
```
      peak_clusters:
        class: File
        path: /home/centos/peCLIP_inputs/ENCFF664WCU.bed6
```

### FINAL OUTPUTS

Merged reproducible peaks are reported as: 

```bash
rep1.vs.rep2.bed
```

Where ```rep1``` and ```rep2``` are the user-defined names in the manifest.

# To run the workflow:
- Ensure that the yaml file is accessible and that wf_get_reproducible_eclip_peaks.cwl is in your $PATH.
- Type: ```./merge_peaks_2inputs.yaml```

# Outputs
- merged_peaks_bed: this is the BED6 file containing reproducible peaks as
determined by entropy-ordered peaks between two replicates.
    - chrom
    - start
    - end
    - minimum of the -log10 p-value between two replicates (coolumn 4)
    - geomean of the log2 fold changes (column 5)
    - strand
This is probably what will be useful.
- *.full files: these tabbed outputs have the following columns (in order):
    - chromosome
    - start
    - end
    - name (colon separated region)
    - reads in CLIP
    - reads in INPUT
    - p-value
    - chi value or (F)isher
    - (F)isher or (C)hi square test
    - enriched or depleted
    - negative log10p value (400 if above certain threshold)
    - log2 fold change
    - entropy
- idr.out: output from IDR
- idr.out.bed: output from IDR as a bed file
- *.custombed: contains individual replicate information. The headers are:
    - IDR region (entire IDR identified reproducible region)
    - peak (reproducible peak region)
    - geomean of the l2fc
    - rep1 log2 fold change
    - rep2 log2 fold change
    - rep1 -log10 pvalue
    - rep2 -log10 pvalue

# Notes:
- The current conda version of perl installed using ```create_environment_merge_peaks.sh```
will install perl v5.22.0, which is different from the version tested on TSCC
(5.10.1). Since 5.18, there have been slight changes resulting in hash keys
being accessed in a non-deterministic way. Installing 5.22.0 will result in
minor changes from the reference, but will otherwise give similar outputs.
Included is a script ```run_perlbrew_perl5.10.1.sh``` which will attempt to
install perl 5.10.1, which will give you deterministic results.
- Custombed files are staged for deprecation, we don't usually use this.
