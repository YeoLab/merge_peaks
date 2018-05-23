#!/usr/bin/env cwltool


### SELF-CONSISTENCY RATIO ###
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

#  bam_rep1_splits_reproducing_peaks_count:
#    type: File
#    outputSource: bam_rep1_splits_reproducingpeakscount/reproducing_peaks_count
#
#  bam_rep1_splits_reproducing_peaks_count:
#    type: File
#    outputSource: bam_rep2_splits_reproducingpeakscount/reproducing_peaks_count

  selfconssistency_ration:
    type: File
    outputSource: compare_rpcs/ration


steps:


  bam_rep1_split:
    run: bam_split.cwl
    in:
      bam_rep1: bam_rep1
    out:
      - split1
      - split2

  bam_rep2_split:
    run: bam_split.cwl
    in:
      bam_rep2: bam_rep2
    out:
      - split1
      - split2


  bam_rep1_splits_clipperreproducingpeakscount:
    run: wf_bams_clipperreproducingpeakscount.cwl
    in:
      bam_rep1: bam_rep1_split/split1
      bam_rep1: bam_rep1_split/split2
    out:
      - reproducing_peaks_count

  bam_rep2_splits_clipperreproducingpeakscount:
    run: wf_bams_clipperreproducingpeakscount.cwl
    in:
      bam_rep2: bam_rep2_split/split1
      bam_rep2: bam_rep2_split/split2
    out:
      - reproducing_peaks_count


  max_over_min:
    run: max_over_min.cwl
    in:
      count1: bam_rep1_splits_clipperreproducingpeakscount/reproducing_peaks_count
      count2: bam_rep2_splits_clipperreproducingpeakscount/reproducing_peaks_count
    out:
      - ratio

