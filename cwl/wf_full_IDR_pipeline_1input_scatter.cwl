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
  rep1_peaks_bed_file:
    type: File

  rep2_clip_bam_file:
    type: File
  rep2_peaks_bed_file:
    type: File

  input_bam_file:
    type: File

  species:
    type: string

  # FINAL OUTPUTS
  merged_peaks_bed:
    type: string
  merged_peaks_custombed:
    type: string

outputs:

  rescue_ratio:
    type: float
    outputSource: wf_rescue_ratio_one_input/rescue_ratio
  reproducible_peaks:
    type: File
    outputSource: wf_rescue_ratio_one_input/true_reproducible_peaks
  self_consistency_ratio:
    type: float
    outputSource: wf_self_consistency_ratio/self_consistency_ratio

steps:

  wf_rescue_ratio_one_input:
    run: wf_rescue_ratio_1input.cwl
    in:
      rep1_clip_bam_file: rep1_clip_bam_file
      rep1_peaks_bed_file: rep1_peaks_bed_file
      rep2_clip_bam_file: rep2_clip_bam_file
      rep2_peaks_bed_file: rep2_peaks_bed_file
      input_bam_file: input_bam_file
      species: species
      merged_peaks_bed: merged_peaks_bed
      merged_peaks_custombed: merged_peaks_custombed
    out: [
      rescue_ratio,
      true_reproducible_peaks
    ]
  wf_self_consistency_ratio:
    run: wf_self_consistency_ratio.cwl
    in:
      rep1_clip_bam_file: rep1_clip_bam_file
      rep1_input_bam_file: input_bam_file
      rep2_clip_bam_file: rep2_clip_bam_file
      rep2_input_bam_file: input_bam_file
      species: species
    out: [
      self_consistency_ratio
    ]