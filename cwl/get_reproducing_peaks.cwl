#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: brianyee/merge_peaks:0.1.0

baseCommand: [get_reproducing_peaks.pl]

inputs:

  rep1_full_in:
    type: File
    inputBinding:
      position: 1
    doc: "rep1 full out after idr (.01.bed.full or rep1.bed.full)"
    
  rep2_full_in:
    type: File
    inputBinding:
      position: 2
    doc: "rep1 full out after idr (.02.bed.full or rep2.bed.full)"

  rep1_full_output:
    type: string
    inputBinding:
      position: 3
    doc: "rep1 full out after this step"
      
  rep2_full_output:
    type: string
    inputBinding:
      position: 4
    doc: "rep2 full out after this step"

  output_bed:
    type: string
    inputBinding:
      position: 5
    doc: "final reproducible peaks (BED6 format)"
    
  output_custombed:
    type: string
    inputBinding:
      position: 6
    doc: "final reproducible peaks (BED+extra cols format)"

  rep1_entropy_file:
    type: File
    inputBinding:
      position: 7

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

