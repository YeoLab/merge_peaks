#!/usr/bin/env cwltool

doc: |
  The main workflow that:
   produces two reproducible peaks via IDR given two eCLIP samples (1 input, 1 IP each).
   runs the 'rescue ratio' statistic
   runs the 'consistency ratio' statistic

cwlVersion: v1.0
class: Workflow


requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement


inputs:

  rep1_clip_bam_file:
    type: File
  rep1_input_bam_file:
    type: File
  rep1_peaks_bed_file:
    type: File

  rep2_clip_bam_file:
    type: File
  rep2_input_bam_file:
    type: File
  rep2_peaks_bed_file:
    type: File

  species:
    type: string

  # FINAL OUTPUTS
  merged_peaks_bed:
    type: string
  merged_peaks_custombed:
    type: string

  merged_peaks_bed_from_rr:
    type: string
    default: "reproducible_peaks_from_rescue_ratio.bed"
  merged_peaks_custombed_from_rr:
    type: string
    default: "reproducible_peaks_from_rescue_ratio.custombed"

  split_peaks_bed:
    type: string
    default: "temp_split_IDR_peaks.bed"
  split_peaks_custombed:
    type: string
    default: "temp_split_IDR_peaks.custombed"

  rep1_merged_peaks_bed_from_cc:
    type: string
    default: "rep1_split_reproducible_peaks.bed"
  rep1_merged_peaks_custombed_from_cc:
    type: string
    default: "rep1_split_reproducible_peaks.custombed"
  rep2_merged_peaks_bed_from_cc:
    type: string
    default: "rep2_split_reproducible_peaks.bed"
  rep2_merged_peaks_custombed_from_cc:
    type: string
    default: "rep2_split_reproducible_peaks.custombed"

outputs:

  self_consistency_ratio:
    type: float
    outputSource: wf_self_consistency_ratio/self_consistency_ratio

steps:

  wf_self_consistency_ratio:
    run: wf_self_consistency_ratio.cwl
    in:
      rep1_clip_bam_file: rep1_clip_bam_file
      rep1_input_bam_file: rep1_input_bam_file
      rep2_clip_bam_file: rep2_clip_bam_file
      rep2_input_bam_file: rep2_input_bam_file
      species: species
      rep1_merged_peaks_bed: rep1_merged_peaks_bed_from_cc
      rep1_merged_peaks_custombed: rep1_merged_peaks_custombed_from_cc
      rep2_merged_peaks_bed: rep2_merged_peaks_bed_from_cc
      rep2_merged_peaks_custombed: rep2_merged_peaks_custombed_from_cc
    out: [
      self_consistency_ratio
    ]
