#!/usr/bin/env cwltool

doc: |
  This workflow essentially restructures the inputs before sending
  to wf_full_IDR_pipeline_1input.cwl

cwlVersion: v1.0

class: Workflow

requirements:
  - class: SubworkflowFeatureRequirement
  - class: MultipleInputFeatureRequirement

inputs:

  sample:
    type:
      # array of 2, for each rep
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

  species:
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

  wf_full_IDR_pipeline_1input_sample_rep1_clip_read_num:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_clip_read_num
  wf_full_IDR_pipeline_1input_sample_rep2_clip_read_num:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_clip_read_num
  wf_full_IDR_pipeline_1input_sample_rep1_input_read_num:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_input_read_num
  wf_full_IDR_pipeline_1input_sample_rep2_input_read_num:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_input_read_num


  ## INPUT NORMALIZATION 1 ##

  wf_full_IDR_pipeline_1input_sample_rep1_input_normed_bed:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_input_normed_bed
  wf_full_IDR_pipeline_1input_sample_rep2_input_normed_bed:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_input_normed_bed
  wf_full_IDR_pipeline_1input_sample_rep1_input_normed_full:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_input_normed_full
  wf_full_IDR_pipeline_1input_sample_rep2_input_normed_full:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_input_normed_full
  wf_full_IDR_pipeline_1input_sample_rep1_compressed_bed:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_compressed_bed
  wf_full_IDR_pipeline_1input_sample_rep2_compressed_bed:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_compressed_bed


  ## ENTROPY FILES ##

  wf_full_IDR_pipeline_1input_sample_rep1_entropy_full:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_entropy_full
  wf_full_IDR_pipeline_1input_sample_rep2_entropy_full:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_entropy_full
  wf_full_IDR_pipeline_1input_sample_rep1_entropy_excess_reads:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_entropy_excess_reads
  wf_full_IDR_pipeline_1input_sample_rep2_entropy_excess_reads:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_entropy_excess_reads
  wf_full_IDR_pipeline_1input_sample_rep1_entropy_bed:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_entropy_bed
  wf_full_IDR_pipeline_1input_sample_rep2_entropy_bed:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_entropy_bed


  ## IDR OUTPUTS ##

  wf_full_IDR_pipeline_1input_sample_idr_output:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_idr_output
  wf_full_IDR_pipeline_1input_sample_idr_output_bed:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_idr_output_bed


  ## SPLIT-JOIN PEAKS ##

  wf_full_IDR_pipeline_1input_sample_rep1_idr_output_input_normed_bed:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_idr_output_input_normed_bed
  wf_full_IDR_pipeline_1input_sample_rep2_idr_output_input_normed_bed:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_idr_output_input_normed_bed
  wf_full_IDR_pipeline_1input_sample_rep1_idr_output_input_normed_full:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_idr_output_input_normed_full
  wf_full_IDR_pipeline_1input_sample_rep2_idr_output_input_normed_full:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_idr_output_input_normed_full
  wf_full_IDR_pipeline_1input_sample_rep1_reproducing_peaks_full:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep1_reproducing_peaks_full
  wf_full_IDR_pipeline_1input_sample_rep2_reproducing_peaks_full:
    type: File
    outputSource: wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rep2_reproducing_peaks_full


  ## FINAL OUTPUTS ##

  wf_full_IDR_pipeline_1input_sample_reproducible_peaks:
    type: File
    outputSource:
      wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_reproducible_peaks
  wf_full_IDR_pipeline_1input_sample_rescue_ratio:
    type: File
    outputSource:
      wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_rescue_ratio
  wf_full_IDR_pipeline_1input_sample_self_consistency_ratio:
    type: File
    outputSource:
      wf_full_IDR_pipeline_1input/wf_full_IDR_pipeline_1input_self_consistency_ratio


steps:

  step_parse_sample_IDR:
    run: parse_sample_IDR.cwl
    in:
      sample: sample
    out: [
      rep1_name,
      rep1_ip_bam,
      rep1_input_bam,
      rep1_peak_clusters,
      rep2_name,
      rep2_ip_bam,
      rep2_input_bam,
      rep2_peak_clusters,
      reproducible_peaks,
      reproducible_peaks_custombed
    ]

  wf_full_IDR_pipeline_1input:
    run: wf_full_IDR_pipeline_1input.cwl
    in:
      rep1_name: step_parse_sample_IDR/rep1_name
      rep2_name: step_parse_sample_IDR/rep2_name
      
      rep1_clip_bam_file: step_parse_sample_IDR/rep1_ip_bam
      rep2_clip_bam_file: step_parse_sample_IDR/rep2_ip_bam

      input_bam_file: step_parse_sample_IDR/rep1_input_bam

      rep1_peaks_bed_file: step_parse_sample_IDR/rep1_peak_clusters
      rep2_peaks_bed_file: step_parse_sample_IDR/rep2_peak_clusters

      species: species

      merged_peaks_bed: step_parse_sample_IDR/reproducible_peaks
      merged_peaks_custombed: step_parse_sample_IDR/reproducible_peaks_custombed

      split_peaks_bed: split_peaks_bed
      split_peaks_custombed: split_peaks_custombed

      rep1_merged_peaks_bed_from_cc: rep1_merged_peaks_bed_from_cc
      rep1_merged_peaks_custombed_from_cc: rep1_merged_peaks_custombed_from_cc
      rep2_merged_peaks_bed_from_cc: rep2_merged_peaks_bed_from_cc
      rep2_merged_peaks_custombed_from_cc: rep2_merged_peaks_custombed_from_cc
    out: [
      wf_full_IDR_pipeline_1input_rep1_clip_read_num,
      wf_full_IDR_pipeline_1input_rep2_clip_read_num,
      wf_full_IDR_pipeline_1input_rep1_input_read_num,
      wf_full_IDR_pipeline_1input_rep2_input_read_num,
      wf_full_IDR_pipeline_1input_rep1_input_normed_bed,
      wf_full_IDR_pipeline_1input_rep2_input_normed_bed,
      wf_full_IDR_pipeline_1input_rep1_input_normed_full,
      wf_full_IDR_pipeline_1input_rep2_input_normed_full,
      wf_full_IDR_pipeline_1input_rep1_compressed_bed,
      wf_full_IDR_pipeline_1input_rep2_compressed_bed,
      wf_full_IDR_pipeline_1input_rep1_entropy_full,
      wf_full_IDR_pipeline_1input_rep2_entropy_full,
      wf_full_IDR_pipeline_1input_rep1_entropy_excess_reads,
      wf_full_IDR_pipeline_1input_rep2_entropy_excess_reads,
      wf_full_IDR_pipeline_1input_rep1_entropy_bed,
      wf_full_IDR_pipeline_1input_rep2_entropy_bed,
      wf_full_IDR_pipeline_1input_idr_output,
      wf_full_IDR_pipeline_1input_idr_output_bed,
      wf_full_IDR_pipeline_1input_rep1_idr_output_input_normed_bed,
      wf_full_IDR_pipeline_1input_rep2_idr_output_input_normed_bed,
      wf_full_IDR_pipeline_1input_rep1_idr_output_input_normed_full,
      wf_full_IDR_pipeline_1input_rep2_idr_output_input_normed_full,
      wf_full_IDR_pipeline_1input_rep1_reproducing_peaks_full,
      wf_full_IDR_pipeline_1input_rep2_reproducing_peaks_full,
      wf_full_IDR_pipeline_1input_reproducible_peaks,
      wf_full_IDR_pipeline_1input_rescue_ratio,
      wf_full_IDR_pipeline_1input_self_consistency_ratio
    ]
