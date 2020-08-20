#!/usr/bin/env cwltool

### parses an IDR record sample object into distinct reads ###

cwlVersion: v1.0
class: ExpressionTool

requirements:
  - class: InlineJavascriptRequirement

inputs:

  sample:
    type:
      type: array
      items:
        type: record
        fields:
          name:
            type: string
          ip_bam:
            type: File
          input_bam:
            type: File
          peak_clusters:
            type: File

outputs:

  rep1_name:
    type: string
  rep1_ip_bam:
    type: File
  rep1_input_bam:
    type: File
  rep1_peak_clusters:
    type: File

  rep2_name:
    type: string
  rep2_ip_bam:
    type: File
  rep2_input_bam:
    type: File
  rep2_peak_clusters:
    type: File

  reproducible_peaks:
    type: string
  reproducible_peaks_custombed:
    type: string

expression: |
   ${
      return {
        'rep1_ip_bam': inputs.sample[0].ip_bam,
        'rep1_input_bam': inputs.sample[0].input_bam,
        'rep1_peak_clusters': inputs.sample[0].peak_clusters,
        'rep1_name': inputs.sample[0].name,
        'rep2_ip_bam': inputs.sample[1].ip_bam,
        'rep2_input_bam': inputs.sample[1].input_bam,
        'rep2_peak_clusters': inputs.sample[1].peak_clusters,
        'rep2_name': inputs.sample[1].name,
        'reproducible_peaks': inputs.sample[0].name + ".vs." + inputs.sample[1].name + ".bed",
        'reproducible_peaks_custombed': inputs.sample[0].name + ".vs." + inputs.sample[1].name + ".custombed"
      }
    }

doc: |
  This expressiontool parses an IDR record sample object into distinct reads
