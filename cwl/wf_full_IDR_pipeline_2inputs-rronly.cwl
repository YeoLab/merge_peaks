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

outputs:

  rescue_ratio:
    type: float
    outputSource: wf_rescue_ratio_2inputs/wf_rescue_ratio_2inputs_rescue_ratio
  reproducible_peaks:
    type: File
    outputSource: wf_rescue_ratio_2inputs/wf_rescue_ratio_2inputs_reproducible_peaks

steps:

  wf_rescue_ratio_2inputs:
    run: wf_rescue_ratio_2inputs.cwl
    in:
      rep1_clip_bam_file: rep1_clip_bam_file
      rep1_input_bam_file: rep1_input_bam_file
      rep1_peaks_bed_file: rep1_peaks_bed_file
      rep2_clip_bam_file: rep2_clip_bam_file
      rep2_input_bam_file: rep2_input_bam_file
      rep2_peaks_bed_file: rep2_peaks_bed_file
      species: species
      merged_peaks_bed: merged_peaks_bed_from_rr
      merged_peaks_custombed: merged_peaks_custombed_from_rr
      split_peaks_bed: split_peaks_bed
      split_peaks_custombed: split_peaks_custombed
    out: [
      wf_rescue_ratio_2inputs_rescue_ratio,
      wf_rescue_ratio_2inputs_reproducible_peaks
    ]
