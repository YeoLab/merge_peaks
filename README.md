# merge_peaks
CWL-defined pipeline for using IDR to produce a set of peaks given two replicate eCLIP peaks

# Requires:

- perl=5.10.1 (untested with 5.22 but should work although not guaranteed to be identical to ENCODE outputs)
    - Statistics::Basic
    - Statistics::Distributions
    - Statistics::R
- IDR=2.0.2
- python=3.4.5
    - numpy=1.11
    - pandas=0.20
    - scipy=0.18
    - setuptools=27.2
    - matplotlib=2.0
- cwl=1.0

# Installation:
- (For YEOLAB: ```module load eclipidrmergepeaks/0.0.5```)

##### For all others:
- run and source the ```source create_environment.sh``` bash script
- install perlbrew: https://perlbrew.pl/ (skip if you want to use your system perl)
- run and source the ```source run_perlbrew_perl5.10.1.sh``` bash script (skip if you want to use your system perl)
- install perl modules:
    - ```cpan install Statistics::Basic```
    - ```cpan install Statistics::Distributions```
    - ```cpan install Statistics::R```

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
(see the example/204_RBFOX2.yaml manifest file for a full example). Below is a description of all fields
required to be filled out in the manifest file:

BAM file containing the merged-barcode (read 2 only) PCR-deduped CLIP reads mapping to the genome for Replicate 1.
```
rep1_clip_bam_file:
  class: File
  path: 204_01_RBFOX2.merged.r2.bam
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped INPUT reads mapping to the genome for Replicate 1.
```
rep1_input_bam_file:
  class: File
  path: RBFOX2-204-INPUT_S2_R1.unassigned.adapterTrim.round2.rmRep.rmDup.sorted.r2.bam
```

BED file containing the called peak clusters for Replicate 1 <b>Output from either CLIPPER or input-normed peaks</b>. This pipeline will perform input norm internally for you.
```
rep1_peaks_bed_file:
  class: File
  path: 204_01_RBFOX2.merged.r2.peaks.bed
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped CLIP reads mapping to the genome for Replicate 2.
```
rep2_clip_bam_file:
  class: File
  path: 204_02_RBFOX2.merged.r2.bam
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped INPUT reads mapping to the genome for Replicate 2.
```
rep2_input_bam_file:
  class: File
  path: RBFOX2-204-INPUT_S2_R1.unassigned.adapterTrim.round2.rmRep.rmDup.sorted.r2.bam
```

BED file containing the called peak clusters for Replicate 2 <b>Output from CLIPPER or input-normed peaks</b>. This pipeline will perform input norm internally for you.
```
rep2_peaks_bed_file:
  class: File
  path: 204_02_RBFOX2.merged.r2.peaks.bed
```

```
### FINAL OUTPUTS
merged_peaks_custombed: 204.01v02.IDR.out.0102merged.bed
merged_peaks_bed: 204.01v02.IDR.out.0102merged.custombed

```
# To run the workflow:
- Ensure that the yaml file is accessible and that wf_get_reproducible_eclip_peaks.cwl is in your $PATH.
- Type: ```./204_RBFOX2.yaml```

# Outputs
- merged_peaks_bed: this is the BED6 file containing reproducible peaks as
determined by entropy-ordered peaks between two replicates.
    - chrom
    - start
    - end
    - geomean of the log2 fold changes
    - minimum of the -log10 p-value between two replicates
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
