#!/usr/bin/env cwltool

doc: |
  This tool wraps compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat.pl,
  which merges neighboring or overlapping regions in a BED file.
    Usage:   perl compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat.pl <in.bed> <out.compressed.bed>

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: ResourceRequirement
    coresMin: 1
    coresMax: 16
    ramMin: 16000

# hints:
#   DockerRequirement:
#     dockerPull: brianyee/perl

baseCommand: [compress_l2foldenrpeakfi_for_replicate_overlapping_bedformat.pl]

arguments: [ $(inputs.input_bed.nameroot).compressed.bed ]

inputs:

  input_bed:
    type: File
    inputBinding:
      position: -1

outputs:

  output_bed:
    type: File
    outputBinding:
      glob: $(inputs.input_bed.nameroot).compressed.bed

