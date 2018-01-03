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
- (For YEOLAB: ```module load eclipidrmergepeaks/0.0.2```)

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
- Separate merged IDR peaks based on original replicate peak positions (parse_idr_peaks.cwl)
- Normalize CLIP BAM over INPUT using new IDR peak positions (overlap_peakfi_with_bam_PE.cwl)
- Re-merge peaks (get_reproducing_peaks.cwl)

# Usage:
(see the example/204_RBFOX2.yaml manifest file for a full example). Below is a description of all fields
required to be filled out in the manifest file:

BAM file containing the merged-barcode (read 2 only) PCR-deduped CLIP reads mapping to the genome for Replicate 1.
```
rep1ClipBam:
  class: File
  path: 204_01_RBFOX2.merged.r2.bam
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped INPUT reads mapping to the genome for Replicate 1.
```
rep1InputBam:
  class: File
  path: RBFOX2-204-INPUT_S2_R1.unassigned.adapterTrim.round2.rmRep.rmDup.sorted.r2.bam
```

BED file containing the called peaks for Replicate 1
```
rep1PeaksBed:
  class: File
  path: 204_01_RBFOX2.merged.r2.peaks.bed
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped CLIP reads mapping to the genome for Replicate 2.
```
rep2ClipBam:
  class: File
  path: 204_02_RBFOX2.merged.r2.bam
```

BAM file containing the merged-barcode (read 2 only) PCR-deduped INPUT reads mapping to the genome for Replicate 2.
```
rep2InputBam:
  class: File
  path: RBFOX2-204-INPUT_S2_R1.unassigned.adapterTrim.round2.rmRep.rmDup.sorted.r2.bam
```

BED file containing the called peaks for Replicate 2
```
rep2PeaksBed:
  class: File
  path: 204_02_RBFOX2.merged.r2.peaks.bed
```

These parameters describe the prefix attached to each replicate input normalization (step 1 in methods)
```
###
outputprefixRep1: "204_01"
outputprefixRep2: "204_01"
```

These parameters describe the file output names associated with IDR outputs (step 5 in methods)
```
###
idrOutputFilename: 204.01v02.idr.out
idrOutputBedFilename: 204.01v02.idr.out.bed
```

These parameters describe the file output names associated with de-merged IDR outputs (step 6 in methods)
```
### POST PROCESSING AFTER IDR  (ALSO TEMPORARY?)
idrInputNormRep1BedFilename: 204.01v02.IDR.out.idrpeaks_inputnormed.01.bed
idrInputNormRep2BedFilename: 204.01v02.IDR.out.idrpeaks_inputnormed.02.bed
```

These parameters describe the file output names associated with de-merged, input normalized FULL files (step 7 in methods)
```
### MERGE PEAKS
rep1ReproducingPeaksFullOutputFilename: 204.01v02.IDR.out.0102merged.01.full
rep2ReproducingPeaksFullOutputFilename: 204.01v02.IDR.out.0102merged.02.full
```

These parameters describe the file output names associated with appropriately re-merged peak files.
```
### FINAL OUTPUTS
mergedPeakBedFilename: 204.01v02.IDR.out.0102merged.bed
mergedPeakCustomBedFilename: 204.01v02.IDR.out.0102merged.custombed
```
# To run the workflow:
- ./204_RBFOX2.yaml

# Outputs
- mergedPeakBedFilename: this is the BED6 file containing reproducible peaks as
determined by entropy-ordered peaks between two replicates.
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
- *.custombed: ???

