#!/usr/bin/env cwltool

doc: |
  Computes the self-consistency ratio (see Gabe's protocols paper, or CHIP SEQ)


cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement
  - class: InlineJavascriptRequirement

inputs:

  rep1_name:
    type: string
  rep1_clip_bam_file:
    type: File
  rep1_input_bam_file:
    type: File
    
  rep2_name:
    type: string
  rep2_clip_bam_file:
    type: File
  rep2_input_bam_file:
    type: File
    
  species:
    type: string

  ### DEFAULTS (optional) ###

  rep1_merged_peaks_bed:
    type: string
    default: "rep1_split_reproducible_peaks.bed"
  rep1_merged_peaks_custombed:
    type: string
    default: "rep1_split_reproducible_peaks.custombed"
  rep2_merged_peaks_bed:
    type: string
    default: "rep2_split_reproducible_peaks.bed"
  rep2_merged_peaks_custombed:
    type: string
    default: "rep2_split_reproducible_peaks.custombed"

outputs:

  self_consistency_ratio:
    type: File
    outputSource: step_self_consistency/ratio
  rep1_reproducing_peaks_count:
      type: int
      outputSource: step_split_rep1_and_idr/reproducing_peaks_count
  rep2_reproducing_peaks_count:
      type: int
      outputSource: step_split_rep2_and_idr/reproducing_peaks_count

steps:

  step_split_rep1_and_idr:
    run: wf_split_self_and_idr.cwl
    in:
      clip_bam: rep1_clip_bam_file
      input_bam: rep1_input_bam_file
      species: species
      merged_peaks_bed: rep1_merged_peaks_bed
      merged_peaks_custombed: rep1_merged_peaks_custombed
    out:
      - reproducing_peaks_count


  step_split_rep2_and_idr:
    run: wf_split_self_and_idr.cwl
    in:
      clip_bam: rep2_clip_bam_file
      input_bam: rep2_input_bam_file
      species: species
      merged_peaks_bed: rep2_merged_peaks_bed
      merged_peaks_custombed: rep2_merged_peaks_custombed
    out:
      - reproducing_peaks_count


  step_self_consistency:
    run: max_over_min.cwl
    in:
      count1: step_split_rep1_and_idr/reproducing_peaks_count
      count2: step_split_rep2_and_idr/reproducing_peaks_count
      output_file: 
        source: [rep1_name, rep2_name]
        valueFrom: |
          ${
            return self[0] + ".vs." + self[1] + ".consistency";
          }
    out:
      - ratio

doc: |
  Given two replicates, split each and perform IDR on each fragment.
  Returns the ratio of max(N1, N2)/min(N1, N2) where N1, N2 are
  the numbers of reproducible peaks found between each rep split pair.
