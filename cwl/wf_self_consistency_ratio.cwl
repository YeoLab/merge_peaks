#!/usr/bin/env cwltool

doc: |
  Computes the self-consistency ratio (see Gabe's protocols paper, or CHIP SEQ)


cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement


inputs:

  rep1_bam_file:
    type: File
  rep1_input_bam_file:
    type: File
  rep2_bam_file:
    type: File
  rep2_input_bam_file:
    type: File
  species:
    type: string

outputs:

  self_consistency_ratio:
    type: float
    outputSource: step_self_consistency/ratio

steps:

  step_split_rep1_and_idr:
    run: wf_split_self_and_idr.cwl
    in:
      clip_bam: rep1_bam_file
      input_bam: rep1_input_bam_file
      species: species
      merged_peaks_bed:
        default: "rep1_split_reproducible_peaks.bed"
      merged_peaks_custombed:
        default: "rep1_split_reproducible_peaks.custombed"
    out:
      - reproducing_peaks_count


  step_split_rep2_and_idr:
    run: wf_split_self_and_idr.cwl
    in:
      clip_bam: rep2_bam_file
      input_bam: rep2_input_bam_file
      species: species
      merged_peaks_bed:
        default: "rep2_split_reproducible_peaks.bed"
      merged_peaks_custombed:
        default: "rep2_split_reproducible_peaks.custombed"
    out:
      - reproducing_peaks_count


  step_self_consistency:
    run: max_over_min.cwl
    in:
      count1: step_split_rep1_and_idr/reproducing_peaks_count
      count2: step_split_rep2_and_idr/reproducing_peaks_count
    out:
      - ratio

doc: |
  Given two replicates, split each and perform IDR on each fragment.
  Returns the ratio of max(N1, N2)/min(N1, N2) where N1, N2 are
  the numbers of reproducible peaks found between each rep split pair.