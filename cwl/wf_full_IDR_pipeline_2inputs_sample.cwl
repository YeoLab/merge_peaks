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

outputs:

  rescue_ratio:
    type: float
    outputSource:
      wf_full_IDR_pipeline_1input/rescue_ratio
  self_consistency_ratio:
    type: float
    outputSource:
      wf_full_IDR_pipeline_1input/self_consistency_ratio
  reproducible_peaks:
    type: File
    outputSource:
      wf_full_IDR_pipeline_1input/reproducible_peaks

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
      rep1_clip_bam_file: step_parse_sample_IDR/rep1_ip_bam
      rep1_peaks_bed_file: step_parse_sample_IDR/rep1_peak_clusters
      rep2_clip_bam_file: step_parse_sample_IDR/rep2_ip_bam
      rep2_peaks_bed_file: step_parse_sample_IDR/rep2_peak_clusters
      input_bam_file: step_parse_sample_IDR/rep1_input_bam
      species: species
      merged_peaks_bed: step_parse_sample_IDR/reproducible_peaks
      merged_peaks_custombed: step_parse_sample_IDR/reproducible_peaks_custombed
    out: [
      rescue_ratio,
      reproducible_peaks,
      self_consistency_ratio
    ]