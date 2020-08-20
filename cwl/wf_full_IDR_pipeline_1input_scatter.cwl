#!/usr/bin/env cwltool

doc: |
  The main workflow that:
   produces two reproducible peaks via IDR given two eCLIP samples (1 input, 1 IP each).
   runs the 'rescue ratio' statistic
   runs the 'consistency ratio' statistic

cwlVersion: v1.0
class: Workflow


requirements:
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement      # TODO needed?
  - class: MultipleInputFeatureRequirement

inputs:

  species:
    type: string

  samples:
    type:
      type: array
      items:
        type: array
        items:
          type: record
          fields:
            ip_bam:
              type: File
            input_bam:
              type: File
            peak_clusters:
              type: File
            name:
              type: string

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

  ## MAPPED READ NUMBERS ##

  rep1_clip_read_num:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_clip_read_num
  rep2_clip_read_num:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_clip_read_num
  rep1_input_read_num:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_input_read_num
  rep2_input_read_num:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_input_read_num


  ## INPUT NORMALIZATION 1 ##

  rep1_input_normed_bed:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_input_normed_bed
  rep2_input_normed_bed:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_input_normed_bed
  rep1_input_normed_full:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_input_normed_full
  rep2_input_normed_full:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_input_normed_full
  rep1_compressed_bed:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_compressed_bed
  rep2_compressed_bed:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_compressed_bed


  ## ENTROPY FILES ##

  rep1_entropy_full:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_entropy_full
  rep2_entropy_full:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_entropy_full
  rep1_entropy_excess_reads:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_entropy_excess_reads
  rep2_entropy_excess_reads:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_entropy_excess_reads
  rep1_entropy_bed:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_entropy_bed
  rep2_entropy_bed:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_entropy_bed


  ## IDR OUTPUTS ##

  idr_output:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_idr_output
  idr_output_bed:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_idr_output_bed


  ## ERICS SPLIT-JOIN PEAKS ##

  rep1_idr_output_input_normed_bed:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_idr_output_input_normed_bed
  rep2_idr_output_input_normed_bed:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_idr_output_input_normed_bed
  rep1_idr_output_input_normed_full:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_idr_output_input_normed_full
  rep2_idr_output_input_normed_full:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_idr_output_input_normed_full
  rep1_reproducing_peaks_full:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep1_reproducing_peaks_full
  rep2_reproducing_peaks_full:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rep2_reproducing_peaks_full


  ## FINAL OUTPUTS ##

  rescue_ratio:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_rescue_ratio
  self_consistency_ratio:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_self_consistency_ratio
  reproducible_peaks:
    type: File[]
    outputSource: wf_full_IDR_pipeline_1input_sample/wf_full_IDR_pipeline_1input_sample_reproducible_peaks

steps:

  wf_full_IDR_pipeline_1input_sample:
    run: wf_full_IDR_pipeline_1input_sample.cwl
    scatter: sample
    in:
      sample: samples
      species: species
      split_peaks_bed: split_peaks_bed
      split_peaks_custombed: split_peaks_custombed
      rep1_merged_peaks_bed_from_cc: rep1_merged_peaks_bed_from_cc
      rep1_merged_peaks_custombed_from_cc: rep1_merged_peaks_custombed_from_cc
      rep2_merged_peaks_bed_from_cc: rep2_merged_peaks_bed_from_cc
      rep2_merged_peaks_custombed_from_cc: rep2_merged_peaks_custombed_from_cc
    out: [
      wf_full_IDR_pipeline_1input_sample_rep1_clip_read_num,
      wf_full_IDR_pipeline_1input_sample_rep2_clip_read_num,
      wf_full_IDR_pipeline_1input_sample_rep1_input_read_num,
      wf_full_IDR_pipeline_1input_sample_rep2_input_read_num,
      wf_full_IDR_pipeline_1input_sample_rep1_input_normed_bed,
      wf_full_IDR_pipeline_1input_sample_rep2_input_normed_bed,
      wf_full_IDR_pipeline_1input_sample_rep1_input_normed_full,
      wf_full_IDR_pipeline_1input_sample_rep2_input_normed_full,
      wf_full_IDR_pipeline_1input_sample_rep1_compressed_bed,
      wf_full_IDR_pipeline_1input_sample_rep2_compressed_bed,
      wf_full_IDR_pipeline_1input_sample_rep1_entropy_full,
      wf_full_IDR_pipeline_1input_sample_rep2_entropy_full,
      wf_full_IDR_pipeline_1input_sample_rep1_entropy_excess_reads,
      wf_full_IDR_pipeline_1input_sample_rep2_entropy_excess_reads,
      wf_full_IDR_pipeline_1input_sample_rep1_entropy_bed,
      wf_full_IDR_pipeline_1input_sample_rep2_entropy_bed,
      wf_full_IDR_pipeline_1input_sample_idr_output,
      wf_full_IDR_pipeline_1input_sample_idr_output_bed,
      wf_full_IDR_pipeline_1input_sample_rep1_idr_output_input_normed_bed,
      wf_full_IDR_pipeline_1input_sample_rep2_idr_output_input_normed_bed,
      wf_full_IDR_pipeline_1input_sample_rep1_idr_output_input_normed_full,
      wf_full_IDR_pipeline_1input_sample_rep2_idr_output_input_normed_full,
      wf_full_IDR_pipeline_1input_sample_rep1_reproducing_peaks_full,
      wf_full_IDR_pipeline_1input_sample_rep2_reproducing_peaks_full,
      wf_full_IDR_pipeline_1input_sample_reproducible_peaks,
      wf_full_IDR_pipeline_1input_sample_rescue_ratio,
      wf_full_IDR_pipeline_1input_sample_self_consistency_ratio
    ]
