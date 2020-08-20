#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

# hints:
#   DockerRequirement:
#     dockerPull: brianyee/perl

baseCommand: [get_reproducing_peaks.pl]

inputs:


  # rep1 full out after idr (.01.bed.full or rep1.bed.full)
  rep1_full_in:
    type: File
    inputBinding:
      position: 1

  # rep1 full out after idr (.02.bed.full or rep2.bed.full)"
  rep2_full_in:
    type: File
    inputBinding:
      position: 2

  # rep1 full out after this step
  # rep1FullOutFilename:
  rep1_full_output:
    type: string
    inputBinding:
      position: 3
  # rep2 full out after this step
  # rep2FullOutFilename:
  rep2_full_output:
    type: string
    inputBinding:
      position: 4
  # final reproduced peaks?
  # bedOutFilename:
  output_bed:
    type: string
    inputBinding:
      position: 5

  # customBedOutFilename:
  output_custombed:
    type: string
    inputBinding:
      position: 6

  # rep1Entropy:
  rep1_entropy_file:
    type: File
    inputBinding:
      position: 7

  # rep2Entropy:
  rep2_entropy_file:
    type: File
    inputBinding:
      position: 8

  idr_file:
    type: File
    inputBinding:
      position: 9







outputs:


  rep1_full_output_file:
    type: File
    outputBinding:
      glob: $(inputs.rep1_full_output)
  rep2_full_output_file:
    type: File
    outputBinding:
      glob: $(inputs.rep2_full_output)
  output_bed_file:
    type: File
    outputBinding:
      glob: $(inputs.output_bed)


  output_custombed_file:
    type: File
    outputBinding:
      glob: $(inputs.output_custombed)

