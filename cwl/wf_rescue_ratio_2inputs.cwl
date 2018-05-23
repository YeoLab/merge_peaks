#!/usr/bin/env cwltool

doc: |
  Calculates the rescue ratio (see Gabe's protocols paper), given
  two eCLIP IP samples and 2 size-matched input samples. Also returns
  the reproducible peaks given these two samples. This is different from
  the 1input workflow in that each INPUT is first merged together and
  is used downstream instead of the 1input version, which remains unmodified.
  Merged inputs are NOT used in calculating true reproducible peaks.

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
  rep1_clip_peaks_file:
    type: File

  rep2_clip_bam_file:
    type: File
  rep2_input_bam_file:
    type: File
  rep2_clip_peaks_file:
    type: File

  species:
    type: string

  merged_peaks_bed:
    type: string
  merged_peaks_custombed:
    type: string

outputs:

  rescue_ratio:
    type: float
    outputSource: step_rescue_ratio/ratio

  true_reproducible_peaks:
    type: File
    outputSource: step_get_true_reproducing_peaks/merged_peaks_bed_file

steps:

  step_merge_clip_bams:
    run: bams_merge.cwl
    in:
      rep1_bam: rep1_clip_bam_file
      rep2_bam: rep2_clip_bam_file
    out:
      - merged_bam_file

  step_merge_input_bams:
    run: bams_merge.cwl
    in:
      rep1_bam: rep1_input_bam_file
      rep2_bam: rep2_input_bam_file
    out:
      - merged_bam_file

  step_get_true_reproducing_peaks:
    run: wf_get_reproducible_eclip_peaks.cwl
    in:
      rep1_clip_bam_file: rep1_clip_bam_file
      rep1_input_bam_file: rep1_input_bam_file
      rep1_peaks_bed_file: rep1_clip_peaks_file

      rep2_clip_bam_file: rep2_clip_bam_file
      rep2_input_bam_file: rep2_input_bam_file
      rep2_peaks_bed_file: rep2_clip_peaks_file

      merged_peaks_bed: merged_peaks_bed
      merged_peaks_custombed: merged_peaks_custombed

    out:
      - reproducing_peaks_count
      - merged_peaks_bed_file
      - merged_peaks_custombed_file

  step_split_merged_bam_and_idr:
    run: wf_split_self_and_idr.cwl
    in:
      clip_bam: step_merge_clip_bams/merged_bam_file
      input_bam: step_merge_input_bams/merged_bam_file
      species: species
      merged_peaks_bed:
        default: "temp_split_IDR_peaks.bed"
      merged_peaks_custombed:
        default: "temp_split_IDR_peaks.custombed"
    out:
      - reproducing_peaks_count

  step_rescue_ratio:
    run: max_over_min.cwl
    in:
      count1: step_get_true_reproducing_peaks/reproducing_peaks_count
      count2: step_split_merged_bam_and_idr/reproducing_peaks_count
    out:
      - ratio
