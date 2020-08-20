#!/usr/bin/env cwltool

doc: |
  This tool wraps compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat_outputfull.pl,
  which merges neighboring or overlapping regions in a BED file.
    Usage:   perl compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat.pl <in.bed> <out.compressed.bed>

cwlVersion: v1.0

class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: brianyee/merge_peaks:0.0.6
    
baseCommand: [compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat_outputfull.pl]

arguments: [ $(inputs.input_full.nameroot).compressed.bed, $(inputs.input_full.nameroot).compressed.bed.full ]

inputs:

  input_full:
    type: File
    inputBinding:
      position: -1

outputs:

  output_bed:
    type: File
    outputBinding:
      glob: $(inputs.input_full.nameroot).compressed.bed

  output_full:
    type: File
    outputBinding:
      glob: $(inputs.input_full.nameroot).compressed.bed.full

