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


#hints:
#  - class: ex:ScriptRequirement
#    scriptlines:
#      - "#!/bin/bash"


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

outputs:

  rescue_ratio:
    type: float[]
    outputSource:
      wf_full_IDR_pipeline_1input_sample/rescue_ratio
  self_consistency_ratio:
    type: float[]
    outputSource:
      wf_full_IDR_pipeline_1input_sample/self_consistency_ratio
  reproducible_peaks:
    type: File[]
    outputSource:
      wf_full_IDR_pipeline_1input_sample/reproducible_peaks

steps:

  wf_full_IDR_pipeline_1input_sample:
    run: wf_full_IDR_pipeline_1input_sample.cwl
    scatter: sample
    in:
      sample: samples
      species: species
    out: [
      rescue_ratio,
      self_consistency_ratio,
      reproducible_peaks
    ]
