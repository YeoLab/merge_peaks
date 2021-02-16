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
  - class: InlineJavascriptRequirement
  
inputs:

  rep1_name:
    type: string
  rep1_clip_bam_file:
    type: File
  rep1_input_bam_file:
    type: File
  rep1_peaks_bed_file:
    type: File

  rep2_name:
    type: string
  rep2_clip_bam_file:
    type: File
  rep2_input_bam_file:
    type: File
  rep2_peaks_bed_file:
    type: File

  species:
    type: string

  merged_peaks_bed:
    type: string
  merged_peaks_custombed:
    type: string

  chrom_sizes:
    type: File
    
  ## DEFAULT FILENAMES ##
  split_peaks_bed:
    type: string
    default: "temp_split_IDR_peaks.bed"

  split_peaks_custombed:
    type: string
    default: "temp_split_IDR_peaks.custombed"

outputs:

  ## MAPPED READ NUMBERS ##

  rep1_clip_read_num:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_clip_read_num
  rep2_clip_read_num:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_clip_read_num
  rep1_input_read_num:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_input_read_num
  rep2_input_read_num:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_input_read_num


  ## INPUT NORMALIZATION 1 ##

  rep1_input_normed_bed:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_input_normed_bed
  rep2_input_normed_bed:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_input_normed_bed
  rep1_input_normed_full:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_input_normed_full
  rep2_input_normed_full:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_input_normed_full
  rep1_compressed_bed:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_compressed_bed
  rep2_compressed_bed:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_compressed_bed


  ## ENTROPY FILES ##

  rep1_entropy_full:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_entropy_full
  rep2_entropy_full:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_entropy_full
  rep1_entropy_excess_reads:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_entropy_excess_reads
  rep2_entropy_excess_reads:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_entropy_excess_reads
  rep1_entropy_bed:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_entropy_bed
  rep2_entropy_bed:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_entropy_bed


  ## IDR OUTPUTS ##

  idr_output:
    type: File
    outputSource: step_get_true_reproducing_peaks/idr_output
  idr_output_bed:
    type: File
    outputSource: step_get_true_reproducing_peaks/idr_output_bed


  ## ERICS SPLIT-JOIN PEAKS ##

  rep1_idr_output_input_normed_bed:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_idr_output_input_normed_bed
  rep2_idr_output_input_normed_bed:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_idr_output_input_normed_bed
  rep1_idr_output_input_normed_full:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_idr_output_input_normed_full
  rep2_idr_output_input_normed_full:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_idr_output_input_normed_full
  rep1_reproducing_peaks_full:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep1_reproducing_peaks_full
  rep2_reproducing_peaks_full:
    type: File
    outputSource: step_get_true_reproducing_peaks/rep2_reproducing_peaks_full


  ## FINAL OUTPUTS ##

  reproducible_peaks:
    type: File
    outputSource: step_get_true_reproducing_peaks/merged_peaks_bed_file
  reproducible_peaks_narrowpeak:
    type: File
    outputSource: step_get_true_reproducing_peaks/output_narrowpeak
  reproducible_peaks_bigbed:
    type: File
    outputSource: step_get_true_reproducing_peaks/output_bigbed

  rescue_ratio:
    type: File
    outputSource: step_rescue_ratio/ratio
  
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
      rep2_clip_bam_file: rep2_clip_bam_file

      rep1_input_bam_file: rep1_input_bam_file
      rep2_input_bam_file: rep2_input_bam_file

      rep1_peaks_bed_file: rep1_peaks_bed_file
      rep2_peaks_bed_file: rep2_peaks_bed_file

      merged_peaks_bed: merged_peaks_bed
      merged_peaks_custombed: merged_peaks_custombed
      
      chrom_sizes: chrom_sizes
      species: species
      
    out:
      - rep1_clip_read_num
      - rep2_clip_read_num
      - rep1_input_read_num
      - rep2_input_read_num

      - rep1_input_normed_bed
      - rep2_input_normed_bed
      - rep1_input_normed_full
      - rep2_input_normed_full
      - rep1_compressed_bed
      - rep2_compressed_bed

      - rep1_entropy_full
      - rep2_entropy_full
      - rep1_entropy_excess_reads
      - rep2_entropy_excess_reads
      - rep1_entropy_bed
      - rep2_entropy_bed

      - idr_output
      - idr_output_bed

      - rep1_idr_output_input_normed_bed
      - rep2_idr_output_input_normed_bed
      - rep1_idr_output_input_normed_full
      - rep2_idr_output_input_normed_full
      - rep1_reproducing_peaks_full
      - rep2_reproducing_peaks_full

      - merged_peaks_bed_file
      - merged_peaks_custombed_file
      - reproducing_peaks_count
      - output_narrowpeak
      - output_bigbed
      
  step_split_merged_bam_and_idr:
    run: wf_split_self_and_idr.cwl
    in:
      clip_bam: step_merge_clip_bams/merged_bam_file
      input_bam: step_merge_input_bams/merged_bam_file
      species: species
      chrom_sizes: chrom_sizes
      merged_peaks_bed: split_peaks_bed
      merged_peaks_custombed: split_peaks_custombed

    out:
      - reproducing_peaks_count

  step_rescue_ratio:
    run: max_over_min.cwl
    in:
      count1: step_get_true_reproducing_peaks/reproducing_peaks_count
      count2: step_split_merged_bam_and_idr/reproducing_peaks_count
      output_file: 
        source: [rep1_name, rep2_name]
        valueFrom: |
          ${
            return self[0] + ".vs." + self[1] + ".rescue_ratio";
          }
    out:
      - ratio
