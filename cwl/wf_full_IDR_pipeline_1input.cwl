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


outputs:


  rep1_clip_read_num:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_clip_read_num
  rep1_input_read_num:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_input_read_num


  rep1_input_normed_bed:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_input_normed_bed
  rep1_input_normed_full:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_input_normed_full


  rep1_compressed_bed:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_compressed_bed
  rep1_entropy_full:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_entropy_full
  rep1_entropy_excess_reads:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_entropy_excess_reads
  rep1_entropy_bed:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_entropy_bed


  rep2_clip_read_num:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_clip_read_num
  rep2_input_read_num:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_input_read_num


  rep2_input_normed_bed:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_input_normed_bed
  rep2_input_normed_full:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_input_normed_full

  rep2_compressed_bed:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_compressed_bed
  rep2_entropy_full:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_entropy_full
  rep2_entropy_excess_reads:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_entropy_excess_reads
  rep2_entropy_bed:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_entropy_bed


  idr_output:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/idr_output

  idr_output_bed:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/idr_output_bed


  rep1_idr_output_input_normed_bed:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_idr_output_input_normed_bed
  rep2_idr_output_input_normed_bed:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_idr_output_input_normed_bed


  rep1_idr_output_input_normed_full:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_idr_output_input_normed_full
  rep2_idr_output_input_normed_full:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_idr_output_input_normed_full


  rep1_reproducing_peaks_full:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep1_reproducing_peaks_full
  rep2_reproducing_peaks_full:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/rep2_reproducing_peaks_full


  merged_peaks_bed_file:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/merged_peaks_bed_file
  merged_peaks_custombed_file:
    type: File
    outputSource: wf_get_reproducible_eclip_peaks/merged_peaks_custombed_file
  reproducing_peaks_count:
     type: int
     outputSource: wf_get_reproducible_eclip_peaks/reproducing_peaks_count

  rescue_ratio:
    type: float
    outputSource: wf_rescue_ratio_two_inputs/rescue_ratio
  true_reproducible_peaks:
    type: File
    outputSource: wf_rescue_ratio_two_inputs/true_reproducible_peaks
  self_consistency_ratio:
    type: float
    outputSource: wf_self_consistency_ratio/self_consistency_ratio

steps:

  wf_get_reproducible_eclip_peaks:
    run: wf_get_reproducible_eclip_peaks.cwl
    in:
      rep1_clip_bam_file: rep1_clip_bam_file
      rep1_input_bam_file: rep1_input_bam_file
      rep1_peaks_bed_file: rep1_peaks_bed_file
      rep2_clip_bam_file: rep2_clip_bam_file
      rep2_input_bam_file: rep2_input_bam_file
      rep2_peaks_bed_file: rep2_peaks_bed_file
      merged_peaks_bed: merged_peaks_bed
      merged_peaks_custombed: merged_peaks_custombed
    out: [
      rep1_clip_read_num,
      rep1_input_read_num,
      rep1_input_normed_bed,
      rep1_input_normed_full,
      rep1_compressed_bed,
      rep1_entropy_full,
      rep1_entropy_excess_reads,
      rep1_entropy_bed,
      rep2_clip_read_num,
      rep2_input_read_num,
      rep2_input_normed_bed,
      rep2_input_normed_full,
      rep2_compressed_bed,
      rep2_entropy_full,
      rep2_entropy_excess_reads,
      rep2_entropy_bed,
      idr_output,
      idr_output_bed,
      rep1_idr_output_input_normed_bed,
      rep2_idr_output_input_normed_bed,
      rep1_idr_output_input_normed_full,
      rep2_idr_output_input_normed_full,
      rep1_reproducing_peaks_full,
      rep2_reproducing_peaks_full,
      merged_peaks_bed_file,
      merged_peaks_custombed_file,
      reproducing_peaks_count
    ]
  wf_rescue_ratio_two_inputs:
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
    out: [
      rescue_ratio,
      true_reproducible_peaks
    ]
  wf_self_consistency_ratio:
    run: wf_self_consistency_ratio.cwl
    in:
      rep1_clip_bam_file: rep1_clip_bam_file
      rep1_input_bam_file: rep1_input_bam_file
      rep2_clip_bam_file: rep2_clip_bam_file
      rep2_input_bam_file: rep2_input_bam_file
      species: species
    out: [
      self_consistency_ratio
    ]