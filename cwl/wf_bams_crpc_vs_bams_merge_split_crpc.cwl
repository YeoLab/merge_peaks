#!/usr/bin/env cwltool


### RESCUE RATIO ###
### https://www.google.com/url?q=https%3A%2F%2Fwww.encodeproject.org%2Fdata-standards%2Fterms%2F&sa=D&sntz=1&usg=AFQjCNFI_BjgnFhlrkbG6ByfLRkg9XEtgw


cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement


inputs:

  bam_rep1:
    type: File
  bam_rep2:
    type: File
  bam_input:
    type: File


outputs:

  rescue_ratio:
    type: File
    outputSource: max_over_min/ratio


steps:


  bams_merge:
    run: bams_merge.cwl
    in:
      bam_rep1: bam_rep1
      bam_rep2: bam_rep2
    out:
      - merged

  bams_merged_split:
    run: bam_split.cwl
    in:
      bam: bams_merge/merged
    out:
      - split1
      - split2

  bams_merged_splits_clipperreproducingpeakscount:
    run: wf_bams_clipperreproducingpeakscount.cwl
    in:
      bam_rep1: bams_merged_split/split1
      bam_rep1: bams_merged_split/split2
    out:
      - reproducing_peaks_count

  bams_clipperreproducingpeakscount:
    run: wf_bams_clipperreproducingpeakscount.cwl
    in:
      bam_rep2: bam_rep1
      bam_rep2: bam_rep2
    out:
      - reproducing_peaks_count


  max_over_min:
    run: max_over_min.cwl
    in:
      count1: bams_merged_splits_clipperreproducingpeakscount/reproducing_peaks_count
      count2: bams_clipperreproducingpeakscount/reproducing_peaks_count
    out:
      - ratio

